//
//  Transaction Manager.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//

import Foundation

class TransactionManager {
    
    //-------------------- dailyIncomeAmountsForSelectedMonth ----------------------
    // Description : Calcule les montants quotidiens des revenus pour le mois sélectionné d'un compte donné
    // Parameters :
    // - account: Account - Le compte pour lequel les transactions sont récupérées
    // - selectedDate: Date - La date du mois pour lequel les montants quotidiens sont calculés
    // Output : return [AmountOfTransactionsByDay] - Un tableau contenant les montants des transactions par jour pour le mois sélectionné
    // Extra :
    //-----------------------------------------------------------
    func dailyIncomeAmountsForSelectedMonth(account: Account, selectedDate: Date) -> [AmountOfTransactionsByDay] {
        let transactionsForTheChoosenMonth: [Transaction] = account.getAllTransactionsIncomeForChosenMonth(selectedDate: selectedDate).filter { !$0.comeFromAuto }
        
        var array: [AmountOfTransactionsByDay] = []

        let dates = selectedDate.allDateOfMonth
        
        for date in dates {
            var amountOfDay: Double = 0.0
            
            for transaction in transactionsForTheChoosenMonth {
                if Calendar.current.isDate(transaction.date.withDefault, inSameDayAs: date)
                    && transaction.amount > 0
                    && PredefinedCategory.findByID(transaction.predefCategoryID) != nil {
                    amountOfDay += transaction.amount
                }
            }
            array.append(AmountOfTransactionsByDay(day: date, amount: amountOfDay))
        }
        
        var sortedArray = array.sorted { $0.day < $1.day }
        sortedArray.removeLast()
        return sortedArray
    }
    
    //-------------------- dailyExpenseAmountsForSelectedMonth ----------------------
    // Description : Calcule les montants quotidiens des dépenses pour le mois sélectionné d'un compte donné
    // Parameters :
    // - account: Account - Le compte pour lequel les transactions sont récupérées
    // - selectedDate: Date - La date du mois pour lequel les montants quotidiens sont calculés
    // Output : return [AmountOfTransactionsByDay] - Un tableau contenant les montants des transactions par jour pour le mois sélectionné
    // Extra :
    //-----------------------------------------------------------
    func dailyExpenseAmountsForSelectedMonth(account: Account, selectedDate: Date) -> [AmountOfTransactionsByDay] {
        let transactionsForTheChoosenMonth: [Transaction] = account.getAllExpensesTransactionsForChosenMonth(selectedDate: selectedDate).filter { !$0.comeFromAuto }
                
        var array: [AmountOfTransactionsByDay] = []
        
        let dates = selectedDate.allDateOfMonth
        
        for date in dates {
            var amountOfDay: Double = 0.0
            
            for transaction in transactionsForTheChoosenMonth {
                if Calendar.current.isDate(transaction.date.withDefault, inSameDayAs: date) && transaction.amount < 0 {
                    amountOfDay -= transaction.amount
                }
            }
            array.append(AmountOfTransactionsByDay(day: date, amount: amountOfDay))
        }
        
        var sortedArray = array.sorted { $0.day < $1.day }
        sortedArray.removeLast()
        return sortedArray
    }
}

//MARK: - Automations
extension TransactionManager {
    
    //-------------------- dailyAutomatedExpenseAmountsForSelectedMonth ----------------------
    // Description : Récupère le montant de chaque transaction provenant d'une automatisation et l'ajoute dans un tableau si elles ont été effectuées le même jour (uniquement les dépenses). Renvoie ensuite un tableau du montant total des transactions par jour sur un mois sélectionné.
    // Parameter : (account: Account, selectedDate: Date)
    // Output : return [AmountOfTransactionsByDay]
    // Extra : Cette fonction filtre spécifiquement les transactions provenant d'automatisations et calcule la dépense totale pour chaque jour du mois sélectionné.
    //--------------------------------------------------------------------------------------------------
    func dailyAutomatedExpenseAmountsForSelectedMonth(account: Account, selectedDate: Date) -> [AmountOfTransactionsByDay] {
        let transactionsFromAutomationForTheChoosenMonth: [Transaction] = account.getAllExpensesTransactionsForChosenMonth(selectedDate: selectedDate).filter { $0.comeFromAuto }
        
        var array: [AmountOfTransactionsByDay] = []
        
        let dates = selectedDate.allDateOfMonth
        
        for date in dates {
            var amountOfDay: Double = 0.0
            
            for transaction in transactionsFromAutomationForTheChoosenMonth {
                if Calendar.current.isDate(transaction.date.withDefault, inSameDayAs: date) && transaction.amount < 0 {
                    amountOfDay -= transaction.amount
                }
            }
            array.append(AmountOfTransactionsByDay(day: date, amount: amountOfDay))
        }
        
        var sortedArray = array.sorted { $0.day < $1.day }
        sortedArray.removeLast()
        return sortedArray
    }
    
