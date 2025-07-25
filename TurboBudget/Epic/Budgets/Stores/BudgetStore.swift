//
//  BudgetStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation
import NetworkKit
import CoreModule
import StatsKit

final class BudgetStore: ObservableObject {
    static let shared = BudgetStore()
    
    @Published var budgets: [BudgetModel] = []
    
    var budgetsByCategory: [CategoryModel: [BudgetModel]] {
        let groupedBySubcategory = Dictionary(grouping: budgets) { $0.category }
        return groupedBySubcategory
            .compactMap { entry -> (key: CategoryModel, value: [BudgetModel])? in
                guard let key = entry.key else { return nil }
                return (key: key, value: entry.value)
            }
            .sorted(by: { $0.key.name < $1.key.name })
            .reduce(into: [CategoryModel: [BudgetModel]]()) { result, entry in
                result[entry.key] = entry.value
            }
    }
}

extension BudgetStore {
    
    @MainActor
    func fetchBudgets(accountID: Int) async {
        do {
            self.budgets = try await BudgetService.fetchAll(for: accountID)
        } catch { NetworkService.handleError(error: error) }
    }
    
    @discardableResult
    @MainActor
    func createBudget(accountID: Int, body: BudgetModel) async -> BudgetModel? {
        do {
            let budget = try await BudgetService.create(accountID: accountID, body: body)
            self.budgets.append(budget)
            EventService.sendEvent(key: EventKeys.budgetCreated)
            return budget
        } catch {
            NetworkService.handleError(error: error)
            return nil
        }
    }
    
    @MainActor
    func updateBudget(budgetID: Int, body: BudgetModel) async {
        do {
            let budget = try await BudgetService.update(budgetID: budgetID, body: body)
            if let index = self.budgets.firstIndex(where: { $0.id == budgetID }) {
                self.budgets[index] = budget
                EventService.sendEvent(key: EventKeys.budgetUpdated)
            }
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func deleteBudget(budgetID: Int) async {
        do {
            try await BudgetService.delete(budgetID: budgetID)
            if let index = self.budgets.firstIndex(where: { $0.id == budgetID }) {
                self.budgets.remove(at: index)
                EventService.sendEvent(key: EventKeys.budgetDeleted)
            }
        } catch { NetworkService.handleError(error: error) }
    }
}

extension BudgetStore {
 
    func reset() {
        self.budgets.removeAll()
    }
    
}
