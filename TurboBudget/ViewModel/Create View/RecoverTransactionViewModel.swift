//
//  RecoverTransactionViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 29/02/2024.
//

import Foundation
import SwiftUI

class RecoverTransactionViewModel: ObservableObject {
    let context = persistenceController.container.viewContext
        
    // Custom
    @Published var account: Account? = nil
    @Published var transaction: TransactionEntity? = nil
    @Published var jsonStatus: DecodeJSONStatus = .none
    
    // String variables
    @Published var jsonString: String = ""
    @Published var transactionName: String = ""
    
    // Number variables
    @Published var confettiCounter: Int = 0

    // Boolean variables
    @Published var showQRCodeScanner: Bool = false
    @Published var showImportQRCode: Bool = false
    @Published var isRenaming: Bool = false
    @Published var presentingConfirmationDialog: Bool = false
    
    // init
    init() {
        fetchAccount()
    }
}

extension RecoverTransactionViewModel {
    
    func fetchAccount() {
        let request = Account.fetchRequest()
        var accounts: [Account] = []
        do {
            accounts = try context.fetch(request)
            if !accounts.isEmpty {
                account = accounts[0]
            }
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
    
}

extension RecoverTransactionViewModel {
    
    func recoverTransaction() {
        if let account {
            if let newTransaction = JSONManager().decodeJSON(account: account, jsonString: jsonString) {
                withAnimation {
                    transaction = newTransaction
                    jsonStatus = .success
                }
            } else {
                withAnimation {
                    jsonStatus = .error
                }
            }
        }
    }
    
    func confirmTransaction() {
        if let account, let transaction {
            account.balance += transaction.amount
        }
        persistenceController.saveContext()
    }
    
}

// MARK: - Verification
extension RecoverTransactionViewModel {
    
    func isRecovering() -> Bool {
        if !jsonString.isEmpty {
            return true
        }
        return false
    }
    
}