    //-------------------- dailyAutomatedIncomeAmountsForSelectedMonth ----------------------
    // Description : Récupère le montant de chaque transaction provenant d'une automatisation et l'ajoute dans un tableau si elles ont été effectuées le même jour (uniquement les revenus). Renvoie ensuite un tableau du montant total des transactions par jour sur un mois sélectionné.
    // Parameter : (account: Account, selectedDate: Date)
    // Output : return [AmountOfTransactionsByDay]
    // Extra : Cette fonction filtre spécifiquement les transactions provenant d'automatisations et calcule le revenu total pour chaque jour du mois sélectionné.
    //--------------------------------------------------------------------------------------------------
    func dailyAutomatedIncomeAmountsForSelectedMonth(account: Account, selectedDate: Date) -> [AmountOfTransactionsByDay] {
        let transactionsFromAutomationForTheChoosenMonth: [Transaction] = account.getAllTransactionsIncomeForChosenMonth(selectedDate: selectedDate).filter { $0.comeFromAuto }
        
        var array: [AmountOfTransactionsByDay] = []
        
        let dates = selectedDate.allDateOfMonth
        
        for date in dates {
            var amountOfDay: Double = 0.0
            
            for transaction in transactionsFromAutomationForTheChoosenMonth {
                if Calendar.current.isDate(transaction.date.withDefault, inSameDayAs: date) && transaction.amount > 0 {
                    amountOfDay += transaction.amount
                }
            }
            array.append(AmountOfTransactionsByDay(day: date, amount: amountOfDay))
        }
        
        var sortedArray = array.sorted { $0.day < $1.day }
        sortedArray.removeLast()
        return sortedArray
    }
}

//MARK: - Cash Flow Chart
extension TransactionManager {
    
    //-------------------- totalCashFlowForSelectedMonth ----------------------
    // Description : Calcule le flux de trésorerie total (somme des transactions négatives et positives) pour un mois donné.
    // Parameter : (account: Account, selectedDate: Date)
    // Output : return Double
    // Extra : Utilisé pour le graphique de flux de trésorerie.
    //-----------------------------------------------------------
    func totalCashFlowForSelectedMonth(account: Account, selectedDate: Date) -> Double {
        var amount: Double = 0.0
        
        for transaction in account.transactions {
            if let _ = PredefinedCategory.findByID(transaction.predefCategoryID) {
                if Calendar.current.isDate(transaction.date.withDefault, equalTo: selectedDate, toGranularity: .month) {
                    if transaction.amount < 0 { amount -= transaction.amount } else { amount += transaction.amount }
                }
            }
        }
        
        return amount
    }
    
    //-------------------- totalCashFlowForSpecificMonthYear ----------------------
    // Description : Calcule le flux de trésorerie total (somme des transactions négatives et positives) pour un mois et une année spécifiques.
    // Parameter : (transactions: [Transaction], month: Int, year: Int)
    // Output : return Double
    // Extra : Cette fonction prend en compte une liste de transactions et renvoie le flux de trésorerie total pour le mois et l'année spécifiés.
    //-----------------------------------------------------------
    func totalCashFlowForSpecificMonthYear(transactions: [Transaction], month: Int, year: Int) -> Double {
        var amount: Double = 0.0
        
        var components = DateComponents()
        components.day = 01
        components.month = month
        components.year = year
        
        let dateOfMonthSelected = Calendar.current.date(from: components)
        
        for transaction in transactions {
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
