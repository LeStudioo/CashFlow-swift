//
//  CategoryTransactionData.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/12/2024.
//

import Foundation

struct CategoryTransactionData {
    let category: CategoryModel
    let transactions: [TransactionModel]
    let totalAmount: Double
    
    init(category: CategoryModel, transactions: [TransactionModel]) {
        self.category = category
        self.transactions = transactions
        self.totalAmount = transactions.map { $0.amount ?? 0 }.reduce(0, +)
    }
}
