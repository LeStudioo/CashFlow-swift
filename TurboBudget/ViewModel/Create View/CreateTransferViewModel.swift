//
//  CreateTransferViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/11/2024.
//

import Foundation
import SwiftUI

final class CreateTransferViewModel: ObservableObject {
    
    @Published var amount: String = ""
    @Published var date: Date = .now
    @Published var senderAccount: AccountModel? = AccountRepository.shared.selectedAccount
    @Published var receiverAccount: AccountModel? = nil
    
    @Published var presentingConfirmationDialog: Bool = false
    
    // init
    init(receiverAccount: AccountModel? = nil) {
        if let receiverAccount {
            self.receiverAccount = receiverAccount
        } else {
            self.receiverAccount = AccountRepository.shared.savingsAccounts.first
        }
    }
}

extension CreateTransferViewModel {
    
    func createTransfer(dismiss: DismissAction) {
        guard let senderAccount, let receiverAccount else { return }
        guard let senderAccountID = senderAccount.id, let receiverAccountID = receiverAccount.id else { return }
        
        let transferRepository: TransferRepository = .shared
        let successfullModalManager: SuccessfullModalManager = .shared
        
        Task {
            if let transfer = await transferRepository.createTransfer(
                accountID: senderAccountID,
                body: .init(
                    amount: amount.toDouble(),
                    typeNum: AccountType.savings.rawValue,
                    dateISO: date.toISO(),
                    senderAccountID: senderAccountID,
                    receiverAccountID: receiverAccountID
                )
            ) {
                await dismiss()
                await successfullModalManager.showSuccessfulTransfer(type: .new, transfer: transfer)
            }
        }
    }
    
}

extension CreateTransferViewModel {
    
    func isTransferInCreation() -> Bool {
        if !amount.isBlank {
            return true
        }
        return false
    }
    
    func isTransferValid() -> Bool {
        if amount.toDouble() != 0 && senderAccount != nil && receiverAccount != nil {
            return true
        }
        return false
    }
    
}
