//
//  AddBudgetViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 02/11/2023.
//

import Foundation
import SwiftUI

class AddBudgetViewModel: ObservableObject {
    static let shared = AddBudgetViewModel()
    let successfullModalManager = SuccessfullModalManager.shared
    
    @Published var selectedCategory: PredefinedCategory? = nil
    @Published var selectedSubcategory: PredefinedSubcategory? = nil
    @Published var amountBudget: String = ""
    
    @Published var presentingConfirmationDialog: Bool = false
    
    func createNewBudget(withError: @escaping (_ withError: CustomError?) -> Void) {
        let budgetModel = BudgetModelOld(
            title: selectedSubcategory?.title ?? "",
            amount: amountBudget.toDouble(),
            categoryID: selectedCategory?.id ?? "",
            subcategoryID: selectedSubcategory?.id ?? ""
        )
        
        do {
            let newBudget = try BudgetRepositoryOld.shared.createNewBudget(model: budgetModel)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.successfullModalManager.isPresenting = true
            }
            successfullModalManager.title = "budget_successful".localized
            successfullModalManager.subtitle = "budget_successful_desc".localized
            successfullModalManager.content = AnyView(BudgetRow(budget: newBudget, selectedDate: .constant(.now)))
            
            withError(nil)
        } catch {
            if let error = error as? CustomError {
                withError(error)
            }
        }
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
        if selectedCategory != nil || selectedSubcategory != nil || amountBudget.toDouble() != 0 {
            return true
        }
        return false
    }
    
    func validateBudget() -> Bool {
        if amountBudget.toDouble() != 0 && selectedCategory != nil && selectedSubcategory != nil {
            return true
        } else { return false }
    } 
}
