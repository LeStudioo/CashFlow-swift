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
    @Published var textFieldEmptyString: String = ""

    @Published var textFieldEmptyDouble: Double = 0.0
    @Published var accountBalance: Double = 0.0
    @Published var cardLimit: Double = 0.0
    
}

extension CreateAccountViewModel {
    
    func valideAccount() -> Bool {
        if !accountTitle.isEmptyWithoutSpace() {
            return true
        }
        return false
    }
    
    func createNewAccount(account: Binding<Account?>) {
        let newAccount = Account(context: viewContext)
        newAccount.id = UUID()
        newAccount.title = accountTitle
        newAccount.balance = accountBalance
        newAccount.cardLimit = cardLimit
        
        account.wrappedValue = newAccount
        
        persistenceController.saveContext()
    }
    
}
