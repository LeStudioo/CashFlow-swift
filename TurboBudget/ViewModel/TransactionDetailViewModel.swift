//
//  TransactionDetailViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 28/10/2023.
//

import Foundation
import SwiftUI

class TransactionDetailViewModel: ObservableObject {    
    @Published var selectedCategory: CategoryModel? = nil
    @Published var selectedSubcategory: SubcategoryModel? = nil
    
    @Published var bestCategory: CategoryModel? = nil
    @Published var bestSubcategory: SubcategoryModel? = nil
    
    @Published var note: String = ""
    @Published var isDeleting: Bool = false
}

extension TransactionDetailViewModel {
    
    func updateTransaction(transactionID: Int?) {
        guard let transactionID else { return }
        
        let transactionRepository: TransactionRepository = .shared
        let accountReposiotry: AccountRepository = .shared
        
        guard let account = accountReposiotry.selectedAccount, let accountID = account.id else { return }
        
        Task {
            await transactionRepository.updateTransaction(
                accountID: accountID,
                transactionID: transactionID,
                body: .init(note: note)
            )
        }
    }
        
    
    func deleteTransaction(transactionID: Int?, dismiss: DismissAction) {
        guard let transactionID else { return }
        
        let transactionRepository: TransactionRepository = .shared
        
        Task {
            await transactionRepository.deleteTransaction(transactionID: transactionID)
            await dismiss()
        }
    }
    
}

//MARK: - Utils
extension TransactionDetailViewModel {
    
    func updateCategory(transactionID: Int) {
        let accountRepository: AccountRepository = .shared
        let transactionRepository: TransactionRepository = .shared
        guard let account = accountRepository.selectedAccount, let accountID = account.id else { return }
        
        let body: TransactionModel = .init()
        
        if let selectedCategory, let newCategory = CategoryRepository.shared.findCategoryById(selectedCategory.id) {
            body.categoryID = newCategory.id
            body.subcategoryID = nil
            
            if let selectedSubcategory, let newSubcategory = CategoryRepository.shared.findSubcategoryById(selectedSubcategory.id) {
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
            }
        }
    }
    
}
