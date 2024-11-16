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
    
    func sortTransactionsByDate() {
        self.transactions.sort { ($0.date ?? .now) > ($1.date ?? .now) }
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

// TODO: To refacto
extension TransactionRepository {
    
    func expensesForSelectedMonth(selectedDate: Date) -> [TransactionModel] {
        var transactionsExpenses: [TransactionModel] = []
        
        for transaction in expenses {
            if Calendar.current.isDate(transaction.date.withDefault, equalTo: selectedDate, toGranularity: .month) {
                transactionsExpenses.append(transaction)
            }
        }
        return transactionsExpenses
    }
    
    
    func amountExpensesForSelectedMonth(month: Date) -> Double {
        return expensesForSelectedMonth(selectedDate: month)
            .map({ $0.amount ?? 0 })
            .reduce(0, +)
    }
    
    
    
    
    func incomesForSelectedMonth(selectedDate: Date) -> [TransactionModel] {
        var transactionsIncomes: [TransactionModel] = []
        
        for transaction in incomes {
            if Calendar.current.isDate(transaction.date.withDefault, equalTo: selectedDate, toGranularity: .month) {
                transactionsIncomes.append(transaction)
            }
        }
        return transactionsIncomes
    }
    
    func amountIncomesForSelectedMonth(month: Date) -> Double {
        return incomesForSelectedMonth(selectedDate: month)
            .map({ $0.amount ?? 0 })
            .reduce(0, +)
    }
}

extension TransactionRepository {
    
    func amountCashFlowByMonth(month: Date) -> Double {
        let amountOfExpenses = amountExpensesForSelectedMonth(month: month)
        let amountOfIncomes = amountIncomesForSelectedMonth(month: month)
        
        return amountOfIncomes - amountOfExpenses
    }

    func amountGainOrLossByMonth(month: Date) -> Double {
        let amountOfExpenses = amountExpensesForSelectedMonth(month: month)
        let amountOfIncomes = amountIncomesForSelectedMonth(month: month)
        
        return amountOfIncomes - amountOfExpenses
    }
    
}

extension TransactionRepository {
    
    func dailyIncomeAmountsForSelectedMonth(selectedDate: Date) -> [AmountOfTransactionsByDay] {
        let transactionsForTheChoosenMonth: [TransactionModel] = incomesForSelectedMonth(selectedDate: selectedDate)
            .filter { !($0.isFromSubscription ?? false) }
        
        var array: [AmountOfTransactionsByDay] = []

        let dates = selectedDate.allDateOfMonth
        
        for date in dates {
            var amountOfDay: Double = 0.0
            
            for transaction in transactionsForTheChoosenMonth {
                if Calendar.current.isDate(transaction.date.withDefault, inSameDayAs: date)
                    && PredefinedCategory.findByID(transaction.categoryID ?? "") != nil {
                    amountOfDay += transaction.amount ?? 0
                }
            }
            array.append(AmountOfTransactionsByDay(day: date, amount: amountOfDay))
        }
        
        var sortedArray = array.sorted { $0.day < $1.day }
        sortedArray.removeLast()
        return sortedArray
    }
    
    func dailyExpenseAmountsForSelectedMonth(selectedDate: Date) -> [AmountOfTransactionsByDay] {
        let transactionsForTheChoosenMonth: [TransactionModel] = expensesForSelectedMonth(selectedDate: selectedDate)
            .filter { !($0.isFromSubscription ?? false) }
                
        var array: [AmountOfTransactionsByDay] = []
        
        let dates = selectedDate.allDateOfMonth
        
        for date in dates {
            var amountOfDay: Double = 0.0
            
            for transaction in transactionsForTheChoosenMonth {
                if Calendar.current.isDate(transaction.date.withDefault, inSameDayAs: date) {
                    amountOfDay += transaction.amount ?? 0
                }
            }
            array.append(AmountOfTransactionsByDay(day: date, amount: amountOfDay))
        }
        
        var sortedArray = array.sorted { $0.day < $1.day }
        sortedArray.removeLast()
        return sortedArray
    }
    
}

extension TransactionRepository {
    
    
    func dailyAutomatedExpenseAmountsForSelectedMonth(selectedDate: Date) -> [AmountOfTransactionsByDay] {
        let transactionsFromAutomationForTheChoosenMonth: [TransactionModel] = expensesForSelectedMonth(selectedDate: selectedDate)
            .filter { $0.isFromSubscription == true }
        
        var array: [AmountOfTransactionsByDay] = []
        
        let dates = selectedDate.allDateOfMonth
        
        for date in dates {
            var amountOfDay: Double = 0.0
            
            for transaction in transactionsFromAutomationForTheChoosenMonth {
                if Calendar.current.isDate(transaction.date.withDefault, inSameDayAs: date) {
                    amountOfDay += transaction.amount ?? 0
                }
            }
            array.append(AmountOfTransactionsByDay(day: date, amount: amountOfDay))
        }
        
        var sortedArray = array.sorted { $0.day < $1.day }
        sortedArray.removeLast()
        return sortedArray
    }
    
    
    func dailyAutomatedIncomeAmountsForSelectedMonth(selectedDate: Date) -> [AmountOfTransactionsByDay] {
        let transactionsFromAutomationForTheChoosenMonth: [TransactionModel] = incomesForSelectedMonth(selectedDate: selectedDate)
            .filter { $0.isFromSubscription == true }
        
        var array: [AmountOfTransactionsByDay] = []
        
        let dates = selectedDate.allDateOfMonth
        
        for date in dates {
            var amountOfDay: Double = 0.0
            
            for transaction in transactionsFromAutomationForTheChoosenMonth {
                if Calendar.current.isDate(transaction.date.withDefault, inSameDayAs: date) {
                    amountOfDay += transaction.amount ?? 0
                }
            }
            array.append(AmountOfTransactionsByDay(day: date, amount: amountOfDay))
        }
        
        var sortedArray = array.sorted { $0.day < $1.day }
        sortedArray.removeLast()
        return sortedArray
    }
}

extension TransactionRepository {
    
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
                    && PredefinedCategory.findByID(transaction.categoryID ?? "") != nil {
                    if transaction.type == .expense {
                        amount -= transaction.amount ?? 0
                    } else if transaction.type == .income {
                        amount += transaction.amount ?? 0
                    }
                }
            } else { print("⚠️ dateOfMonthSelected is NIL") }
        }
        
        return amount
    }
}
