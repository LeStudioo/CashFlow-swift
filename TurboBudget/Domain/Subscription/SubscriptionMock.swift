//
//  SubscriptionMock.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/11/2024.
//

import Foundation

extension SubscriptionModel {
    
    static let mockClassicSubscriptionExpense: SubscriptionModel = .init(
        id: 1,
        name: "Mock Subscription Expense",
        amount: 45,
        typeNum: TransactionType.expense.rawValue,
        frequencyNum: SubscriptionFrequency.monthly.rawValue,
        categoryID: 2,
        subcategoryID: 1
    )
    
}
