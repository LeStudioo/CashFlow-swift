//
//  CreateTransactionForSavingsAccountViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 22/12/2024.
//

import Foundation
import SwiftUI

extension CreateTransactionForSavingsAccountScreen {
    
    final class ViewModel: ObservableObject {
        
        var savingsAccount: AccountModel
        var transaction: TransactionModel?
        
        @Published var transactionTitle: String = ""
        @Published var transactionAmount: String = ""
        @Published var transactionDate: Date = Date()
        
        @Published var presentingConfirmationDialog: Bool = false
        
        init(savingsAccount: AccountModel, transaction: TransactionModel?) {
            self.savingsAccount = savingsAccount
            self.transaction = transaction
            if let transaction {
                self.transactionTitle = transaction.nameDisplayed
                self.transactionAmount = transaction.amount.formatted()
                self.transactionDate = transaction.date
            }
        }
    }
}

extension CreateTransactionForSavingsAccountScreen.ViewModel {
    
    func bodyForCreation() -> TransactionDTO {
        return TransactionDTO(
            name: transactionTitle.trimmingCharacters(in: .whitespaces),
            amount: transactionAmount.toDouble(),
            dateISO: transactionDate.toISO(),
            creationDate: Date().toISO(),
            categoryID: CategoryModel.revenue?.id,
            subcategoryID: nil
        )
    }
    
    @MainActor
    func createTransaction(dismiss: DismissAction) async {
        let transactionStore: TransactionStore = .shared
        let successfullModalManager: SuccessfullModalManager = .shared
        
        guard let accountID = savingsAccount._id else { return }
        
        if let transaction = await transactionStore.createTransaction(
            accountID: accountID,
            body: bodyForCreation(),
            shouldReturn: true,
            addInRepo: false
        ) {
            TransferStore.shared.transfers.append(transaction)
            dismiss()
            successfullModalManager.showSuccessfulTransaction(type: .new, transaction: transaction)
        }
    }
    
    @MainActor
    func updateTransaction(dismiss: DismissAction) async {
        let transactionStore: TransactionStore = .shared
        let successfullModalManager: SuccessfullModalManager = .shared
        
        guard let accountID = savingsAccount._id else { return }
        guard let transactionID = transaction?.id else { return }
        
        if let transaction = await transactionStore.updateTransaction(
            accountID: accountID,
            transactionID: transactionID,
            body: bodyForCreation(),
            shouldReturn: true
        ) {
            dismiss()
            successfullModalManager.showSuccessfulTransaction(type: .update, transaction: transaction)
        }
    }
    
}

// MARK: - Verification
extension CreateTransactionForSavingsAccountScreen.ViewModel {
    
    func isTransactionInCreation() -> Bool {
        if !transactionTitle.isBlank || transactionAmount.toDouble() != 0 {
            return true
        }
        return false
    }
    
    func validateTrasaction() -> Bool {
        if !transactionTitle.isBlank && transactionAmount.toDouble() != 0.0 {
            return true
        }
        return false
    }
}
