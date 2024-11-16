//
//  TransactionMock.swift
//  CashFlow
//
//  Created by Theo Sementa on 16/11/2024.
//

import Foundation

extension TransactionModel {
    
    static let mockClassicTransaction: TransactionModel = .init(
        id: 1,
        name: "Mock Classic Transaction",
        amount: 20,
        typeNum: TransactionType.expense.rawValue,
        dateISO: Date().toISO(),
        creationDate: Date().toISO(),
        categoryID: PredefinedCategory.PREDEFCAT1.rawValue,
        subcategoryID: PredefinedSubcategory.PREDEFSUBCAT1CAT2.rawValue
    )
    
}
