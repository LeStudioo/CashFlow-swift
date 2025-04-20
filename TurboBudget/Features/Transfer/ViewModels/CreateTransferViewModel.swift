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
    @Published var senderAccount: AccountModel? = AccountStore.shared.selectedAccount
    @Published var receiverAccount: AccountModel?
    
    @Published var presentingConfirmationDialog: Bool = false
    
    // init
    init(receiverAccount: AccountModel? = nil) {
        if let receiverAccount {
            self.receiverAccount = receiverAccount
        } else {
            self.receiverAccount = AccountStore.shared.savingsAccounts.first
        }
    }
}

extension CreateTransferViewModel {
    
    func createTransfer(dismiss: DismissAction) async {
        guard let senderAccount, let receiverAccount else { return }
        guard let senderAccountID = senderAccount._id, let receiverAccountID = receiverAccount._id else { return }
        
        let transferStore: TransferStore = .shared
        let successfullModalManager: SuccessfullModalManager = .shared
        
        if let transfer = await transferStore.createTransfer(
            senderAccountID: senderAccountID,
            receiverAccountID: receiverAccountID,
            body: .init(
                amount: amount.toDouble(),
                date: date.toISO()
            )
        ) {
            await dismiss()
            await successfullModalManager.showSuccessfulTransfer(type: .new, transfer: transfer)
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
