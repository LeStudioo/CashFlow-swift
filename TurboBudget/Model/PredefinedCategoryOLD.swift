////
////  PredefinedCategory.swift
////  CashFlow
////
////  Created by KaayZenn on 07/10/2023.
////
//
//import Foundation
//import SwiftUI
//
//class PredefinedCategory: ObservableObject, Identifiable, Equatable, Hashable {
//    var id: UUID = UUID()
//    var idUnique: String
//    var title: String
//    var icon: String
//    var color: Color
//    var subcategories: [PredefinedSubcategory]
//    var transactions: [Transaction]
//    var transactionsArchived: [Transaction]
//    var budget: Budget?
//    
//    init(idUnique: String, title: String, icon: String, color: Color, subcategories: [PredefinedSubcategory], transactions: [Transaction], transactionsArchived: [Transaction], budget: Budget? = nil) {
//        self.idUnique = idUnique
//        self.title = title
//        self.icon = icon
//        self.color = color
//        self.subcategories = subcategories
//        self.transactions = transactions
//        self.transactionsArchived = transactionsArchived
//        self.budget = budget
//    }
//    
//    static func == (lhs: PredefinedCategory, rhs: PredefinedCategory) -> Bool {
//        return lhs.idUnique == rhs.idUnique
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(idUnique)
//    }
//}
//
////MARK: - Automations
//extension PredefinedCategory {
//    public func transactionsWithOnlyAutomations() -> [Transaction] {
//        return transactions.filter({ $0.comeFromAuto })
//    }
//}
//
//extension PredefinedCategory {
//    
//    func expensesTransactionsAmountForSelectedDate(filter: Filter) -> Double {
//        var array: [Transaction] = []
//        
//         for transaction in transactions {
//             if filter.byDay {
//                 if Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .day) &&
//                        Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .month) &&
//                        Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .year) &&
//                        transaction.amount < 0 { array.append(transaction) }
//             } else {
//                 if Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .month) &&
//                        Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .year) &&
//                        transaction.amount < 0 { array.append(transaction) }
//             }
//         }
//        return array.map { $0.amount }.reduce(0, -)
//    }
//}
//
////MARK: - Incomes
//extension PredefinedCategory {
//    
//    public var amountTotalOfIncomes: Double {
//        let array = transactions.map { $0.amount }.filter { $0 > 0 }
//        return array.reduce(0, +)
//    }
//    
//    public var amountTotalOfArchivedTransactionsIncomes: Double {
//        let array = transactionsArchived.map { $0.amount }.filter({ $0 > 0 })
//        return array.reduce(0, +)
//    }
//    
//    func incomesTransactionsAmountForSelectedDate(filter: Filter) -> Double {
//        var array: [Transaction] = []
//        for transaction in transactions {
//            if filter.byDay {
//                if Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .day) &&
//                    Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .month) &&
//                    Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .year) &&
//                    transaction.amount > 0 { array.append(transaction)
//                }
//            } else {
//                if Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .month) &&
//                    Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .year) &&
//                    transaction.amount > 0 { array.append(transaction)
//                }
//            }
//        }
//        return array.map { $0.amount }.reduce(0, +)
//    }
//    
//    //-------------------- getAllTransactionsIncomeForChosenMonth() ----------------------
//    // Description : Récupère tous les transactions qui sont des revenus, pour un mois donné
//    // Parameter : (selectedDate: Date)
//    // Output : return [Transaction]
//    // Extra : No
//    //-----------------------------------------------------------
//    func getAllTransactionsIncomeForChosenMonth(selectedDate: Date) -> [Transaction] {
//        var transactionsIncomes: [Transaction] = []
//        
//        for transaction in transactions {
//            if transaction.amount > 0 && Calendar.current.isDate(transaction.date, equalTo: selectedDate, toGranularity: .month) && PredefinedCategoryManager().categoryByUniqueID(idUnique: transaction.predefCategoryID) != nil { transactionsIncomes.append(transaction) }
//        }
//        return transactionsIncomes
//    }
//    
//    //-------------------- amountIncomesByMonth() ----------------------
//    // Description : Retourne la somme de toutes les transactions qui sont des revenus, pour un mois donné
//    // Parameter : (month: Date)
//    // Output : return [Transaction]
//    // Extra : No
//    //-----------------------------------------------------------
//    func amountIncomesByMonth(month: Date) -> Double {
//        return getAllTransactionsIncomeForChosenMonth(selectedDate: month).map({ $0.amount }).reduce(0, +)
//    }
//    
//}
//
////MARK: - Expenses
//extension PredefinedCategory {
//    
//    //Return TOTAL expense (return positif number)
//    public var amountTotalOfExpenses: Double {
//        let array = transactions.map { $0.amount }.filter({ $0 < 0 })
//        return array.reduce(0, -)
//    }
//    
//    public var amountTotalOfArchivedTransactionsExpenses: Double {
//        let array = transactionsArchived.map { $0.amount }.filter({ $0 < 0 })
//        return array.reduce(0, -)
//    }
//    
//    //-------------------- getAllExpensesTransactionsForChosenMonth() ----------------------
//    // Description : Récupère toutes les transactions qui sont des dépenses, pour un mois donné
//    // Parameter : (selectedDate: Date)
//    // Output : return [Transaction]
//    // Extra : No
//    //-----------------------------------------------------------
//    func getAllExpensesTransactionsForChosenMonth(selectedDate: Date) -> [Transaction] {
//        var transactionsExpenses: [Transaction] = []
//        
//        for transaction in transactions {
//            if transaction.amount < 0 && Calendar.current.isDate(transaction.date, equalTo: selectedDate, toGranularity: .month) {
//                transactionsExpenses.append(transaction)
//            }
//        }
//        return transactionsExpenses
//    }
//    
//    //-------------------- amountExpensesByMonth() ----------------------
//    // Description : Retourne la somme de toutes les transactions qui sont des dépenses, pour un mois donné
//    // Parameter : (month: Date)
//    // Output : return [Transaction]
//    // Extra : No
//    //-----------------------------------------------------------
//    func amountExpensesByMonth(month: Date) -> Double {
//        return getAllExpensesTransactionsForChosenMonth(selectedDate: month).map({ $0.amount }).reduce(0, -)
//    }
//}
//
////MARK: - Incomes from automations
//extension PredefinedCategory {
//    
//    //Return the amount of TOTAL Incomes from Automation (return positif number)
//    public var amountTotalOfIncomesAutomations: Double {
//        let array = transactions.filter { $0.comeFromAuto && $0.amount > 0 }.map { $0.amount }
//        return array.reduce(0, +)
//    }
//    
//    public func incomesAutomationsTransactionsAmountForSelectedDate(selectedDate: Date) -> Double {
//        var array: [Transaction] = []
//        
//        for transaction in transactionsWithOnlyAutomations() {
//            if Calendar.current.isDate(transaction.date, equalTo: selectedDate, toGranularity: .month) && Calendar.current.isDate(transaction.date, equalTo: selectedDate, toGranularity: .year) && transaction.amount > 0 {
//                array.append(transaction)
//            }
//        }
//        
//        return array.map { $0.amount }.reduce(0, +)
//    }
//    
//}
//
////MARK: - Expenses from automations
//extension PredefinedCategory {
//    
//    //Return the amount of TOTAL Expenses from Automation (return positif number)
//    public var amountTotalOfExpensesAutomations: Double {
//        let array = transactions.filter { $0.comeFromAuto && $0.amount < 0 }.map { $0.amount }
//        return array.reduce(0, -)
//    }
//    
//    public func expensesAutomationsTransactionsAmountForSelectedDate(selectedDate: Date) -> Double {
//        var array: [Transaction] = []
//        
//        for transaction in transactionsWithOnlyAutomations() {
//            if Calendar.current.isDate(transaction.date, equalTo: selectedDate, toGranularity: .month) && Calendar.current.isDate(transaction.date, equalTo: selectedDate, toGranularity: .year) && transaction.amount < 0 {
//                array.append(transaction)
//            }
//        }
//        
//        return array.map { $0.amount }.reduce(0, -)
//    }
//    
//}
