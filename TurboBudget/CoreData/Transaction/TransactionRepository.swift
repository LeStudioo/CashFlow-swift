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
        
        // TODO: REMOVE AFTER 1 MONTH IN PROD
        for transaction in allTransactions {
            if transaction.predefCategoryID == "PREDEF11" {
                transaction.predefCategoryID = PredefinedCategory.PREDEFCAT11.id
                PersistenceController.shared.saveContext()
            } else if transaction.predefCategoryID == "PREDEF12" {
                transaction.predefCategoryID = PredefinedCategory.PREDEFCAT12.id
                PersistenceController.shared.saveContext()
            }
        }
        
        self.transactions = allTransactions
            .sorted { $0.date > $1.date }
            .filter { !$0.isAuto && !$0.predefCategoryID.isEmpty }
    }
    
    func deleteTransaction(transaction: Transaction) {
        let persistenceController = PersistenceController.shared
        
        if let account = AccountRepository.shared.mainAccount {
            account.balance -= transaction.amount
        }
        persistenceController.container.viewContext.delete(transaction)

        // TODO: Voir si pas possible de faire autrement
        self.transactions.removeAll(where: { $0.id == transaction.id })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            persistenceController.saveContext()
        }
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
