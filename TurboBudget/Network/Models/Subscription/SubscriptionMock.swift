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
        frequency: SubscriptionFrequency.monthly.rawValue,
        categoryID: PredefinedCategory.PREDEFCAT1.rawValue,
        subcategoryID: PredefinedSubcategory.PREDEFSUBCAT1CAT1.rawValue
    )
    
}
