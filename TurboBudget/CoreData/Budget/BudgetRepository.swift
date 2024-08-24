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
    
    /// Create a new Budget
    func createNewBudget(model: BudgetModel, withSave: Bool = true) throws -> Budget {
        guard let category = PredefinedCategory.findByID(model.categoryID) else { throw CustomError.categoryNotFound }
        guard let subcategory = PredefinedSubcategory.findByID(model.subcategoryID) else { throw CustomError.subcategoryNotFound }
        
        if let budget = subcategory.budget {
            viewContext.delete(budget)
        }
        
        let newBudget = Budget(context: viewContext)
        newBudget.id = UUID()
        newBudget.title = model.title
        newBudget.amount = model.amount
        newBudget.predefCategoryID = model.categoryID
        newBudget.predefSubcategoryID = model.subcategoryID
        
        if withSave {
            self.budgets.append(newBudget)
            try persistenceController.saveContextWithThrow()
        }
        
        return newBudget
    }
    
}

extension BudgetRepository {
    
    func deleteBudgets() {
        for budget in self.budgets {
            viewContext.delete(budget)
        }
        self.budgets = []
    }
    
}
