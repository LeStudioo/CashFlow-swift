//
//  CreateAccountViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 17/02/2024.
//

import Foundation
import SwiftUI

class CreateAccountViewModel: ObservableObject {
    
    // Builder
    var type: AccountType
    var account: AccountModel?
    
    @Published var name: String = ""
    @Published var balance: String = ""
    @Published var maxAmount: String = ""
    
    @Published var presentingConfirmationDialog: Bool = false
    
    // init
    init(type: AccountType, account: AccountModel?) {
        self.type = type
        self.account = account
        if let account {
            name = account.name
            maxAmount = account.maxAmount?.formatted() ?? ""
        }
    }
}

extension CreateAccountViewModel {
    
    func isAccountInCreation() -> Bool {
        if !name.isBlank || balance.toDouble() != 0 || !maxAmount.isBlank {
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
    
    func createAccount(dismiss: DismissAction) {
        let accountRepository: AccountRepository = .shared
        let body: AccountModel
        
        if type == .classic {
            body = .init(
                name: name,
                balance: balance.toDouble(),
                typeNum: AccountType.classic.rawValue
            )
        } else {
            body = .init(
                name: name,
                balance: balance.toDouble(),
                typeNum: AccountType.savings.rawValue,
                maxAmount: maxAmount.toDouble()
            )
        }
        
        Task {
            await accountRepository.createAccount(body: body)
            await dismiss()
        }
    }
    
    func updateAccount(dismiss: DismissAction) {
        guard let account, let accountID = account.id else { return }
        
        let accountRepository: AccountRepository = .shared
        let body: AccountModel
        
        if type == .classic {
            body = .init(
                name: name
            )
        } else {
            body = .init(
                name: name,
                maxAmount: maxAmount.toDouble()
            )
        }
        
        Task {
            await accountRepository.updateAccount(accountID: accountID, body: body)
            await dismiss()
        }
    }
    
}
