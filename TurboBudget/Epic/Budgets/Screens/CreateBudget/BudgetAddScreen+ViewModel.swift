//
//  CreateBudgetViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import Foundation
import SwiftUI

extension BudgetAddScreen {
    
    final class ViewModel: ObservableObject {
        
        @Published var selectedCategory: CategoryModel?
        @Published var selectedSubcategory: SubcategoryModel?
        @Published var amountBudget: String = ""
        
        @Published var presentingConfirmationDialog: Bool = false
    }
    
}

extension BudgetAddScreen.ViewModel {
    
    func createBudget(dismiss: DismissAction) async {
        let accountStore: AccountStore = .shared
        let budgetStore: BudgetStore = .shared
        let successfullModalManager: SuccessfullModalManager = .shared
        
        guard let account = accountStore.selectedAccount, let accountID = account._id else { return }
        
        if let budget = await budgetStore.createBudget(
            accountID: accountID,
            body: .init(
                amount: amountBudget.toDouble(),
                categoryID: selectedCategory?.id,
                subcategoryID: selectedSubcategory?.id
            )
        ) {
            await dismiss()
            await successfullModalManager.showSuccessfullBudget(type: .new, budget: budget)
        }
    }
    
}

// MARK: - Utils
extension BudgetAddScreen.ViewModel {
    
    func isBudgetAlredayExist() -> Bool {
        if let sub = selectedSubcategory, sub.budget != nil {
            return true
        } else {
            return false
        }
    }
    
}

// MARK: - Validation
extension BudgetAddScreen.ViewModel {
    
    func isBudgetInCreation() -> Bool {
        if selectedCategory != nil || selectedSubcategory != nil || amountBudget.toDouble() != 0 {
            return true
        }
        return false
    }
    
    func isBudgetValid() -> Bool {
        if amountBudget.toDouble() != 0 && selectedCategory != nil && selectedSubcategory != nil {
            return true
        } else { return false }
    }
    
}
