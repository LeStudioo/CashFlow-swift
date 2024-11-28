//
//  PredefinedCategory2.swift
//  CustomPieChart
//
//  Created by KaayZenn on 11/08/2024.
//

import SwiftUI

//extension PredefinedCategory {
//    
//    func transactionsAmount(type: TransactionType, filter: Filter) -> Double {
//        var array: [TransactionModel] = []
//        
//         for transaction in transactions {
//             if filter.byDay {
//                 if Calendar.current.isDate(transaction.date.withDefault, equalTo: filter.date, toGranularity: .day) &&
//                        Calendar.current.isDate(transaction.date.withDefault, equalTo: filter.date, toGranularity: .month) &&
//                        Calendar.current.isDate(transaction.date.withDefault, equalTo: filter.date, toGranularity: .year) &&
//                        transaction.type == type { array.append(transaction) }
//             } else {
//                 if Calendar.current.isDate(transaction.date.withDefault, equalTo: filter.date, toGranularity: .month) &&
//                        Calendar.current.isDate(transaction.date.withDefault, equalTo: filter.date, toGranularity: .year) &&
//                        transaction.type == type { array.append(transaction) }
//             }
//         }
//        return array.map { $0.amount ?? 0 }.reduce(0, +)
//    }
//    
//}


//MARK: - Incomes
//extension PredefinedCategory {
//    

//    
//    func incomesTransactionsAmountForSelectedDate(filter: Filter) -> Double {
//        var array: [TransactionModel] = []
//        for transaction in incomes {
//            if filter.byDay {
//                if Calendar.current.isDate(transaction.date.withDefault, equalTo: filter.date, toGranularity: .day)
//                    && Calendar.current.isDate(transaction.date.withDefault, equalTo: filter.date, toGranularity: .month)
//                    && Calendar.current.isDate(transaction.date.withDefault, equalTo: filter.date, toGranularity: .year) {
//                    array.append(transaction)
//                }
//            } else {
//                if Calendar.current.isDate(transaction.date.withDefault, equalTo: filter.date, toGranularity: .month)
//                    && Calendar.current.isDate(transaction.date.withDefault, equalTo: filter.date, toGranularity: .year) {
//                    array.append(transaction)
//                }
//            }
//        }
//        return array.map { $0.amount ?? 0 }.reduce(0, +)
//    }
//
//    
//    //-------------------- amountIncomesByMonth() ----------------------
//    // Description : Retourne la somme de toutes les transactions qui sont des revenus, pour un mois donné
//    // Parameter : (month: Date)
//    // Output : return [TransactionEntity]
//    // Extra : No
//    //-----------------------------------------------------------
//    func amountIncomesByMonth(month: Date) -> Double {
//        return getAllTransactionsIncomeForChosenMonth(selectedDate: month)
//            .map({ $0.amount ?? 0 })
//            .reduce(0, +)
//    }
//    
//}

//MARK: - Expenses
//extension PredefinedCategory {

//    
//    //-------------------- amountExpensesByMonth() ----------------------
//    // Description : Retourne la somme de toutes les transactions qui sont des dépenses, pour un mois donné
//    // Parameter : (month: Date)
//    // Output : return [TransactionEntity]
//    // Extra : No
//    //-----------------------------------------------------------
//    func amountExpensesByMonth(month: Date) -> Double {
//        return getAllExpensesTransactionsForChosenMonth(selectedDate: month)
//            .map({ $0.amount ?? 0 })
//            .reduce(0, +)
//    }
//}

//MARK: - Incomes from automations
//extension PredefinedCategory {
//    
//    //Return the amount of TOTAL Incomes from Automation (return positif number)
//    public var amountTotalOfIncomesAutomations: Double {
//        let array = subscriptions
//            .filter { $0.type == .income }
//            .map { $0.amount ?? 0 }
//        return array.reduce(0, +)
//    }
//    
//    public func incomesAutomationsTransactionsAmountForSelectedDate(selectedDate: Date) -> Double {
//        var array: [TransactionModel] = []
//        
//        for transaction in self.subscriptions {
//            if Calendar.current.isDate(transaction.date.withDefault, equalTo: selectedDate, toGranularity: .month)
//                && Calendar.current.isDate(transaction.date.withDefault, equalTo: selectedDate, toGranularity: .year)
//                && transaction.type == .income {
//                array.append(transaction)
//            }
//        }
//        
//        return array.map { $0.amount ?? 0 }.reduce(0, +)
//    }
//    
//}

//MARK: - Expenses from automations
//extension PredefinedCategory {
//    
//    //Return the amount of TOTAL Expenses from Automation (return positif number)
//    public var amountTotalOfExpensesAutomations: Double {
//        let array = subscriptions
//            .filter { $0.type == .expense }
//            .map { $0.amount ?? 0 }
//        return array.reduce(0, +)
//    }
//    
//    public func expensesAutomationsTransactionsAmountForSelectedDate(selectedDate: Date) -> Double {
//        var array: [TransactionModel] = []
//        
//        for transaction in self.subscriptions {
//            if Calendar.current.isDate(transaction.date.withDefault, equalTo: selectedDate, toGranularity: .month)
//                && Calendar.current.isDate(transaction.date.withDefault, equalTo: selectedDate, toGranularity: .year)
//                && transaction.type == .expense {
//                array.append(transaction)
//            }
//        }
//        
//        return array.map { $0.amount ?? 0 }.reduce(0, -)
//    }
//    
//}
