//
//  CreateSavingsAccountViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 15/03/2024.
//

import Foundation

class CreateSavingsAccountViewModel: ObservableObject {
    let persistenceController = PersistenceController.shared
    
    @Published var accountTitle: String = ""
    @Published var accountBalance: String = ""
    @Published var accountMaxAmount: String = ""
    
    @Published var presentingConfirmationDialog: Bool = false
    
}

extension CreateSavingsAccountViewModel {
    
    func createSavingsAccount() {
        let newSavingsAccount = SavingsAccount(context: persistenceController.container.viewContext)
        newSavingsAccount.id = UUID()
        newSavingsAccount.name = accountTitle
        newSavingsAccount.balanceAtStart = accountBalance.toDouble()
        newSavingsAccount.maxAmount = accountMaxAmount.toDouble()
        
        persistenceController.saveContext()
    }
    
}

// MARK: - Verification
extension CreateSavingsAccountViewModel {
    
    func isSavingsAccountInCreation() -> Bool {
        if !accountTitle.isEmpty || !accountBalance.isEmpty || !accountMaxAmount.isEmpty {
            return true
        }
        return false
    }
    
    func isSavingsAccountValid() -> Bool {
        if !accountTitle.isEmpty && !accountBalance.isEmpty && !accountMaxAmount.isEmpty {
            return true
        }
        return false
    }
    
}
