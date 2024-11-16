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
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func createTransaction(accountID: Int, body: TransactionModel) async {
        do {
            let response = try await NetworkService.shared.sendRequest(
                apiBuilder: TransactionAPIRequester.create(accountID: accountID, body: body),
                responseModel: TransactionResponseWithBalance.self
            )
            if let transaction = response.transaction, let newBalance = response.newBalance {
                self.transactions.append(transaction)
                AccountRepository.shared.setNewBalance(accountID: accountID, newBalance: newBalance)
            }
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func updateTransaction(accountID: Int, transactionID: Int, body: TransactionModel) async {
        do {
            let response = try await NetworkService.shared.sendRequest(
                apiBuilder: TransactionAPIRequester.update(id: transactionID, body: body),
                responseModel: TransactionResponseWithBalance.self
            )
            if let transaction = response.transaction, let newBalance = response.newBalance {
                if let index = self.transactions.map(\.id).firstIndex(of: transaction.id) {
                    self.transactions[index] = transaction
                }
                AccountRepository.shared.setNewBalance(accountID: accountID, newBalance: newBalance)
            }
        } catch { NetworkService.handleError(error: error) }
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
