//
//  Automation Manager.swift
//  CashFlow
//
//  Created by KaayZenn on 18/07/2023.
//

import Foundation

class AutomationManager {
    
} // End Class

//MARK: - Automation Expenses
extension AutomationManager {
    
    //By day
    func amountExpensesByDay(day: Date, automations: [Automation]) -> Double {
        var transactionsExpenses: [TransactionEntity] = []
        for auto in automations {
            if let transaction = auto.automationToTransaction {
                if transaction.amount < 0
                    && Calendar.current.isDate(transaction.date.withDefault, equalTo: day, toGranularity: .day) {
                    transactionsExpenses.append(transaction)
                }
            }
        }
        return transactionsExpenses.map({ $0.amount }).reduce(0, -)
    }
    
    //By month
    func amountExpensesByMonth(month: Date, automations: [Automation]) -> Double {
        var transactionsExpenses: [TransactionEntity] = []
        for auto in automations {
            if let transaction = auto.automationToTransaction {
                if transaction.amount < 0 
                    && Calendar.current.isDate(transaction.date.withDefault, equalTo: month, toGranularity: .month) {
                    transactionsExpenses.append(transaction)
                }
            }
        }
        return transactionsExpenses.map({ $0.amount }).reduce(0, -)
    }
}

//MARK: - Automation Incomes
extension AutomationManager {
    
    //By day
    func amountIncomesByDay(day: Date, automations: [Automation]) -> Double {
        var transactionsIncomes: [TransactionEntity] = []
        for auto in automations {
            if let transaction = auto.automationToTransaction {
                if transaction.amount > 0
                    && Calendar.current.isDate(transaction.date.withDefault, equalTo: day, toGranularity: .day) {
                    transactionsIncomes.append(transaction)
                }
            }
        }
        return transactionsIncomes.map({ $0.amount }).reduce(0, +)
    }
    
    //By month
    func amountIncomesByMonth(month: Date, automations: [Automation]) -> Double {
        var transactionsExpenses: [TransactionEntity] = []
        for auto in automations {
            if let transaction = auto.automationToTransaction {
                if transaction.amount > 0 && Calendar.current.isDate(transaction.date.withDefault, equalTo: month, toGranularity: .month) { transactionsExpenses.append(transaction) }
            }
        }
        return transactionsExpenses.map({ $0.amount }).reduce(0, +)
    }
}
