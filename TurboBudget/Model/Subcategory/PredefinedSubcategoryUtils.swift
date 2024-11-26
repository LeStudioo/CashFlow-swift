//
//  Utils.swift
//  CustomPieChart
//
//  Created by KaayZenn on 11/08/2024.
//

import Foundation

//extension PredefinedSubcategory {
//    
//    // Voir pour essayer de passer en throw pour ne pas retourner un optionnel
//    static func findByID(_ id: String) -> PredefinedSubcategory? {
//        for subcat in PredefinedSubcategory.allCases {
//            if subcat.id == id { return subcat }
//        }
//        return nil
//    }
//    
//}

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
//    func expensesAutomationsTransactionsAmountForSelectedDate(selectedDate: Date) -> Double {
//        var array: [TransactionModel] = []
//        
//        for transaction in self.subscriptions {
//            if Calendar.current.isDate(transaction.date.withDefault, equalTo: selectedDate, toGranularity: .month) && Calendar.current.isDate(transaction.date.withDefault, equalTo: selectedDate, toGranularity: .year) &&
//                transaction.type == .expense {
//                array.append(transaction)
//            }
//        }
//        
//        return array.map { $0.amount ?? 0 }.reduce(0, -)
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

//extension Array where Element == PredefinedSubcategory {
//    
//    // Voir pour essayer de passer en throw pour ne pas retourner un optionnel
//    func findByID(_ id: String?) -> PredefinedSubcategory? {
//        if let id {
//            for subcat in PredefinedSubcategory.allCases {
//                if subcat.id == id { return subcat }
//            }
//        }
//        return nil
//    }
//    
//}

//extension PredefinedSubcategory {
//    
//    //MARK: - Expenses from automations
//    func amountExpensesByMonth(month: Date) -> Double {
//            return getAllExpensesTransactionsForChosenMonth(selectedDate: month)
//            .map({ $0.amount ?? 0 })
//            .reduce(0, +)
//        }
//    
//    //MARK: - Extension Expenses
//    
//    //-------------------- getAllExpensesTransactionsForChosenMonth() ----------------------
//    // Description : Récupère toutes les transactions qui sont des dépenses, pour un mois donné
//    // Parameter : (selectedDate: Date)
//    // Output : return [TransactionEntity]
//    // Extra : No
//    //-----------------------------------------------------------
//    func getAllExpensesTransactionsForChosenMonth(selectedDate: Date) -> [TransactionModel] {
//        var transactionsExpenses: [TransactionModel] = []
//        
//        for transaction in transactions {
//            if transaction.type == .expense
//                && Calendar.current.isDate(transaction.date.withDefault, equalTo: selectedDate, toGranularity: .month) {
//                    transactionsExpenses.append(transaction)
//            }
//        }
//        return transactionsExpenses
//    }
//    
//    
//    
//    //MARK: - Extension Incomes
//    
//    //-------------------- getAllTransactionsIncomeForChosenMonth() ----------------------
//    // Description : Récupère tous les transactions qui sont des revenus, pour un mois donné
//    // Parameter : (selectedDate: Date)
//    // Output : return [TransactionEntity]
//    // Extra : No
//    //-----------------------------------------------------------
//    func getAllTransactionsIncomeForChosenMonth(selectedDate: Date) -> [TransactionModel] {
//        var transactionsIncomes: [TransactionModel] = []
//        
//        for transaction in transactions {
//            if transaction.type == .income
//                && Calendar.current.isDate(transaction.date.withDefault, equalTo: selectedDate, toGranularity: .month)
//                && transaction.category != nil {
//                    transactionsIncomes.append(transaction)
//            }
//        }
//        return transactionsIncomes
//    }
//        
//        //-------------------- amountIncomesByMonth() ----------------------
//        // Description : Retourne la somme de toutes les transactions qui sont des revenus, pour un mois donné
//        // Parameter : (month: Date)
//        // Output : return [TransactionEntity]
//        // Extra : No
//        //-----------------------------------------------------------
//        func amountIncomesByMonth(month: Date) -> Double {
//            return getAllTransactionsIncomeForChosenMonth(selectedDate: month)
//                .map({ $0.amount ?? 0 })
//                .reduce(0, +)
//        }
//        
//    }





