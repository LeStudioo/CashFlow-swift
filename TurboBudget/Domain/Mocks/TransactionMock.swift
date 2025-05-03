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
        date: .now,
        creationDate: .now,
        category: CategoryModel.mock,
        subcategory: SubcategoryModel.mock,
        isFromSubscription: false,
        isFromApplePay: false,
        lat: 49.253518498825116,
        long: 6.05911732080831
    )
    
    static let mockTransferTransaction: TransactionModel = .init(
        id: 2,
        name: "",
        amount: 300,
        date: Date(),
        isFromSubscription: false,
        isFromApplePay: false,
        senderAccount: AccountModel.mockClassicAccount,
        receiverAccount: AccountModel.mockSavingsAccount
    )
}
