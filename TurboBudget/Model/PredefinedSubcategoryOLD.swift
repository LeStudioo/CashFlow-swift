////
////  PredefinedSubcategory.swift
////  CashFlow
////
////  Created by KaayZenn on 07/10/2023.
////
//
//import Foundation
//
//class PredefinedSubcategory: ObservableObject, Identifiable, Equatable, Hashable {
//    var id: UUID = UUID()
//    var idUnique: String
//    var title: String
//    var icon: String
//    var category: PredefinedCategory
//    var transactions: [Transaction]
//    var budget: Budget?
//    
//    init(idUnique: String, title: String, icon: String, category: PredefinedCategory, transactions: [Transaction], budget: Budget? = nil) {
//        self.idUnique = idUnique
//        self.title = title
//        self.icon = icon
//        self.category = category
//        self.transactions = transactions
//        self.budget = budget
//    }
//    
//    static func == (lhs: PredefinedSubcategory, rhs: PredefinedSubcategory) -> Bool {
//        return lhs.idUnique == rhs.idUnique
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(idUnique)
//    }
//    
//    
//    public func transactionsWithOnlyAutomations() -> [Transaction] {
//        return transactions.filter({ $0.comeFromAuto })
//    }
//
//    //Return TOTAL expense (return positif number)
//    public var amountTotalOfExpenses: Double {
//        let array = transactions.map { $0.amount }.filter { $0 < 0 }
//        return array.reduce(0, -)
//    }
//    
//    //Return the amount of TOTAL Expenses from Automation (return positif number)
//    public var amountTotalOfExpensesAutomations: Double {
//        let array = transactions.filter { $0.comeFromAuto && $0.amount < 0 }.map { $0.amount }
//        return array.reduce(0, -)
//    }
//    
//    public func transactionsInSelectedMonthAndYear(month: Int, year: Int) -> Double {
//        var array: [Transaction] = []
//        
//        var components = DateComponents()
//        components.day = 01
//        components.month = month + 1
//        components.year = year
//        
//        let dateOfMonthSelected = Calendar.current.date(from: components)
//        
//        if let dateOfMonthSelected {
//            for transaction in transactions {
//                if Calendar.current.isDate(transaction.date, equalTo: dateOfMonthSelected, toGranularity: .month) && Calendar.current.isDate(transaction.date, equalTo: dateOfMonthSelected, toGranularity: .year) {
//                    array.append(transaction)
//                }
//            }
//        }
//        
//        let arrayDouble = array.map { $0.amount }.filter { $0 < 0 }
//        return arrayDouble.reduce(0, -)
//    }
//    
//    func expensesTransactionsAmountForSelectedDate(filter: Filter) -> Double {
//        var array: [Transaction] = []
//        
//        for transaction in transactions {
//            if filter.byDay {
//                if Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .day) &&
//                       Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .month) &&
//                       Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .year) &&
//                       transaction.amount < 0 { array.append(transaction) }
//            } else {
//                if Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .month) && Calendar.current.isDate(transaction.date, equalTo: filter.date, toGranularity: .year) {
//                    array.append(transaction)
//                }
//            }
//        }
//        
//        return array.map { $0.amount }.reduce(0, -)
//    }
//}
//
////MARK: - Expenses from automations
//extension PredefinedSubcategory {
//    public func expensesAutomationsTransactionsAmountForSelectedDate(selectedDate: Date) -> Double {
//        var array: [Transaction] = []
//        
//        for transaction in transactionsWithOnlyAutomations() {
//            if Calendar.current.isDate(transaction.date, equalTo: selectedDate, toGranularity: .month) && Calendar.current.isDate(transaction.date, equalTo: selectedDate, toGranularity: .year) && transaction.amount < 0 {
//                array.append(transaction)
//            }
//        }
//        
//        return array.filter { !$0.isAuto }.map { $0.amount }.reduce(0, -)
//    }
//}
//
////MARK: - Extension Expenses
//extension PredefinedSubcategory {
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
////MARK: - Extension Incomes
//extension PredefinedSubcategory {
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
