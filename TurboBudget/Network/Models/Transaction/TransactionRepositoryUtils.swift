//
//  TransactionRepositoryUtils.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation

extension TransactionRepository {
    
    func transactionsByCategory(_ categoryID: String) -> [TransactionModel] {
        return self.transactions
            .filter { $0.categoryID == categoryID }
    }
    
    func transactionsBySubcategory(_ subcategoryID: String) -> [TransactionModel] {
        return self.transactions
            .filter { $0.subcategoryID == subcategoryID }
    }
}

extension TransactionRepository {
    // MARK: - Private Properties
    
    private var transactionsActualMonth: [TransactionModel] {
        let dateRange = (start: Date().startOfMonth, end: Date().endOfMonth)
        return transactions.filter { transaction in
            let date = transaction.date.withDefault
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
        return transactions.reduce(0) { $0 + ($1.amount ?? 0) }
    }
    
    private func createDailyAmounts(
        for dates: [Date],
        transactionFilter: (TransactionModel) -> Bool
    ) -> [AmountOfTransactionsByDay] {
        let amounts = dates.map { date -> AmountOfTransactionsByDay in
            let amountOfDay = transactionsActualMonth
                .filter { Calendar.current.isDate($0.date.withDefault, inSameDayAs: date) }
                .filter(transactionFilter)
                .reduce(0.0) { $0 + ($1.amount ?? 0) }
            
            // Correction du bug de date (-1 jour)
            let correctedDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            return AmountOfTransactionsByDay(day: correctedDate, amount: amountOfDay)
        }
        
        var sortedAmounts = amounts.sorted { $0.day < $1.day }
        sortedAmounts.removeLast() // Correction du nombre de valeurs
        return sortedAmounts
    }
    
    // MARK: - Public Methods
    
    func amountOfExpensesInActualMonth() -> Double {
        let expenses = filterTransactions(byType: .expense)
        return calculateTotal(for: expenses)
    }
    
    func dailyAmountOfExpensesInActualMonth() -> [AmountOfTransactionsByDay] {
        let dates = Date().allDateOfMonth
        return createDailyAmounts(for: dates) { $0.type == .expense }
    }
    
    func amountIncomeInActualMonth() -> Double {
        let incomes = filterTransactions(byType: .income) {
            PredefinedCategory.findByID($0.categoryID ?? "") != nil
        }
        return calculateTotal(for: incomes)
    }
    
    func amountIncomePerDayInActualMonth() -> [AmountOfTransactionsByDay] {
        let dates = Date().allDateOfMonth
        return createDailyAmounts(for: dates) { transaction in
            transaction.type == .income &&
            PredefinedCategory.findByID(transaction.categoryID ?? "") != nil
        }
    }
}
