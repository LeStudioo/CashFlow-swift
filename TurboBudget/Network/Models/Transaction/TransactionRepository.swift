//
//  TransactionRepository.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

import Foundation

final class TransactionRepository: ObservableObject {
    static let shared = TransactionRepository()
    
    @Published var transactions: [TransactionModel] = []
}

extension TransactionRepository {
    func fetchTransactions() {
        
    }
}
