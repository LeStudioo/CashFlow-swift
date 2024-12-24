//
//  BudgetStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation

final class BudgetStore: ObservableObject {
    static let shared = BudgetStore()
    
    @Published var budgets: [BudgetModel] = []
    
    var budgetsByCategory: [CategoryModel: [BudgetModel]] {
        let groupedBySubcategory = Dictionary(grouping: budgets) { $0.category }
        return groupedBySubcategory
            .compactMap { entry -> (key: CategoryModel, value: [BudgetModel])? in
                guard let key = entry.key else { return nil } // Exclure les clés nil
                return (key: key, value: entry.value)
            }
            .sorted(by: { $0.key.name < $1.key.name }) // Trier par le nom des sous-catégories
            .reduce(into: [CategoryModel: [BudgetModel]]()) { result, entry in
                result[entry.key] = entry.value
            }
    }
}

extension BudgetStore {
    
    @MainActor
    func fetchBudgets(accountID: Int) async {
        do {
            let budgets = try await NetworkService.shared.sendRequest(
                apiBuilder: BudgetAPIRequester.fetch(accountID: accountID),
                responseModel: [BudgetModel].self
            )
            self.budgets = budgets
        } catch { NetworkService.handleError(error: error) }
    }
    
    @discardableResult
    @MainActor
    func createBudget(accountID: Int, body: BudgetModel) async -> BudgetModel? {
        do {
            let budget = try await NetworkService.shared.sendRequest(
                apiBuilder: BudgetAPIRequester.create(accountID: accountID, body: body),
                responseModel: BudgetModel.self
            )
            self.budgets.append(budget)
            return budget
        } catch {
            NetworkService.handleError(error: error)
            return nil
        }
    }
    
    @MainActor
    func updateBudget(budgetID: Int, body: BudgetModel) async {
        do {
            let budget = try await NetworkService.shared.sendRequest(
                apiBuilder: BudgetAPIRequester.update(budgetID: budgetID, body: body),
                responseModel: BudgetModel.self
            )
            if let index = self.budgets.map(\.id).firstIndex(of: budgetID) {
                self.budgets[index] = budget
            }
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func deleteBudget(budgetID: Int) async {
        do {
            try await NetworkService.shared.sendRequest(
                apiBuilder: BudgetAPIRequester.delete(budgetID: budgetID)
            )
            self.budgets.removeAll { $0.id == budgetID }
        } catch { NetworkService.handleError(error: error) }
    }
}
