//
//  CreateAccountViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 17/02/2024.
//

import Foundation
import SwiftUI

class CreateAccountViewModel: ObservableObject {
    let viewContext = PersistenceController.shared.container.viewContext
    
    @Published var accountTitle: String = ""
    @Published var accountBalance: String = ""
    
    @Published var presentingConfirmationDialog: Bool = false
    
}

extension CreateAccountViewModel {
    
    func isAccountInCreation() -> Bool {
        if !accountTitle.isEmpty || accountBalance.convertToDouble() != 0 {
            return true
        }
        return false
    }
    
    func valideAccount() -> Bool {
        if !accountTitle.isEmptyWithoutSpace() {
            return true
        }
        return false
    }
    
    func createNewAccount() {
        let newAccount = Account(context: viewContext)
        newAccount.id = UUID()
        newAccount.title = accountTitle
        newAccount.balance = accountBalance.convertToDouble()
        
        AccountRepository.shared.mainAccount = newAccount
        
        persistenceController.saveContext()
    }
    
}
