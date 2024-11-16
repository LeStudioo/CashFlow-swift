//
//  PredefinedCategory2.swift
//  CustomPieChart
//
//  Created by KaayZenn on 11/08/2024.
//

import SwiftUI

enum PredefinedCategory: String, CaseIterable, Identifiable {
    case PREDEFCAT00
    case PREDEFCAT0
    case PREDEFCAT1
    case PREDEFCAT2
    case PREDEFCAT3
    case PREDEFCAT4
    case PREDEFCAT5
    case PREDEFCAT6
    case PREDEFCAT7
    case PREDEFCAT8
    case PREDEFCAT9
    case PREDEFCAT10
    case PREDEFCAT11
    case PREDEFCAT12
}

extension PredefinedCategory {
    
    var id: String { return self.rawValue }
    
    var title: String {
        switch self {
        case .PREDEFCAT00: return "category00_name".localized
        case .PREDEFCAT0: return "word_incomes".localized
        case .PREDEFCAT1: return "category1_name".localized
        case .PREDEFCAT2: return "category2_name".localized
        case .PREDEFCAT3: return "category3_name".localized
        case .PREDEFCAT4: return "category4_name".localized
        case .PREDEFCAT5: return "category5_name".localized
        case .PREDEFCAT6: return "category6_name".localized
        case .PREDEFCAT7: return "category7_name".localized
        case .PREDEFCAT8: return "category8_name".localized
        case .PREDEFCAT9: return "category9_name".localized
        case .PREDEFCAT10: return "category10_name".localized
        case .PREDEFCAT11: return "category11_name".localized
        case .PREDEFCAT12: return "category12_name".localized
        }
    }
    
    var icon: String {
        switch self {
        case .PREDEFCAT00: return "questionmark"
        case .PREDEFCAT0: return "tray.and.arrow.down"
        case .PREDEFCAT1: return "cart.fill"
        case .PREDEFCAT2: return "fork.knife"
        case .PREDEFCAT3: return "pawprint.fill"
        case .PREDEFCAT4: return "creditcard.fill"
        case .PREDEFCAT5: return "chart.bar.fill"
        case .PREDEFCAT6: return "chart.line.downtrend.xyaxis"
        case .PREDEFCAT7: return "house.fill"
        case .PREDEFCAT8: return "sun.max"
        case .PREDEFCAT9: return "creditcard.and.123"
        case .PREDEFCAT10: return "cross"
        case .PREDEFCAT11: return "car.side.fill"
        case .PREDEFCAT12: return "building.2.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .PREDEFCAT00: return .gray.lighter(by: 4)
        case .PREDEFCAT0: return .green
        case .PREDEFCAT1: return .red
        case .PREDEFCAT2: return .orange
        case .PREDEFCAT3: return .yellow
        case .PREDEFCAT4: return .green
        case .PREDEFCAT5: return .mint
        case .PREDEFCAT6: return .teal
        case .PREDEFCAT7: return .cyan
        case .PREDEFCAT8: return .blue
        case .PREDEFCAT9: return .indigo
        case .PREDEFCAT10: return .purple
        case .PREDEFCAT11: return .pink
        case .PREDEFCAT12: return .brown
        }
    }
    
