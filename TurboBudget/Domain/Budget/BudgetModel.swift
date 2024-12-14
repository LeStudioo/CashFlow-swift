//
//  BudgetModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 12/11/2024.
//

import Foundation
import SwiftUI

class BudgetModel: Codable, Identifiable, Equatable, ObservableObject, Hashable {
    @Published var id: Int?
    @Published var _amount: Double?
    @Published var categoryID: Int?
    @Published var subcategoryID: Int?

    // Initialiseur
    init(id: Int? = nil, amount: Double? = nil, categoryID: Int? = nil, subcategoryID: Int? = nil) {
        self.id = id
        self._amount = amount
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
    }

    // Conformance au protocole Codable
    private enum CodingKeys: String, CodingKey {
        case id, categoryID, subcategoryID
        case _amount = "amount"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        _amount = try container.decodeIfPresent(Double.self, forKey: ._amount)
        categoryID = try container.decodeIfPresent(Int.self, forKey: .categoryID)
        subcategoryID = try container.decodeIfPresent(Int.self, forKey: .subcategoryID)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(_amount, forKey: ._amount)
        try container.encodeIfPresent(categoryID, forKey: .categoryID)
        try container.encodeIfPresent(subcategoryID, forKey: .subcategoryID)
    }

    // Fonction pour le protocole Equatable
    static func == (lhs: BudgetModel, rhs: BudgetModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs._amount == rhs._amount &&
               lhs.categoryID == rhs.categoryID &&
               lhs.subcategoryID == rhs.subcategoryID
    }

    // Fonction pour le protocole Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(_amount)
        hasher.combine(categoryID)
        hasher.combine(subcategoryID)
    }
}

extension BudgetModel {
    
    var name: String {
        if let subcategory {
            return subcategory.name
        } else if let category {
            return category.name
        } else {
            return ""
        }
    }
    
    var amount: Double {
        return self._amount ?? 0
    }
    
    var category: CategoryModel? {
        return CategoryRepository.shared.findCategoryById(categoryID)
    }
    
    var subcategory: SubcategoryModel? {
        return CategoryRepository.shared.findSubcategoryById(subcategoryID)
    }
    
    var color: Color {
        return category?.color ?? .gray
    }
    
    var currentAmount: Double {
        guard let subcategory else { return 0 }

        var amount: Double = 0.0
        
        for transaction in subcategory.transactions {
            if transaction.category != nil {
                let subcategoryOfTransaction = transaction.subcategory
                
                if transaction.type == .expense && subcategoryOfTransaction == subcategory && Calendar.current.isDate(transaction.date, equalTo: Date(), toGranularity: .month) {
                    amount += transaction.amount ?? 0
                }
            }
        }
        
        return amount
    }
    
    var isExceeded: Bool {
        return currentAmount > amount
    }
    
}
