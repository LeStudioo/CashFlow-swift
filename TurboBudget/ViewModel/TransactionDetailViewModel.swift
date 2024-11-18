//
//  TransactionDetailViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 28/10/2023.
//

import Foundation
import CoreData

class TransactionDetailViewModel: ObservableObject {    
    @Published var selectedCategory: PredefinedCategory? = nil
    @Published var selectedSubcategory: PredefinedSubcategory? = nil
}

//MARK: - Utils
extension TransactionDetailViewModel {
    
    func updateCategory(transactionID: Int) {
        let accountRepository: AccountRepository = .shared
        let transactionRepository: TransactionRepository = .shared
        guard let account = accountRepository.selectedAccount, let accountID = account.id else { return }
        
        let body: TransactionModel = .init()
        
        if let selectedCategory, let newCategory = PredefinedCategory.findByID(selectedCategory.id) {
            body.categoryID = newCategory.id
            body.subcategoryID = ""
            
            if let selectedSubcategory, let newSubcategory = newCategory.subcategories.findByID(selectedSubcategory.id) {
                body.subcategoryID = newSubcategory.id
            }
            
            Task {
                await transactionRepository.updateTransaction(
                    accountID: accountID,
                    transactionID: transactionID,
                    body: body
                )
            }
        }
    }
    
}
