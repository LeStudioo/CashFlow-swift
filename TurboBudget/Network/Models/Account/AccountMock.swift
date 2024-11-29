//
//  AccountMock.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation

extension AccountModel {
    static let mockClassicAccount: AccountModel = .init(
        id: 1,
        name: "Mock Account",
        balance: 5_000,
        typeNum: AccountType.classic.rawValue
    )
    
    static let mockClassicAccount2: AccountModel = .init(
        id: 2,
        name: "Mock Account 2",
        balance: 8_000,
        typeNum: AccountType.classic.rawValue
    )
    
    static let mockSavingsAccount: AccountModel = .init(
        id: 3,
        name: "Mock Savings Account",
        balance: 50_000,
        typeNum: AccountType.savings.rawValue
    )
    
    static let mockSavingsAccount2: AccountModel = .init(
        id: 4,
        name: "Mock Savings Account 2",
        balance: 80_000,
        typeNum: AccountType.savings.rawValue
    )
}
