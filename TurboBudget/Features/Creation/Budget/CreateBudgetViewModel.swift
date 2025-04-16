//
//  CreateBudgetViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import Foundation
import SwiftUI

final class CreateBudgetViewModel: ObservableObject {
    static let shared = CreateBudgetViewModel()
    
    @Published var selectedCategory: CategoryModel?
    @Published var selectedSubcategory: SubcategoryModel?
    @Published var amountBudget: String = ""
    
    @Published var presentingConfirmationDialog: Bool = false
}

extension CreateBudgetViewModel {
    
    func createBudget(dismiss: DismissAction) {
        let accountStore: AccountStore = .shared
        let budgetStore: BudgetStore = .shared
        let successfullModalManager: SuccessfullModalManager = .shared
        
        guard let account = accountStore.selectedAccount, let accountID = account.id else { return }
        
        Task {
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
    
}

// MARK: - Utils
extension CreateBudgetViewModel {
    
    func isBudgetAlredayExist() -> Bool {
        if let sub = selectedSubcategory, let _ = sub.budget {
            return true
        } else {
            return false
        }
    }
    
}

// MARK: - Validation
extension CreateBudgetViewModel {
    
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
