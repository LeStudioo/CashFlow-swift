//
//  CategoryModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/11/2024.
//

import Foundation
import SwiftUI

class CategoryModel: Codable, Identifiable, Equatable, ObservableObject, Hashable {
    @Published var id: Int?
    @Published var _name: String?
    @Published var _icon: String?
    @Published var colorString: String?
    @Published var subcategories: [SubcategoryModel]?

    // Initialisateur
    init(
        id: Int? = nil,
        name: String? = nil,
        icon: String? = nil,
        colorString: String? = nil,
        subcategories: [SubcategoryModel]? = nil
    ) {
        self.id = id
        self._name = name
        self._icon = icon
        self.colorString = colorString
        self.subcategories = subcategories
    }

    // Conformance au protocole Codable
    private enum CodingKeys: String, CodingKey {
        case id, subcategories
        case _name = "name"
        case _icon = "icon"
        case colorString = "color"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        _name = try container.decodeIfPresent(String.self, forKey: ._name)
        _icon = try container.decodeIfPresent(String.self, forKey: ._icon)
        colorString = try container.decodeIfPresent(String.self, forKey: .colorString)
        subcategories = try container.decodeIfPresent([SubcategoryModel].self, forKey: .subcategories)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(_name, forKey: ._name)
        try container.encodeIfPresent(_icon, forKey: ._icon)
        try container.encodeIfPresent(colorString, forKey: .colorString)
        try container.encodeIfPresent(subcategories, forKey: .subcategories)
    }

    // Conformance au protocole Equatable
    static func == (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs._name == rhs._name &&
               lhs._icon == rhs._icon &&
               lhs.colorString == rhs.colorString &&
               lhs.subcategories == rhs.subcategories
    }

    // Conformance au protocole Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(_name)
        hasher.combine(_icon)
        hasher.combine(colorString)
        hasher.combine(subcategories)
    }
}

extension CategoryModel {
    
    var name: String {
        return self._name?.localized ?? ""
    }
    
    var icon: String {
        return self._icon ?? ""
    }
    
    var color: Color {
        switch self.colorString {
        case "gray":    return .gray.lighter(by: 4)
        case "green":   return .green
        case "red":     return .red
        case "orange":  return .orange
        case "yellow":  return .yellow
        case "mint":    return .mint
        case "teal":    return .teal
        case "cyan":    return .cyan
        case "blue":    return .blue
        case "indigo":  return .indigo
        case "purple":  return .purple
        case "pink":    return .pink
        case "brown":   return .brown
        default:        return .gray.lighter(by: 4)
        }
    }
    
    static var revenue: CategoryModel? {
        return CategoryStore.shared.findCategoryById(1)
    }
    
    static var toCategorized: CategoryModel? {
        return CategoryStore.shared.findCategoryById(0)
    }
    
    var isRevenue: Bool {
        return self.id == 1
    }
    
    var isToCategorized: Bool {
        return self.id == 0
    }
    
}

extension CategoryModel {
    
    var transactions: [TransactionModel] {
        return TransactionStore.shared.transactions.filter { $0.categoryID == self.id }
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
    
    var currentMonthTransactions: [TransactionModel] {
        let calendar = Calendar.current
        let now = Date()
        
        return transactions.filter { transaction in
            let transactionMonth = calendar.dateComponents([.month, .year], from: transaction.date)
            let currentMonth = calendar.dateComponents([.month, .year], from: now)
            return transactionMonth == currentMonth && transaction.categoryID == self.id
        }
    }
    
    var currentMonthExpenses: [TransactionModel] {
        return currentMonthTransactions.filter({ $0.type == .expense })
    }
    
    var currentMonthIncomes: [TransactionModel] {
        return currentMonthTransactions.filter({ $0.type == .income })
    }
        
    var transactionsFiltered: [TransactionModel] {
        return self.transactions
            .filter { Calendar.current.isDate($0.date, equalTo: FilterManager.shared.date, toGranularity: .month) }
    }
    
}

extension CategoryModel {
    
    public var amountTotalOfIncomes: Double {
        let array = incomes
            .map { $0.amount ?? 0 }
        return array.reduce(0, +)
    }
    
    // -------------------- getAllTransactionsIncomeForChosenMonth() ----------------------
    // Description : Récupère tous les transactions qui sont des revenus, pour un mois donné
    // -----------------------------------------------------------
    func getAllTransactionsIncomeForChosenMonth(selectedDate: Date) -> [TransactionModel] {
        var transactionsIncomes: [TransactionModel] = []
        
        for transaction in incomes {
            if Calendar.current.isDate(transaction.date, equalTo: selectedDate, toGranularity: .month)
                && transaction.category != nil {
                transactionsIncomes.append(transaction)
            }
        }
        return transactionsIncomes
    }
    
    // -------------------- amountIncomesByMonth() ----------------------
    // Description : Retourne la somme de toutes les transactions qui sont des revenus, pour un mois donné
    // -----------------------------------------------------------
    func amountIncomesByMonth(month: Date) -> Double {
        return getAllTransactionsIncomeForChosenMonth(selectedDate: month)
            .map({ $0.amount ?? 0 })
            .reduce(0, +)
    }
        
}

extension CategoryModel {
    
    // Return TOTAL expense (return positif number)
    public var amountTotalOfExpenses: Double {
        let array = expenses
            .map { $0.amount ?? 0 }
        return array.reduce(0, +)
    }
    
    // -------------------- getAllExpensesTransactionsForChosenMonth() ----------------------
    // Description : Récupère toutes les transactions qui sont des dépenses, pour un mois donné
    // -----------------------------------------------------------
    func getAllExpensesTransactionsForChosenMonth(selectedDate: Date) -> [TransactionModel] {
        var transactionsExpenses: [TransactionModel] = []
        
        for transaction in expenses {
            if Calendar.current.isDate(transaction.date, equalTo: selectedDate, toGranularity: .month) {
                transactionsExpenses.append(transaction)
            }
        }
        return transactionsExpenses
    }
    
    // -------------------- amountExpensesByMonth() ----------------------
    // Description : Retourne la somme de toutes les transactions qui sont des dépenses, pour un mois donné
    // -----------------------------------------------------------
    func amountExpensesByMonth(month: Date) -> Double {
        return getAllExpensesTransactionsForChosenMonth(selectedDate: month)
            .map({ $0.amount ?? 0 })
            .reduce(0, +)
    }
}

extension CategoryModel {
    
    var categorySlices: [PieSliceData] {
        var array: [PieSliceData] = []
        let filterManager = FilterManager.shared
        
        for subcategory in self.subcategories ?? [] {
            let transactionsFiltered = subcategory.transactions
                .filter { Calendar.current.isDate($0.date, equalTo: filterManager.date, toGranularity: .month) }
            
            let amount = transactionsFiltered
                .map { $0.amount ?? 0 }
                .reduce(0, +)
            
            if amount != 0 {
                array.append(
                    .init(
                        categoryID: self.id ?? 0,
                        subcategoryID: subcategory.id,
                        iconName: subcategory.icon,
                        value: subcategory.transactionsFiltered
                            .map { $0.amount ?? 0 }
                            .reduce(0, +),
                        color: subcategory.color
                    )
                )
            }
        }
        
        return array
    }
        
}
