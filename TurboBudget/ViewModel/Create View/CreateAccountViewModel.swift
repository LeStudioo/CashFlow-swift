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
    
    @Published var name: String = ""
    @Published var balance: String = ""
    
    @Published var presentingConfirmationDialog: Bool = false
    
}

extension CreateAccountViewModel {
    
    func isAccountInCreation() -> Bool {
        if !name.isBlank || balance.toDouble() != 0 {
            return true
        }
        return false
    }
    
    func isAccountValid() -> Bool {
        if !name.isBlank {
            return true
        }
        return false
    }
    
    func createNewAccount() {
        let newAccount = Account(context: viewContext)
        newAccount.id = UUID()
        newAccount.title = name
        newAccount.balance = balance.toDouble()
        
        AccountRepositoryOld.shared.mainAccount = newAccount
        
        persistenceController.saveContext()
    }
    
}
