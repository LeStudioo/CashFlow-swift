//
//  TransactionRepositoryUtils.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation

extension TransactionStore {
    
    func transactionsByCategory(_ categoryID: Int?) -> [TransactionModel] {
        return self.transactions
            .filter { $0.category?.id == categoryID }
    }
    
    func transactionsBySubcategory(_ subcategoryID: Int?) -> [TransactionModel] {
        return self.transactions
            .filter { $0.subcategory?.id == subcategoryID }
    }
    
    func sortTransactionsByDate() {
        self.transactions.sort { $0.date > $1.date }
    }
}

extension TransactionStore {
    // MARK: - Private Properties
    
    private var transactionsActualMonth: [TransactionModel] {
        let dateRange = (start: Date().startOfMonth, end: Date().endOfMonth)
        return transactions.filter { transaction in
            let date = transaction.date
            return date >= dateRange.start && date <= dateRange.end
        }
    }
    
    // MARK: - Private Methods
    
    private func filterTransactions(
        byType type: TransactionType,
        additionalFilter: ((TransactionModel) -> Bool)? = nil
    ) -> [TransactionModel] {
        return transactionsActualMonth.filter { transaction in
            let typeMatch = transaction.type == type
            return additionalFilter.map { typeMatch && $0(transaction) } ?? typeMatch
        }
    }
    
    private func calculateTotal(for transactions: [TransactionModel]) -> Double {
        return transactions.reduce(0) { $0 + ($1.amount) }
    }
}

extension TransactionStore {
    
    func expensesForSelectedMonth(selectedDate: Date) -> [TransactionModel] {
        var transactionsExpenses: [TransactionModel] = []
        
        for transaction in expenses
        where Calendar.current.isDate(transaction.date, equalTo: selectedDate, toGranularity: .month) {
            transactionsExpenses.append(transaction)
        }
        return transactionsExpenses
    }
    
    func amountExpensesForSelectedMonth(month: Date) -> Double {
        return expensesForSelectedMonth(selectedDate: month)
            .map(\.amount).reduce(0, +)
    }
    
    func incomesForSelectedMonth(selectedDate: Date) -> [TransactionModel] {
        var transactionsIncomes: [TransactionModel] = []
        
        for transaction in incomes
        where Calendar.current.isDate(transaction.date, equalTo: selectedDate, toGranularity: .month) {
            transactionsIncomes.append(transaction)
        }
        return transactionsIncomes
    }
    
    func amountIncomesForSelectedMonth(month: Date) -> Double {
        return incomesForSelectedMonth(selectedDate: month)
            .map(\.amount).reduce(0, +)
    }
}

extension TransactionStore {

    func amountGainOrLossByMonth(month: Date) -> Double {
        let amountOfExpenses = amountExpensesForSelectedMonth(month: month)
        let amountOfIncomes = amountIncomesForSelectedMonth(month: month)
        
        return amountOfIncomes - amountOfExpenses
    }
    
}

extension TransactionStore {
    
    func dailyTransactions(for month: Date, type: TransactionType) -> [AmountByDay] {
        let dates = month.allDateOfMonth
        var amountsByDate = Dictionary(uniqueKeysWithValues: dates.map { ($0, 0.0) })
        
        getTransactions(in: month)
            .lazy
            .filter { $0.type == type }
            .forEach { transaction in
                let dayStart = Calendar.current.startOfDay(for: transaction.date)
                amountsByDate[dayStart, default: 0] += transaction.amount
            }
        
        let result: [AmountByDay] = dates.map { AmountByDay(day: $0, amount: amountsByDate[$0] ?? 0) }
        
        return result
    }
    
    func dailySubscriptions(for month: Date, type: TransactionType) -> [AmountByDay] {
        let dates = month.allDateOfMonth
        var amountsByDate: [Date: Double] = [:]
        
        for date in dates {
            amountsByDate[date] = 0
        }
        
        getTransactionFromSubscriptions(in: month)
            .filter { $0.type == type }
            .forEach { transaction in
                if let matchingDate = dates.first(where: { Calendar.current.isDate($0, inSameDayAs: transaction.date) }) {
                    amountsByDate[matchingDate, default: 0] += transaction.amount
                }
            }
        
        let result: [AmountByDay] = dates.map { date in
            AmountByDay(day: date, amount: amountsByDate[date] ?? 0)
        }
        
        return result
    }
    
}

extension TransactionStore {
    
    func totalCashFlowForSpecificMonthYear(month: Int, year: Int) -> Double {
        var amount: Double = 0.0
        
        var components = DateComponents()
        components.day = 01
        components.month = month
        components.year = year
        
        let dateOfMonthSelected = Calendar.current.date(from: components)
        
        for transaction in self.transactions {
            if let dateOfMonthSelected {
                if Calendar.current.isDate(transaction.date, equalTo: dateOfMonthSelected, toGranularity: .month)
                    && CategoryStore.shared.findCategoryById(transaction.category?.id) != nil {
                    if transaction.type == .expense {
                        amount -= transaction.amount
                    } else if transaction.type == .income {
                        amount += transaction.amount
                    }
                }
            } else { print("⚠️ dateOfMonthSelected is NIL") }
        }
        
        return amount
    }
}
