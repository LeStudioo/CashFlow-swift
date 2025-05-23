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
    @Published var transactionDate: Date = Date()
    @Published var selectedCategory: CategoryModel?
    @Published var selectedSubcategory: SubcategoryModel?
            
    @Published var presentingConfirmationDialog: Bool = false
    
    let accountStore: AccountStore = .shared
    let transactionStore: TransactionStore = .shared
    let successfullModalManager: SuccessfullModalManager = .shared
    
    var isEditing: Bool {
        return transaction != nil
    }
    
    // init
    init(transaction: TransactionModel? = nil) {
        if let transaction {
            self.transaction = transaction
            self.transactionTitle = transaction.nameDisplayed
            self.transactionAmount = transaction.amount.toString()
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
    
    func bodyForCreation() -> TransactionDTO {
        return TransactionDTO.body(
            name: transactionTitle.trimmingCharacters(in: .whitespaces),
            amount: transactionAmount.toDouble(),
            type: selectedCategory?.isIncome == true ? TransactionType.income.rawValue : TransactionType.expense.rawValue,
            dateISO: transactionDate.toISO(),
            categoryID: selectedCategory?.id,
            subcategoryID: selectedSubcategory?.id
        )
    }
    
    func createTransaction(dismiss: DismissAction) async {
        guard let account = accountStore.selectedAccount else { return }
        guard let accountID = account._id else { return }
        
        if let transaction = await transactionStore.createTransaction(
            accountID: accountID,
            body: bodyForCreation(),
            shouldReturn: true
        ) {
            await dismiss()
            await successfullModalManager.showSuccessfulTransaction(type: .new, transaction: transaction)
        }
    }
    
    func updateTransaction(dismiss: DismissAction) async {
        guard let account = accountStore.selectedAccount else { return }
        guard let accountID = account._id else { return }
        guard let transactionID = transaction?.id else { return }
        
        if let transaction = await transactionStore.updateTransaction(
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

// MARK: - Utils
extension CreateTransactionViewModel {
    
    func resetData() {
        transactionTitle = ""
        transactionAmount = ""
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
