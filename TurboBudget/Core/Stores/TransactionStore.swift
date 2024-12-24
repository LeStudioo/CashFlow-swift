//
//  TransactionStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

import Foundation

final class TransactionStore: ObservableObject {
    static let shared = TransactionStore()
    
    @Published var transactions: [TransactionModel] = []
            
    var expenses: [TransactionModel] {
        return transactions.filter { $0.type == .expense }
    }
    
    var expensesCurrentMonth: [TransactionModel] {
        return expenses
            .filter { Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .month) }
    }
    
    var incomes: [TransactionModel] {
        return transactions.filter { $0.type == .income }
    }
    
    var monthsOfTransactions: [Date] {
        let calendar = Calendar.current
        
        let uniqueMonths = Set(transactions.map {
            calendar.dateComponents([.month, .year], from: $0.date)
        })
        
        return uniqueMonths.compactMap { calendar.date(from: $0) }.sorted(by: >)
    }
    
    var transactionsByMonth: [Date: [TransactionModel]] {
        let groupedByMonth = Dictionary(grouping: transactions) { transaction in
            Calendar.current.date(from: Calendar.current.dateComponents([.month, .year], from: transaction.date))!
        }
        
        return groupedByMonth
            .sorted { $0.key > $1.key }
            .reduce(into: [Date: [TransactionModel]]()) { result, entry in
                result[entry.key] = entry.value
            }
    }
    
}

extension TransactionStore {
    
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
    
    @MainActor
    private func fetchTransactionsByPeriod(accountID: Int, startDate: String, endDate: String, type: TransactionType? = nil) async  {
        do {
            let transactions = try await NetworkService.shared.sendRequest(
                apiBuilder: TransactionAPIRequester.fetchByPeriod(
                    accountID: accountID,
                    startDate: startDate,
                    endDate: endDate,
                    type: type?.rawValue
                ),
                responseModel: [TransactionModel].self
            )
            self.transactions = transactions
            sortTransactionsByDate()
        } catch { NetworkService.handleError(error: error) }
    }
    
    /// Create transaction, add it to repository and optionally return it
    @discardableResult
    @MainActor
    func createTransaction(accountID: Int, body: TransactionModel, shouldReturn: Bool = false, addInRepo: Bool = true) async -> TransactionModel? {
        do {
            let response = try await NetworkService.shared.sendRequest(
                apiBuilder: TransactionAPIRequester.create(accountID: accountID, body: body),
                responseModel: TransactionResponseWithBalance.self
            )
            if let transaction = response.transaction, let newBalance = response.newBalance {
                if addInRepo {
                    self.transactions.append(transaction)
                    sortTransactionsByDate()
                }
                AccountStore.shared.setNewBalance(accountID: accountID, newBalance: newBalance)
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
                    self.transactions[index]._name = transaction._name
                    self.transactions[index].amount = transaction.amount
                    self.transactions[index].typeNum = transaction.typeNum
                    self.transactions[index].categoryID = transaction.categoryID
                    self.transactions[index].subcategoryID = transaction.subcategoryID
                    self.transactions[index].dateISO = transaction.dateISO
                    self.transactions[index].note = transaction.note
                    sortTransactionsByDate()
                    AccountStore.shared.setNewBalance(accountID: accountID, newBalance: newBalance)
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
    func fetchCategory(name: String, transactionID: Int? = nil) async -> TransactionFetchCategoryResponse? {
        do {
            let response = try await NetworkService.shared.sendRequest(
                apiBuilder: TransactionAPIRequester.fetchCategory(name: name, transactionID: transactionID),
                responseModel: TransactionFetchCategoryResponse.self
            )
            return response
        } catch {
            NetworkService.handleError(error: error)
            return nil
        }
    }
    
    @MainActor
    func deleteTransaction(transactionID: Int) async {
        let accountRepo: AccountStore = .shared
        do {
            let response = try await NetworkService.shared.sendRequest(
                apiBuilder: TransactionAPIRequester.delete(id: transactionID),
                responseModel: TransactionResponseWithBalance.self
            )
            self.transactions.removeAll { $0.id == transactionID }
            if let newBalance = response.newBalance, let account = accountRepo.selectedAccount, let accountID = account.id {
                AccountStore.shared.setNewBalance(accountID: accountID, newBalance: newBalance)
            }
        } catch { NetworkService.handleError(error: error) }
    }
}

extension TransactionStore {
    
    func fetchTransactionsOfCurrentMonth(accountID: Int) async {
        await self.fetchTransactionsByPeriod(
            accountID: accountID,
            startDate: Date().startOfMonth.toISO(),
            endDate: Date().endOfMonth.toISO()
        )
        if self.transactions.count < 20 {
            await self.fetchTransactionsWithPagination(accountID: accountID, perPage: 30)
        }
    }
    
}
