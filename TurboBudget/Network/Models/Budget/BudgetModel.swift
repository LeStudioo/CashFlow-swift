//
//  BudgetModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 12/11/2024.
//

import Foundation

class BudgetModel: Codable, Identifiable, Equatable, ObservableObject, Hashable {
    @Published var id: Int?
    @Published var name: String?
    @Published var amount: String?
    @Published var categoryID: String?
    @Published var subcategoryID: String?

    // Initialiseur
    init(id: Int? = nil, name: String? = nil, amount: String? = nil, categoryID: String? = nil, subcategoryID: String? = nil) {
        self.id = id
        self.name = name
        self.amount = amount
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
    }

    // Conformance au protocole Codable
    private enum CodingKeys: String, CodingKey {
        case id, name, amount, categoryID, subcategoryID
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        amount = try container.decodeIfPresent(String.self, forKey: .amount)
        categoryID = try container.decodeIfPresent(String.self, forKey: .categoryID)
        subcategoryID = try container.decodeIfPresent(String.self, forKey: .subcategoryID)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(categoryID, forKey: .categoryID)
        try container.encodeIfPresent(subcategoryID, forKey: .subcategoryID)
    }

    // Fonction pour le protocole Equatable
    static func == (lhs: BudgetModel, rhs: BudgetModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.amount == rhs.amount &&
               lhs.categoryID == rhs.categoryID &&
               lhs.subcategoryID == rhs.subcategoryID
    }

    // Fonction pour le protocole Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(amount)
        hasher.combine(categoryID)
        hasher.combine(subcategoryID)
    }
}