//{
//    switch self {
//    case .PREDEFSUBCAT1CAT1: return
//    case .PREDEFSUBCAT2CAT1: return
//    case .PREDEFSUBCAT3CAT1: return
//    case .PREDEFSUBCAT4CAT1: return
//    case .PREDEFSUBCAT5CAT1: return
//    case .PREDEFSUBCAT6CAT1: return
//    case .PREDEFSUBCAT7CAT1: return
//    case .PREDEFSUBCAT8CAT1: return
//    case .PREDEFSUBCAT9CAT1: return
//    case .PREDEFSUBCAT10CAT1: return
//
//    case .PREDEFSUBCAT1CAT2: return
//    case .PREDEFSUBCAT2CAT2: return
//    case .PREDEFSUBCAT3CAT2: return
//    case .PREDEFSUBCAT4CAT2: return
//    case .PREDEFSUBCAT5CAT2: return
//
//    case .PREDEFSUBCAT1CAT3: return
//    case .PREDEFSUBCAT2CAT3: return
//    case .PREDEFSUBCAT3CAT3: return
//    case .PREDEFSUBCAT4CAT3: return
//    case .PREDEFSUBCAT5CAT3: return
//
//    case .PREDEFSUBCAT1CAT6: return
//    case .PREDEFSUBCAT2CAT6: return
//    case .PREDEFSUBCAT3CAT6: return
//    case .PREDEFSUBCAT4CAT6: return
//    case .PREDEFSUBCAT5CAT6: return
//    case .PREDEFSUBCAT6CAT6: return
//    case .PREDEFSUBCAT7CAT6: return
//
//    case .PREDEFSUBCAT1CAT7: return
//    case .PREDEFSUBCAT2CAT7: return
//    case .PREDEFSUBCAT3CAT7: return
//    case .PREDEFSUBCAT4CAT7: return
//    case .PREDEFSUBCAT5CAT7: return
//    case .PREDEFSUBCAT6CAT7: return
//    case .PREDEFSUBCAT7CAT7: return
//    case .PREDEFSUBCAT8CAT7: return
//    case .PREDEFSUBCAT9CAT7: return
//
//    case .PREDEFSUBCAT1CAT8: return
//    case .PREDEFSUBCAT2CAT8: return
//    case .PREDEFSUBCAT3CAT8: return
//    case .PREDEFSUBCAT4CAT8: return
//    case .PREDEFSUBCAT5CAT8: return
//    case .PREDEFSUBCAT6CAT8: return
//    case .PREDEFSUBCAT7CAT8: return
//
//    case .PREDEFSUBCAT1CAT10: return
//    case .PREDEFSUBCAT2CAT10: return
//    case .PREDEFSUBCAT3CAT10: return
//    case .PREDEFSUBCAT4CAT10: return
//    case .PREDEFSUBCAT5CAT10: return
//
//    case .PREDEFSUBCAT1CAT11: return
//    case .PREDEFSUBCAT2CAT11: return
//    case .PREDEFSUBCAT3CAT11: return
//    case .PREDEFSUBCAT4CAT11: return
//    case .PREDEFSUBCAT5CAT11: return
//    case .PREDEFSUBCAT6CAT11: return
//    case .PREDEFSUBCAT7CAT11: return
//    case .PREDEFSUBCAT8CAT11: return
//    case .PREDEFSUBCAT9CAT11: return
//    case .PREDEFSUBCAT10CAT11: return
//    case .PREDEFSUBCAT11CAT11: return
//
//    case .PREDEFSUBCAT1CAT12: return
//    case .PREDEFSUBCAT2CAT12: return
//    case .PREDEFSUBCAT3CAT12: return
//    case .PREDEFSUBCAT4CAT12: return
//    case .PREDEFSUBCAT5CAT12: return
//    }
//}
