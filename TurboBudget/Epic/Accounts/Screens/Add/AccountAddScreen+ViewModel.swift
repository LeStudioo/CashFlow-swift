//
//  CreateAccountViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 17/02/2024.
//

import Foundation
import SwiftUI

extension AccountAddScreen {
    
    final class ViewModel: ObservableObject {
        
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
    
}

extension AccountAddScreen.ViewModel {
    
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
    
    func createAccount(dismiss: DismissAction? = nil) async {
        let accountStore: AccountStore = .shared
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
        
        await accountStore.createAccount(body: body)
        if let dismiss { await dismiss() }
    }
    
    func updateAccount(dismiss: DismissAction) async {
        guard let account, let accountID = account._id else { return }
        
        let accountStore: AccountStore = .shared
        let body: AccountModel
        
        if type == .classic {
            body = .init(name: name)
        } else {
            body = .init(
                name: name,
                maxAmount: maxAmount.toDouble()
            )
        }
        
        await accountStore.updateAccount(accountID: accountID, body: body)
        await dismiss()
    }
    
}
