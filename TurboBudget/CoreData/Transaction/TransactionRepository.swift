//
//  TransactionRepository.swift
//  CashFlow
//
//  Created by KaayZenn on 11/08/2024.
//

import Foundation
import CoreData

final class TransactionRepository: ObservableObject {
    static let shared = TransactionRepository()
    
    @Published var transactions: [Transaction] = []
}

// MARK: - C.R.U.D
extension TransactionRepository {
    
    func fetchTransactions() {
        let context = persistenceController.container.viewContext
        var allTransactions: [Transaction] = []
        
        do {
            allTransactions = try context.fetch(Transaction.fetchRequest())
        } catch {
            print("⚠️ Error for : \(error.localizedDescription)")
        }
        
        self.transactions = allTransactions
            .sorted { $0.date > $1.date }
            .filter { !$0.isAuto && !$0.predefCategoryID.isEmpty }
    }
    
}

// MARK: - Utils
extension TransactionRepository {
    
    func getTransactionsForCategory(categoryID: String) -> [Transaction] {
        return self.transactions
            .filter { $0.predefCategoryID == categoryID }
    }
    
    func getTransactionsForSubcategory(subcategoryID: String) -> [Transaction] {
        return self.transactions
            .filter { $0.predefSubcategoryID == subcategoryID }
    }
    
}
