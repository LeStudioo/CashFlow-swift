//
//  CreateTransferViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 16/03/2024.
//

import Foundation
import CoreData

class CreateTransferViewModel: ObservableObject {
    let context = PersistenceController.shared.container.viewContext
    
    // Custom
    @Published var mainAccount: Account? = nil
    @Published var savingsAccount: [SavingsAccount] = []
    @Published var selectedSavingsAccount: SavingsAccount? = nil
    @Published var selectedSavingsAccountID: String = ""
    
    // String variables
    @Published var transferAmount: String = ""
    
    // Bool variables
    @Published var presentingConfirmationDialog: Bool = false
    
    // Data variables
    @Published var transferDate: Date = Date()
    
    // Enum
    @Published var typeTransfer: ExpenseOrIncome = .expense
    
    // init
    init() {
        fetchAccount()
        fetchSavingsAccounts()
    }
}


extension CreateTransferViewModel {
    
    func fetchAccount() {
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        var allAccount: [Account] = []
        do {
            allAccount = try context.fetch(fetchRequest)
            if allAccount.count != 0 {
                mainAccount = allAccount[0]
            }
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
    
    func fetchSavingsAccounts() {
        let fetchRequest: NSFetchRequest<SavingsAccount> = SavingsAccount.fetchRequest()
        var allSavingsAccount: [SavingsAccount] = []
        do {
            allSavingsAccount = try context.fetch(fetchRequest)
            self.savingsAccount = allSavingsAccount
            if let first = savingsAccount.first {
                selectedSavingsAccount = first
                selectedSavingsAccountID = first.id.uuidString
            }
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
    
    func findSavingsAccountByID(idSearched: String) {
        for savingsAccount in self.savingsAccount {
            if savingsAccount.id.uuidString == idSearched {
                selectedSavingsAccount = savingsAccount
            }
        }
    }
    
}

// MARK: - Verification
extension CreateTransferViewModel {
    
    func isTransferInCreation() -> Bool {
        if !transferAmount.isEmpty {
            return true
        }
        return false
    }
    
}