    var subcategories: [PredefinedSubcategory] {
        switch self {
        case .PREDEFCAT1:
            return [.PREDEFSUBCAT1CAT1, .PREDEFSUBCAT2CAT1, .PREDEFSUBCAT3CAT1, .PREDEFSUBCAT4CAT1,
                    .PREDEFSUBCAT5CAT1, .PREDEFSUBCAT6CAT1, .PREDEFSUBCAT7CAT1, .PREDEFSUBCAT8CAT1,
                    .PREDEFSUBCAT9CAT1, .PREDEFSUBCAT10CAT1]
        case .PREDEFCAT2:
            return [.PREDEFSUBCAT1CAT2, .PREDEFSUBCAT2CAT2, .PREDEFSUBCAT3CAT2, .PREDEFSUBCAT4CAT2,
                    .PREDEFSUBCAT5CAT2]
        case .PREDEFCAT3:
            return [.PREDEFSUBCAT1CAT3, .PREDEFSUBCAT2CAT3, .PREDEFSUBCAT3CAT3, .PREDEFSUBCAT4CAT3,
                    .PREDEFSUBCAT5CAT3]
        case .PREDEFCAT6:
            return [.PREDEFSUBCAT1CAT6, .PREDEFSUBCAT2CAT6, .PREDEFSUBCAT3CAT6, .PREDEFSUBCAT4CAT6,
                    .PREDEFSUBCAT5CAT6, .PREDEFSUBCAT6CAT6, .PREDEFSUBCAT7CAT6]
        case .PREDEFCAT7:
            return [.PREDEFSUBCAT1CAT7, .PREDEFSUBCAT2CAT7, .PREDEFSUBCAT3CAT7, .PREDEFSUBCAT4CAT7,
                    .PREDEFSUBCAT5CAT7, .PREDEFSUBCAT6CAT7, .PREDEFSUBCAT7CAT7, .PREDEFSUBCAT8CAT7,
                    .PREDEFSUBCAT9CAT7]
        case .PREDEFCAT8:
            return [.PREDEFSUBCAT1CAT8, .PREDEFSUBCAT2CAT8, .PREDEFSUBCAT3CAT8, .PREDEFSUBCAT4CAT8,
                    .PREDEFSUBCAT5CAT8, .PREDEFSUBCAT6CAT8, .PREDEFSUBCAT7CAT8]
        case .PREDEFCAT10:
            return [.PREDEFSUBCAT1CAT10, .PREDEFSUBCAT2CAT10, .PREDEFSUBCAT3CAT10, .PREDEFSUBCAT4CAT10,
                    .PREDEFSUBCAT5CAT10]
        case .PREDEFCAT11:
            return [.PREDEFSUBCAT1CAT11, .PREDEFSUBCAT2CAT11, .PREDEFSUBCAT3CAT11, .PREDEFSUBCAT4CAT11,
                    .PREDEFSUBCAT5CAT11, .PREDEFSUBCAT6CAT11, .PREDEFSUBCAT7CAT11, .PREDEFSUBCAT8CAT11,
                    .PREDEFSUBCAT9CAT11, .PREDEFSUBCAT10CAT11, .PREDEFSUBCAT11CAT11]
        case .PREDEFCAT12:
            return [.PREDEFSUBCAT1CAT12, .PREDEFSUBCAT2CAT12, .PREDEFSUBCAT3CAT12, .PREDEFSUBCAT4CAT12,
                    .PREDEFSUBCAT5CAT12]
        default:
            return []
        }
    }
    
    var transactions: [TransactionModel] {
        return TransactionRepository.shared.transactionsByCategory(self.rawValue)
    }
    
    /// Transactions of type expense in a Category
    var expenses: [TransactionModel] {
        return transactions.filter { $0.type == .expense }
    }
    
    /// Transactions of type income in a Category
    var incomes: [TransactionModel] {
        return transactions.filter { $0.type == .income }
    }
    
    /// Transactions from Subscription in a Category
    var subscriptions: [TransactionModel] {
        return transactions.filter { $0.isFromSubscription == true }
    }
    
    
    
    var transactionsFiltered: [TransactionModel] {
        return self.transactions
            .filter { Calendar.current.isDate($0.date.withDefault, equalTo: FilterManager.shared.date, toGranularity: .month) }
    }
    
}

extension PredefinedCategory {
    
    func transactionsAmount(type: TransactionType, filter: Filter) -> Double {
        var array: [TransactionModel] = []
        
         for transaction in transactions {
             if filter.byDay {
                 if Calendar.current.isDate(transaction.date.withDefault, equalTo: filter.date, toGranularity: .day) &&
                        Calendar.current.isDate(transaction.date.withDefault, equalTo: filter.date, toGranularity: .month) &&
                        Calendar.current.isDate(transaction.date.withDefault, equalTo: filter.date, toGranularity: .year) &&
                        transaction.type == type { array.append(transaction) }
             } else {
                 if Calendar.current.isDate(transaction.date.withDefault, equalTo: filter.date, toGranularity: .month) &&
                        Calendar.current.isDate(transaction.date.withDefault, equalTo: filter.date, toGranularity: .year) &&
                        transaction.type == type { array.append(transaction) }
             }
         }
        return array.map { $0.amount ?? 0 }.reduce(0, +)
    }
    
}


//MARK: - Incomes
extension PredefinedCategory {
    
    public var amountTotalOfIncomes: Double {
        let array = incomes
            .map { $0.amount ?? 0 }
        return array.reduce(0, +)
    }
    
    func incomesTransactionsAmountForSelectedDate(filter: Filter) -> Double {
        var array: [TransactionModel] = []
        for transaction in incomes {
            if filter.byDay {
                if Calendar.current.isDate(transaction.date.withDefault, equalTo: filter.date, toGranularity: .day)
                    && Calendar.current.isDate(transaction.date.withDefault, equalTo: filter.date, toGranularity: .month)
                    && Calendar.current.isDate(transaction.date.withDefault, equalTo: filter.date, toGranularity: .year) {
                    array.append(transaction)
                }
            } else {
                if Calendar.current.isDate(transaction.date.withDefault, equalTo: filter.date, toGranularity: .month)
                    && Calendar.current.isDate(transaction.date.withDefault, equalTo: filter.date, toGranularity: .year) {
                    array.append(transaction)
                }
            }
        }
        return array.map { $0.amount ?? 0 }.reduce(0, +)
    }
    
