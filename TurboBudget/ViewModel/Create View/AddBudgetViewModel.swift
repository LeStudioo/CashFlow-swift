//
//  AddBudgetViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 02/11/2023.
//

import Foundation

class AddBudgetViewModel: ObservableObject {
    static let shared = AddBudgetViewModel()
    let viewContext = persistenceController.container.viewContext
    
    @Published var selectedCategory: PredefinedCategory? = nil
    @Published var selectedSubcategory: PredefinedSubcategory? = nil
    @Published var amountBudget: String = ""
    
    @Published var presentingConfirmationDialog: Bool = false
    
    func createNewBudget() {
        if let selectedCategory, let selectedSubcategory { //Budget for Subcategory
            if let budget = selectedSubcategory.budget {
                viewContext.delete(budget)
            }
            let newBudget = Budget(context: viewContext)
            newBudget.id = UUID()
            newBudget.title = selectedSubcategory.title
            newBudget.amount = amountBudget.convertToDouble()
            newBudget.predefCategoryID = selectedCategory.idUnique
            newBudget.predefSubcategoryID = selectedSubcategory.idUnique
        }
        
        persistenceController.saveContext()
    }
}

//MARK: - Alert
extension AddBudgetViewModel {
    func numberOfAlerts() -> Int {
        var num: Int = 0
        if let sub = selectedSubcategory, let _ = sub.budget {
            num += 1
        }
        return num
    }
    
    func isBudgetAlredayExist() -> Bool {
        if let sub = selectedSubcategory, let _ = sub.budget {
            return true
        } else {
            return false
        }
    }
}

//MARK: - Verification
extension AddBudgetViewModel {
    func isBudgetInCreation() -> Bool {
        if selectedCategory != nil || selectedSubcategory != nil || amountBudget.convertToDouble() != 0 {
            return true
        }
        return false
    }
    
    func validateBudget() -> Bool {
        if amountBudget.convertToDouble() != 0 && selectedCategory != nil && selectedSubcategory != nil {
            return true
        } else { return false }
    } 
}
