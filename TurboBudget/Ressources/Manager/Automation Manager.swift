//
//  Automation Manager.swift
//  CashFlow
//
//  Created by KaayZenn on 18/07/2023.
//

import Foundation

class AutomationManager {
    
    //-------------------- activateScheduledAutomations ----------------------
    // Description : Vérifie si des automatisations sont prévues pour aujourd'hui et les active si c'est le cas.
    // Parameter : (automations: [Automation])
    // Output : Void
    // Extra : Cette fonction crée également une nouvelle transaction à partir de l'automatisation et met à jour la date de l'automatisation pour la prochaine occurrence.
    //-----------------------------------------------------------
    func activateScheduledAutomations(automations: [Automation]) {
        for automation in automations {
            if Calendar.current.isDate(automation.date, inSameDayAs: Date()) && Calendar.current.isDate(automation.date, equalTo: Date(), toGranularity: .month) || automation.date < Date() {
                if let account = automation.automationToAccount {
                    
                    var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: automation.date)
                    dateComponents.year = Date().currentYearValue()
                    let finalDate = Calendar.current.date(from: dateComponents)
                    
                    if let transactionOfAuto = automation.automationToTransaction {
                        let newTransaction = Transaction(context: persistenceController.container.viewContext)
                        newTransaction.id = UUID()
                        newTransaction.title = transactionOfAuto.title
                        newTransaction.amount = transactionOfAuto.amount
                        newTransaction.date = finalDate ?? Date()
                        newTransaction.creationDate = .now
                        newTransaction.comeFromAuto = true
                        newTransaction.transactionToAccount = account
                        newTransaction.predefCategoryID = transactionOfAuto.predefCategoryID
                        newTransaction.predefSubcategoryID = transactionOfAuto.predefSubcategoryID
                    
                        account.balance += newTransaction.amount
                        
                        if automation.frenquently == 0 {
                            transactionOfAuto.date = Calendar.current.date(byAdding: .month, value: 1, to: transactionOfAuto.date)!
                        } else {
                            transactionOfAuto.date = Calendar.current.date(byAdding: .year, value: 1, to: transactionOfAuto.date)!
                        }
                        
                        persistenceController.saveContext()
                    }
                }
                
                if automation.frenquently == 0 {
                    automation.date = Calendar.current.date(byAdding: .month, value: 1, to: automation.date)!
                } else {
                    automation.date = Calendar.current.date(byAdding: .year, value: 1, to: automation.date)!
                }
                
                persistenceController.saveContext()
            }
        }
    }
} // End Class

//MARK: - Automation Expenses
extension AutomationManager {
    
    //By day
    func amountExpensesByDay(day: Date, automations: [Automation]) -> Double {
        var transactionsExpenses: [Transaction] = []
        for auto in automations {
            if let transaction = auto.automationToTransaction {
                if transaction.amount < 0 && Calendar.current.isDate(transaction.date, equalTo: day, toGranularity: .day) { transactionsExpenses.append(transaction) }
            }
        }
        return transactionsExpenses.map({ $0.amount }).reduce(0, -)
    }
    
    //By month
    func amountExpensesByMonth(month: Date, automations: [Automation]) -> Double {
        var transactionsExpenses: [Transaction] = []
        for auto in automations {
            if let transaction = auto.automationToTransaction {
                if transaction.amount < 0 && Calendar.current.isDate(transaction.date, equalTo: month, toGranularity: .month) { transactionsExpenses.append(transaction) }
            }
        }
        return transactionsExpenses.map({ $0.amount }).reduce(0, -)
    }
}

//MARK: - Automation Incomes
extension AutomationManager {
    
    //By day
    func amountIncomesByDay(day: Date, automations: [Automation]) -> Double {
        var transactionsIncomes: [Transaction] = []
        for auto in automations {
            if let transaction = auto.automationToTransaction {
                if transaction.amount > 0 && Calendar.current.isDate(transaction.date, equalTo: day, toGranularity: .day) { transactionsIncomes.append(transaction) }
            }
        }
        return transactionsIncomes.map({ $0.amount }).reduce(0, +)
    }
    
    //By month
    func amountIncomesByMonth(month: Date, automations: [Automation]) -> Double {
        var transactionsExpenses: [Transaction] = []
        for auto in automations {
            if let transaction = auto.automationToTransaction {
                if transaction.amount > 0 && Calendar.current.isDate(transaction.date, equalTo: month, toGranularity: .month) { transactionsExpenses.append(transaction) }
            }
        }
        return transactionsExpenses.map({ $0.amount }).reduce(0, +)
    }
}
