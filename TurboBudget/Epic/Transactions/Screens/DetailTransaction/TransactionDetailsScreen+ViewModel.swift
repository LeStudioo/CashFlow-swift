//
//  TransactionDetailViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 28/10/2023.
//

import Foundation
import SwiftUI

extension TransactionDetailsScreen {
    
    class ViewModel: ObservableObject {
        @Published var selectedCategory: CategoryModel?
        @Published var selectedSubcategory: SubcategoryModel?
        
        @Published var bestCategory: CategoryModel?
        @Published var bestSubcategory: SubcategoryModel?
        
        @Published var note: String = ""
    }
    
}

extension TransactionDetailsScreen.ViewModel {
    
    func updateTransaction(transactionID: Int?) {
        guard let transactionID else { return }
        
        let transactionStore: TransactionStore = .shared
        let accountReposiotry: AccountStore = .shared
        
        guard let account = accountReposiotry.selectedAccount, let accountID = account._id else { return }
        
        Task {
            await transactionStore.updateTransaction(
                accountID: accountID,
                transactionID: transactionID,
                body: .init(note: note)
            )
        }
    }
    
}

// MARK: - Utils
extension TransactionDetailsScreen.ViewModel {

    @MainActor
    func updateCategory(transactionID: Int) {
        let accountStore: AccountStore = .shared
        let transactionStore: TransactionStore = .shared
        guard let account = accountStore.selectedAccount, let accountID = account._id else { return }
        
        var body: TransactionDTO = .init()
        
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
                await transactionStore.updateTransaction(
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
