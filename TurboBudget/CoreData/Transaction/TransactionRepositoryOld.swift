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
        
        do {
            let transactionData = try JSONEncoder().encode(transactions)
            let json = "\"transactions\":" + (String(data: transactionData, encoding: .utf8) ?? "")
            DataForServer.shared.transactionJSON = json
            print(json)
        } catch {
            
        }
    }
    
}

// MARK: - Utils
extension TransactionRepositoryOld {
    
    func getTransactionsForCategory(categoryID: String) -> [TransactionEntity] {
        return self.transactions
            .filter { $0.predefCategoryID == categoryID }
    }
    
    func getTransactionsForSubcategory(subcategoryID: String) -> [TransactionEntity] {
        return self.transactions
            .filter { $0.predefSubcategoryID == subcategoryID }
    }
    
    var transactionsByMonth: [Int : [TransactionEntity]] {
        var groupedTransactions: [Int: [TransactionEntity]] = [1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: [], 8: [], 9: [], 10: [], 11: [], 12: []]
        
        let calendar = Calendar.current
        
        for transaction in self.transactions {
            let month = calendar.component(.month, from: transaction.date.withDefault)
            
            if groupedTransactions[month] == nil {
                groupedTransactions[month] = []
            }
            
            groupedTransactions[month]?.append(transaction)
        }
        
        for (month, transactions) in groupedTransactions {
            groupedTransactions[month] = transactions.sorted(by: { $0.date.withDefault < $1.date.withDefault })
        }
        
        return groupedTransactions
    }
    
    func totalCashFlowForSpecificMonthYear(month: Int, year: Int) -> Double {
        var amount: Double = 0.0
        
        var components = DateComponents()
        components.day = 01
        components.month = month
        components.year = year
        
        let dateOfMonthSelected = Calendar.current.date(from: components)
        
        for transaction in self.transactions {
            if let dateOfMonthSelected {
                if Calendar.current.isDate(transaction.date.withDefault, equalTo: dateOfMonthSelected, toGranularity: .month)
                    && PredefinedCategory.findByID(transaction.predefCategoryID) != nil {
                    if transaction.amount < 0 {
                        amount -= transaction.amount
                    } else {
                        amount += transaction.amount
                    }
                }
            } else { print("⚠️ dateOfMonthSelected is NIL") }
        }
        
        return amount
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
