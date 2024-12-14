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
        _name: "Mock Classic Transaction",
        amount: 20,
        typeNum: TransactionType.expense.rawValue,
        dateISO: Date().toISO(),
        creationDate: Date().toISO(),
        categoryID: CategoryModel.mock.id,
        subcategoryID: SubcategoryModel.mock.id
    )
    
    static let mockTransferTransaction: TransactionModel = .init(
        id: 2,
        amount: 300,
        typeNum: TransactionType.transfer.rawValue,
        dateISO: Date().toISO(),
        creationDate: Date().toISO(),
        senderAccountID: AccountModel.mockClassicAccount.id,
        receiverAccountID: AccountModel.mockSavingsAccount.id
    )
}
