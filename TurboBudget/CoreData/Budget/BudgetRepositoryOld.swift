//
//  BudgetRepositoryOld.swift
//  CashFlow
//
//  Created by Theo Sementa on 13/08/2024.
//

import Foundation

final class BudgetRepositoryOld: ObservableObject {
    static let shared = BudgetRepositoryOld()
    
    @Published var budgets: [Budget] = []
}

// MARK: - C.R.U.D
extension BudgetRepositoryOld {
    
    func fetchBudgets() {
        let request = Budget.fetchRequest()
        
        do {
            let budgets = try viewContext.fetch(request)
            self.budgets = budgets
            
            let budgetsData = try JSONEncoder().encode(budgets)
            let json = "\"budgets\":" + (String(data: budgetsData, encoding: .utf8) ?? "")
            DataForServer.shared.budgetsJSON = json
            print(json)
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
    
    /// Create a new Budget
//    func createNewBudget(model: BudgetModelOld, withSave: Bool = true) throws -> Budget {
//        guard let category = PredefinedCategory.findByID(model.categoryID) else { throw CustomError.categoryNotFound }
//        guard let subcategory = PredefinedSubcategory.findByID(model.subcategoryID) else { throw CustomError.subcategoryNotFound }
//        
//        if let budget = subcategory.budget {
//            viewContext.delete(budget)
//        }
//        
//        let newBudget = Budget(context: viewContext)
//        newBudget.id = UUID()
//        newBudget.title = model.title
//        newBudget.amount = model.amount
//        newBudget.predefCategoryID = category.id
//        newBudget.predefSubcategoryID = subcategory.id
//        
//        if withSave {
//            self.budgets.append(newBudget)
//            try persistenceController.saveContextWithThrow()
//        }
//        
//        return newBudget
//    }
    
}

// MARK: - Utils
extension BudgetRepositoryOld {
    
    func findBySubcategoryID(_ id: String) -> Budget? {
        if let budget = self.budgets.first(where: { $0.predefSubcategoryID == id }) {
            return budget
        }
        return nil
    }
    
}

extension BudgetRepositoryOld {
    
    func deleteBudgets() {
        for budget in self.budgets {
            viewContext.delete(budget)
        }
        self.budgets = []
    }
    
}
