//
//  Transaction Manager.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//

import Foundation

//MARK: - Cash Flow Chart
class TransactionManager {
    
//    //-------------------- totalCashFlowForSelectedMonth ----------------------
//    // Description : Calcule le flux de trésorerie total (somme des transactions négatives et positives) pour un mois donné.
//    // Parameter : (account: Account, selectedDate: Date)
//    // Output : return Double
//    // Extra : Utilisé pour le graphique de flux de trésorerie.
//    //-----------------------------------------------------------
//    func totalCashFlowForSelectedMonth(account: Account, selectedDate: Date) -> Double {
//        var amount: Double = 0.0
//        
//        for transaction in account.transactions {
//            if let _ = PredefinedCategory.findByID(transaction.predefCategoryID) {
//                if Calendar.current.isDate(transaction.date.withDefault, equalTo: selectedDate, toGranularity: .month) {
//                    if transaction.amount < 0 { amount -= transaction.amount } else { amount += transaction.amount }
//                }
//            }
//        }
//        
//        return amount
//    }
//    
//    //-------------------- totalCashFlowForSpecificMonthYear ----------------------
//    // Description : Calcule le flux de trésorerie total (somme des transactions négatives et positives) pour un mois et une année spécifiques.
//    // Parameter : (transactions: [TransactionEntity], month: Int, year: Int)
//    // Output : return Double
//    // Extra : Cette fonction prend en compte une liste de transactions et renvoie le flux de trésorerie total pour le mois et l'année spécifiés.
//    //-----------------------------------------------------------
//    func totalCashFlowForSpecificMonthYear(transactions: [TransactionEntity], month: Int, year: Int) -> Double {
//        var amount: Double = 0.0
//        
//        var components = DateComponents()
//        components.day = 01
//        components.month = month
//        components.year = year
//        
//        let dateOfMonthSelected = Calendar.current.date(from: components)
//        
//        for transaction in transactions {
//            if let dateOfMonthSelected {
//                if Calendar.current.isDate(transaction.date.withDefault, equalTo: dateOfMonthSelected, toGranularity: .month)
//                    && PredefinedCategory.findByID(transaction.predefCategoryID) != nil {
//                    if transaction.amount < 0 { 
//                        amount -= transaction.amount
//                    } else {
//                        amount += transaction.amount
//                    }
//                }
//            } else { print("⚠️ dateOfMonthSelected is NIL") }
//        }
//        
//        return amount
//    }
}
