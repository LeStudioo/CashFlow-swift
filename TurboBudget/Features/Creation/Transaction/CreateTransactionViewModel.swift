//
//  CreateTransactionViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 26/10/2023.
//

import Foundation
import SwiftUI

final class CreateTransactionViewModel: ObservableObject {
    
    var transaction: TransactionModel?
    
    @Published var transactionTitle: String = ""
    @Published var transactionAmount: String = ""
    @Published var transactionType: TransactionType = .expense
    @Published var transactionDate: Date = Date()
    @Published var selectedCategory: CategoryModel?
    @Published var selectedSubcategory: SubcategoryModel?
            
    @Published var presentingConfirmationDialog: Bool = false
    
    // init
    init(transaction: TransactionModel? = nil) {
        if let transaction {
            self.transaction = transaction
            self.transactionTitle = transaction.name
            self.transactionAmount = transaction.amount?.formatted() ?? ""
            self.transactionType = transaction.type
            self.transactionDate = transaction.date
            self.selectedCategory = transaction.category
            self.selectedSubcategory = transaction.subcategory
        }
    }
        
    // TODO: Faire un POC Scanner
//    func makeScannerView() -> ScannerTicketView {
//        ScannerTicketView { amount, date, errorMessage in
//            if let amount { self.transactionAmount = String(amount) }
//            if let date { self.transactionDate = date }
//        }
//    }
    
    func onChangeType(newValue: TransactionType) {
        if newValue == .income {
            selectedCategory = CategoryModel.revenue
            selectedSubcategory = nil
        } else if newValue == .expense && selectedCategory == CategoryModel.revenue {
            selectedCategory = nil
            selectedSubcategory = nil
        }
    }
    
    func bodyForCreation() -> TransactionModel {
        return TransactionModel(
            _name: transactionTitle.trimmingCharacters(in: .whitespaces),
            amount: transactionAmount.toDouble(),
            typeNum: transactionType.rawValue,
            dateISO: transactionDate.toISO(),
            creationDate: Date().toISO(),
            categoryID: transactionType == .income ? CategoryModel.revenue?.id : selectedCategory?.id,
            subcategoryID: transactionType == .income ? nil : selectedSubcategory?.id
        )
    }
    
    func createTransaction(dismiss: DismissAction) {
        let accountRepository: AccountStore = .shared
        let transactionRepository: TransactionStore = .shared
        let successfullModalManager: SuccessfullModalManager = .shared
        
        Task {
            guard let account = accountRepository.selectedAccount else { return }
            guard let accountID = account.id else { return }
                        
            if let transaction = await transactionRepository.createTransaction(
                accountID: accountID,
                body: bodyForCreation(),
                shouldReturn: true
            ) {
                await dismiss()
                await successfullModalManager.showSuccessfulTransaction(type: .new, transaction: transaction)
            }
        }
    }
    
    func updateTransaction(dismiss: DismissAction) {
        let accountRepository: AccountStore = .shared
        let transactionRepository: TransactionStore = .shared
        let successfullModalManager: SuccessfullModalManager = .shared
        
        Task {
            guard let account = accountRepository.selectedAccount else { return }
            guard let accountID = account.id else { return }
            guard let transactionID = transaction?.id else { return }
            
            if let transaction = await transactionRepository.updateTransaction(
                accountID: accountID,
                transactionID: transactionID,
                body: bodyForCreation(),
                shouldReturn: true
            ) {
                await dismiss()
                await successfullModalManager.showSuccessfulTransaction(type: .update, transaction: transaction)
            }
        }
    }
        
}

// MARK: - Utils
extension CreateTransactionViewModel {
    
    func resetData() {
        transactionTitle = ""
        transactionAmount = ""
        transactionType = .expense
        transactionDate = Date()
        selectedCategory = nil
        selectedSubcategory = nil
    }
    
}

// MARK: - Verification
extension CreateTransactionViewModel {
    
    func isTransactionInCreation() -> Bool {
        if selectedCategory != nil || selectedSubcategory != nil || !transactionTitle.isEmpty || transactionAmount.toDouble() != 0 {
            return true
        }
        return false
    }
    
    func validateTrasaction() -> Bool {
        if !transactionTitle.isBlank && transactionAmount.toDouble() != 0.0 && selectedCategory != nil {
            return true
        }
        return false
    }
}
