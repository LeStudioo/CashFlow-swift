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
    
    /// Fetch all transactions
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
            .sorted { $0.date.withDefault > $1.date.withDefault }
            .filter { !$0.isAuto && !$0.predefCategoryID.isEmpty }
    }
    
    /// Create a new transaction
    func createNewTransaction(model: TransactionModel, withSave: Bool = true) throws -> Transaction {
        guard let account = AccountRepository.shared.mainAccount else { throw CustomError.noAccount }
        guard let category = PredefinedCategory.findByID(model.predefCategoryID) else { throw CustomError.categoryNotFound }
        guard let subcategory = PredefinedSubcategory.findByID(model.predefSubcategoryID) else { throw CustomError.subcategoryNotFound }
                
        let newTransaction = Transaction(context: viewContext)
        newTransaction.id = UUID()
        newTransaction.title = model.title.trimmingCharacters(in: .whitespaces)
        newTransaction.amount = model.amount
        newTransaction.date = model.date
        newTransaction.isAuto = model.isAuto
        newTransaction.creationDate = .now
        newTransaction.predefCategoryID = category.id
        newTransaction.predefSubcategoryID = subcategory.id
        newTransaction.transactionToAccount = account
        
        if withSave {
            self.transactions.append(newTransaction)
            try persistenceController.saveContextWithThrow()
        }
        
        return newTransaction
    }
    
    /// Delete a transaction
    func deleteTransaction(transaction: Transaction) {
        if let account = AccountRepository.shared.mainAccount {
            account.balance -= transaction.amount
        }
        
        viewContext.delete(transaction)

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

extension TransactionRepository {
    
    /// Delete all transactions
    func deleteTransactions() {
        for transaction in self.transactions {
            viewContext.delete(transaction)
        }
        if let account = AccountRepository.shared.mainAccount {
            account.balance = 0
        }
        self.transactions = []
    }
    
}
