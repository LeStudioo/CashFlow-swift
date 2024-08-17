//
//  BudgetRepository.swift
//  CashFlow
//
//  Created by Theo Sementa on 13/08/2024.
//

import Foundation

final class BudgetRepository: ObservableObject {
    static let shared = BudgetRepository()
    
    @Published var budgets: [Budget] = []
}

// MARK: - C.R.U.D
extension BudgetRepository {
    
    func fetchBudgets() {
        let request = Budget.fetchRequest()
        
        do {
            let budgets = try viewContext.fetch(request)
            self.budgets = budgets
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
    
    func deleteBudgets() {
        for budget in self.budgets {
            viewContext.delete(budget)
        }
        self.budgets = []
    }
    
}
