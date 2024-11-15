//
//  BudgetRepository.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation

final class BudgetRepository: ObservableObject {
    static let shared = BudgetRepository()
    
    @Published var budgets: [BudgetModel] = []
}

extension BudgetRepository {
    
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
    
    @MainActor
    func createBudget(accountID: Int, body: BudgetModel) async {
        do {
            let budget = try await NetworkService.shared.sendRequest(
                apiBuilder: BudgetAPIRequester.create(accountID: accountID, body: body),
                responseModel: BudgetModel.self
            )
            self.budgets.append(budget)
        } catch { NetworkService.handleError(error: error) }
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
