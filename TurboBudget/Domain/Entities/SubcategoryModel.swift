//
//  SubcategoryModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/11/2024.
//

import Foundation
import SwiftUI

struct SubcategoryModel: Codable, Identifiable, Equatable, Hashable {
    var id: Int?
    var _name: String?
    var _icon: String?
    var colorString: String?

    // Initialisateur
    init(
        id: Int? = nil,
        name: String? = nil,
        icon: String? = nil,
        colorString: String? = nil
    ) {
        self.id = id
        self._name = name
        self._icon = icon
        self.colorString = colorString
    }

    // Conformance au protocole Codable
    private enum CodingKeys: String, CodingKey {
        case id
        case _name = "name"
        case _icon = "icon"
        case colorString = "color"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        _name = try container.decodeIfPresent(String.self, forKey: ._name)
        _icon = try container.decodeIfPresent(String.self, forKey: ._icon)
        colorString = try container.decodeIfPresent(String.self, forKey: .colorString)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(_name, forKey: ._name)
        try container.encodeIfPresent(_icon, forKey: ._icon)
        try container.encodeIfPresent(colorString, forKey: .colorString)
    }
}

extension SubcategoryModel {
    
    var icon: String {
        return self._icon ?? ""
    }
    
    var name: String {
        return self._name?.localized ?? ""
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
}

extension SubcategoryModel {
    
    var transactions: [TransactionModel] {
        return TransactionStore.shared.transactions.filter { $0.subcategory?.id == self.id }
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
    
    var budget: BudgetModel? {
        return BudgetStore.shared.budgets.first(where: { $0.subcategoryID == self.id })
    }
    
    var transactionsFiltered: [TransactionModel] {
        return self.transactions
            .filter { Calendar.current.isDate($0.date, equalTo: FilterManager.shared.date, toGranularity: .month) }
    }
    
}
