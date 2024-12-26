//
//  TransactionDetailViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 28/10/2023.
//

import Foundation
import SwiftUI

class TransactionDetailViewModel: ObservableObject {    
    @Published var selectedCategory: CategoryModel?
    @Published var selectedSubcategory: SubcategoryModel?
    
    @Published var bestCategory: CategoryModel?
    @Published var bestSubcategory: SubcategoryModel?
    
    @Published var note: String = ""
}

extension TransactionDetailViewModel {
    
    func updateTransaction(transactionID: Int?) {
        guard let transactionID else { return }
        
        let transactionRepository: TransactionStore = .shared
        let accountReposiotry: AccountStore = .shared
        
        guard let account = accountReposiotry.selectedAccount, let accountID = account.id else { return }
        
        Task {
            await transactionRepository.updateTransaction(
                accountID: accountID,
                transactionID: transactionID,
                body: .init(note: note)
            )
        }
    }
    
}

//MARK: - Utils
extension TransactionDetailViewModel {

    @MainActor
    func updateCategory(transactionID: Int) {
        let accountRepository: AccountStore = .shared
        let transactionRepository: TransactionStore = .shared
        guard let account = accountRepository.selectedAccount, let accountID = account.id else { return }
        
        let body: TransactionModel = .init()
        
        if let selectedCategory, let newCategory = CategoryStore.shared.findCategoryById(selectedCategory.id) {
            body.categoryID = newCategory.id
            body.subcategoryID = nil
            
            if newCategory.id == 0 {
                selectedSubcategory = nil
            }
            
            if let selectedSubcategory, let newSubcategory = CategoryStore.shared.findSubcategoryById(selectedSubcategory.id) {
                body.subcategoryID = newSubcategory.id
            }
            
            Task {
                await transactionRepository.updateTransaction(
                    accountID: accountID,
                    transactionID: transactionID,
                    body: body
                )
                
                self.selectedCategory = nil
                self.selectedSubcategory = nil
                self.bestCategory = nil
                self.bestSubcategory = nil
            }
        }
    }
    
}
