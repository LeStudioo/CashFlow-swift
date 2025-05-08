//
//  SubcategoryTransactionData.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/12/2024.
//

import Foundation

struct SubcategoryTransactionData {
    let subcategory: SubcategoryModel
    let transactions: [TransactionModel]
    let totalAmount: Double
    
    init(subcategory: SubcategoryModel, transactions: [TransactionModel]) {
        self.subcategory = subcategory
        self.transactions = transactions
        self.totalAmount = transactions.map(\.amount).reduce(0, +)
    }
}
