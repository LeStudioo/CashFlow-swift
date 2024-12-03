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
    
    @Published var selectedCategory: CategoryModel? = nil
    @Published var selectedSubcategory: SubcategoryModel? = nil
    @Published var amountBudget: String = ""
    
    @Published var presentingConfirmationDialog: Bool = false
}

extension CreateBudgetViewModel {
    
    func createBudget(dismiss: DismissAction) {
        let accountRepository: AccountRepository = .shared
        let budgetRepository: BudgetRepository = .shared
        let successfullModalManager: SuccessfullModalManager = .shared
        
        guard let account = accountRepository.selectedAccount, let accountID = account.id else { return }
        
        Task {
            if let budget = await budgetRepository.createBudget(
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