    //-------------------- getAllTransactionsIncomeForChosenMonth() ----------------------
    // Description : Récupère tous les transactions qui sont des revenus, pour un mois donné
    // Parameter : (selectedDate: Date)
    // Output : return [TransactionEntity]
    // Extra : No
    //-----------------------------------------------------------
    func getAllTransactionsIncomeForChosenMonth(selectedDate: Date) -> [TransactionModel] {
        var transactionsIncomes: [TransactionModel] = []
        
        for transaction in incomes {
            if Calendar.current.isDate(transaction.date.withDefault, equalTo: selectedDate, toGranularity: .month)
                && PredefinedCategory.findByID(transaction.categoryID ?? "") != nil {
                transactionsIncomes.append(transaction)
            }
        }
        return transactionsIncomes
    }
    
    //-------------------- amountIncomesByMonth() ----------------------
    // Description : Retourne la somme de toutes les transactions qui sont des revenus, pour un mois donné
    // Parameter : (month: Date)
    // Output : return [TransactionEntity]
    // Extra : No
    //-----------------------------------------------------------
    func amountIncomesByMonth(month: Date) -> Double {
        return getAllTransactionsIncomeForChosenMonth(selectedDate: month)
            .map({ $0.amount ?? 0 })
            .reduce(0, +)
    }
    
}

//MARK: - Expenses
extension PredefinedCategory {
    
    //Return TOTAL expense (return positif number)
    public var amountTotalOfExpenses: Double {
        let array = expenses
            .map { $0.amount ?? 0 }
        return array.reduce(0, +)
    }
    
    //-------------------- getAllExpensesTransactionsForChosenMonth() ----------------------
    // Description : Récupère toutes les transactions qui sont des dépenses, pour un mois donné
    // Parameter : (selectedDate: Date)
    // Output : return [TransactionEntity]
    // Extra : No
    //-----------------------------------------------------------
    func getAllExpensesTransactionsForChosenMonth(selectedDate: Date) -> [TransactionModel] {
        var transactionsExpenses: [TransactionModel] = []
        
        for transaction in expenses {
            if Calendar.current.isDate(transaction.date.withDefault, equalTo: selectedDate, toGranularity: .month) {
                    transactionsExpenses.append(transaction)
            }
        }
        return transactionsExpenses
    }
    
    //-------------------- amountExpensesByMonth() ----------------------
    // Description : Retourne la somme de toutes les transactions qui sont des dépenses, pour un mois donné
    // Parameter : (month: Date)
    // Output : return [TransactionEntity]
    // Extra : No
    //-----------------------------------------------------------
    func amountExpensesByMonth(month: Date) -> Double {
        return getAllExpensesTransactionsForChosenMonth(selectedDate: month)
            .map({ $0.amount ?? 0 })
            .reduce(0, +)
    }
}

//MARK: - Incomes from automations
extension PredefinedCategory {
    
    //Return the amount of TOTAL Incomes from Automation (return positif number)
    public var amountTotalOfIncomesAutomations: Double {
        let array = subscriptions
            .filter { $0.type == .income }
            .map { $0.amount ?? 0 }
        return array.reduce(0, +)
    }
    
    public func incomesAutomationsTransactionsAmountForSelectedDate(selectedDate: Date) -> Double {
        var array: [TransactionModel] = []
        
        for transaction in self.subscriptions {
            if Calendar.current.isDate(transaction.date.withDefault, equalTo: selectedDate, toGranularity: .month)
                && Calendar.current.isDate(transaction.date.withDefault, equalTo: selectedDate, toGranularity: .year)
                && transaction.type == .income {
                array.append(transaction)
            }
        }
        
        return array.map { $0.amount ?? 0 }.reduce(0, +)
    }
    
}

//MARK: - Expenses from automations
extension PredefinedCategory {
    
    //Return the amount of TOTAL Expenses from Automation (return positif number)
    public var amountTotalOfExpensesAutomations: Double {
        let array = subscriptions
            .filter { $0.type == .expense }
            .map { $0.amount ?? 0 }
        return array.reduce(0, +)
    }
    
    public func expensesAutomationsTransactionsAmountForSelectedDate(selectedDate: Date) -> Double {
        var array: [TransactionModel] = []
        
        for transaction in self.subscriptions {
            if Calendar.current.isDate(transaction.date.withDefault, equalTo: selectedDate, toGranularity: .month)
                && Calendar.current.isDate(transaction.date.withDefault, equalTo: selectedDate, toGranularity: .year)
                && transaction.type == .expense {
                array.append(transaction)
            }
        }
        
        return array.map { $0.amount ?? 0 }.reduce(0, -)
    }
    
}
