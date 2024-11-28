//
//  Utils.swift
//  CustomPieChart
//
//  Created by KaayZenn on 11/08/2024.
//

import Foundation

//extension PredefinedSubcategory {
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
//    var amountTotalOfExpenses: Double {
//        let array = transactions
//            .filter { $0.type == .expense }
//            .map { $0.amount ?? 0 }
//        return array.reduce(0, +)
//    }
//    
//    var amountTotalOfExpensesAutomations: Double {
//        let array = transactions
//            .filter { $0.type == .expense && $0.isFromSubscription == true }
//            .map { $0.amount ?? 0 }
//        return array.reduce(0, +)
//    }
//    
//}
