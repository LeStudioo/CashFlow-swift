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
    
    // Preferences
    @Preference(\.cardLimitPercentage) private var cardLimitPercentage
    @Preference(\.budgetPercentage) private var budgetPercentage
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
    
    func createNewTransaction(model: TransactionModel) {
        guard let account = AccountRepository.shared.mainAccount else { return }
        guard let subcategory = PredefinedSubcategory.findByID(model.predefSubcategoryID) else { return }
        
        let newTransaction = Transaction(context: viewContext)
        newTransaction.id = UUID()
        newTransaction.title = model.title.trimmingCharacters(in: .whitespaces)
        newTransaction.amount = model.amount
        newTransaction.date = model.date
        newTransaction.creationDate = Date()
        newTransaction.comeFromAuto = false
        newTransaction.predefCategoryID = model.predefCategoryID
        newTransaction.predefSubcategoryID = model.predefSubcategoryID
        
        account.addNewTransaction(transaction: newTransaction)
        
        // Card Limit
        // TODO: Faire un alert manager pour le isCardLimit
        if account.cardLimit != 0 {
            let percentage = account.amountOfExpensesInActualMonth() / Double(account.cardLimit)
            if percentage >= cardLimitPercentage / 100 && percentage <= 1 { isCardLimitSoonToBeExceeded = true }
            if percentage > 1 { isCardLimitExceeded = true }
        }
        
        // Budget
        if let budget = subcategory.budget {
            let percentage = budget.actualAmountForMonth(month: .now) / budget.amount
            if percentage >= budgetPercentage / 100 && percentage <= 1 {
                isBudgetSoonToBeExceeded = true
            }
            if percentage > 1 { isBudgetExceed = true }
        }
    }
    
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
