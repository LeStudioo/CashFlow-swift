//
//  SavingsAccountStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/11/2024.
//

import Foundation

final class SavingsAccountStore: ObservableObject {
    
    @Published var currentAccount: AccountModel
    
    init(currentAccount: AccountModel) {
        self.currentAccount = currentAccount
    }
    
}
