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
        
    var expenses: [TransactionModel] {
        return transactions.filter { $0.type == .expense }
    }
    
    var incomes: [TransactionModel] {
        return transactions.filter { $0.type == .income }
    }
    
    var monthsOfTransactions: [Date] {
        var array: [DateComponents] = []
        for transaction in self.transactions {
            let components = Calendar.current.dateComponents([.month, .year], from: transaction.date.withDefault)
            if !array.contains(components) {
                array.append(components)
            }
        }
        return array.compactMap { Calendar.current.date(from: $0) }
    }
}


extension TransactionRepository {
    
    @MainActor
    func fetchTransactions(accountID: Int) async {
        do {
            let transactions = try await NetworkService.shared.sendRequest(
                apiBuilder: TransactionAPIRequester.fetch(accountID: accountID),
                responseModel: [TransactionModel].self
            )
            self.transactions = transactions
            sortTransactionsByDate()
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func fetchTransactionsWithPagination(accountID: Int, perPage: Int = 50) async {
        do {
            let transactions = try await NetworkService.shared.sendRequest(
                apiBuilder: TransactionAPIRequester.fetchWithPagination(
                    accountID: accountID,
                    perPage: perPage,
                    skip: self.transactions.count
                ),
                responseModel: [TransactionModel].self
            )
            self.transactions += transactions
            sortTransactionsByDate()
        } catch { NetworkService.handleError(error: error) }
    }
    
    /// Create transaction, add it to repository and optionally return it
    @discardableResult
    @MainActor
    func createTransaction(accountID: Int, body: TransactionModel, shouldReturn: Bool = false) async -> TransactionModel? {
        do {
            let response = try await NetworkService.shared.sendRequest(
                apiBuilder: TransactionAPIRequester.create(accountID: accountID, body: body),
                responseModel: TransactionResponseWithBalance.self
            )
            if let transaction = response.transaction, let newBalance = response.newBalance {
                self.transactions.append(transaction)
                sortTransactionsByDate()
                AccountRepository.shared.setNewBalance(accountID: accountID, newBalance: newBalance)
                return shouldReturn ? transaction : nil
            }
            return nil
        } catch {
            NetworkService.handleError(error: error)
            return nil
        }
    }
    
    /// Create transaction and optionally return it
    @discardableResult
    @MainActor
    func updateTransaction(accountID: Int, transactionID: Int, body: TransactionModel, shouldReturn: Bool = false) async -> TransactionModel? {
        do {
            let response = try await NetworkService.shared.sendRequest(
                apiBuilder: TransactionAPIRequester.update(id: transactionID, body: body),
                responseModel: TransactionResponseWithBalance.self
            )
            if let transaction = response.transaction, let newBalance = response.newBalance {
                if let index = self.transactions.map(\.id).firstIndex(of: transaction.id) {
                    self.transactions[index].name = transaction.name
                    self.transactions[index].amount = transaction.amount
                    self.transactions[index].typeNum = transaction.typeNum
                    self.transactions[index].categoryID = transaction.categoryID
                    self.transactions[index].subcategoryID = transaction.subcategoryID
                    self.transactions[index].dateISO = transaction.dateISO
                    sortTransactionsByDate()
                    AccountRepository.shared.setNewBalance(accountID: accountID, newBalance: newBalance)
                    return shouldReturn ? transaction : nil
                }
            }
            return nil
        } catch {
            NetworkService.handleError(error: error)
            return nil
        }
    }
    
    @MainActor
    func deleteTransaction(transactionID: Int) async {
        do {
            try await NetworkService.shared.sendRequest(
                apiBuilder: TransactionAPIRequester.delete(id: transactionID)
            )
            self.transactions.removeAll { $0.id == transactionID }
        } catch { NetworkService.handleError(error: error) }
    }
}

// TODO: To delete
extension TransactionRepository {
    
    var transactionsByMonthCashFlow: [Int : [TransactionModel]] {
        var groupedTransactions: [Int: [TransactionModel]] = [1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: [], 8: [], 9: [], 10: [], 11: [], 12: []]
        
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
    
}
