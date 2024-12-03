//
//  TransactionRepositoryOld.swift
//  CashFlow
//
//  Created by KaayZenn on 11/08/2024.
//

import Foundation
import CoreData

final class TransactionRepositoryOld: ObservableObject {
    static let shared = TransactionRepositoryOld()
    
    @Published var transactions: [TransactionEntity] = []
}

// MARK: - C.R.U.D
extension TransactionRepositoryOld {
    
    /// Fetch all transactions
    func fetchTransactions() {
        let context = persistenceController.container.viewContext
        var allTransactions: [TransactionEntity] = []
        
        do {
            allTransactions = try context.fetch(TransactionEntity.fetchRequest())
        } catch {
            print("⚠️ Error for : \(error.localizedDescription)")
        }
        
        // TODO: REMOVE AFTER 1 MONTH IN PROD
        for transaction in allTransactions {
            if transaction.predefCategoryID == "PREDEF11" {
                transaction.predefCategoryID = "PREDEFCAT11"
                PersistenceController.shared.saveContext()
            } else if transaction.predefCategoryID == "PREDEF12" {
                transaction.predefCategoryID = "PREDEFCAT12"
                PersistenceController.shared.saveContext()
            }
        }
        
        self.transactions = allTransactions
            .sorted { $0.date.withDefault > $1.date.withDefault }
            .filter { !$0.isAuto && !$0.predefCategoryID.isEmpty }
        
        do {
            let transactionData = try JSONEncoder().encode(transactions)
            let json = "\"transactions\":" + (String(data: transactionData, encoding: .utf8) ?? "")
            DataForServer.shared.transactionJSON = json
            print(json)
        } catch {
            
        }
    }
}

extension TransactionRepositoryOld {
    
    /// Delete all transactions
    func deleteTransactions() {
        for transaction in self.transactions {
            viewContext.delete(transaction)
        }
        if let account = AccountRepositoryOld.shared.mainAccount {
            account.balance = 0
        }
        self.transactions = []
    }
    
}
