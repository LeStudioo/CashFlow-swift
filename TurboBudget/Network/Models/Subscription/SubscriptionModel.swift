//
//  SubscriptionModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 12/11/2024.
//

import Foundation

enum SubscriptionFrequency: Int, Codable, CaseIterable {
    case monthly = 0
    case yearly = 1
}

class SubscriptionModel: Codable, Identifiable, Equatable, ObservableObject, Hashable {
    @Published var id: Int?
    @Published var name: String?
    @Published var amount: Double?
    @Published var type: Int?
    @Published var frequency: Int? // SubscriptionFrequency
    @Published var frequencyDate: String? // if frequency == 1
    @Published var frequencyDay: String? // if frequency == 0
    @Published var categoryID: String?
    @Published var subcategoryID: String?

    // Initialiseur
    init(id: Int? = nil, name: String? = nil, amount: Double? = nil, type: Int? = nil, frequency: Int? = nil, frequencyDate: String? = nil, frequencyDay: String? = nil, categoryID: String? = nil, subcategoryID: String? = nil) {
        self.id = id
        self.name = name
        self.amount = amount
        self.type = type
        self.frequency = frequency
        self.frequencyDate = frequencyDate
        self.frequencyDay = frequencyDay
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
    }
    
    /// Body
    init(
        name: String,
        amount: Double,
        type: TransactionType,
        categoryID: String,
        subcategoryID: String? = nil
    ) {
        self.name = name
        self.amount = amount
        self.type = type.rawValue
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
    }

    // Conformance au protocole Codable
    private enum CodingKeys: String, CodingKey {
        case id, name, amount, type, frequency, frequencyDate, frequencyDay, categoryID, subcategoryID
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        amount = try container.decodeIfPresent(Double.self, forKey: .amount)
        type = try container.decodeIfPresent(Int.self, forKey: .type)
        frequency = try container.decodeIfPresent(Int.self, forKey: .frequency)
        frequencyDate = try container.decodeIfPresent(String.self, forKey: .frequencyDate)
        frequencyDay = try container.decodeIfPresent(String.self, forKey: .frequencyDay)
        categoryID = try container.decodeIfPresent(String.self, forKey: .categoryID)
        subcategoryID = try container.decodeIfPresent(String.self, forKey: .subcategoryID)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(frequency, forKey: .frequency)
        try container.encodeIfPresent(frequencyDate, forKey: .frequencyDate)
        try container.encodeIfPresent(frequencyDay, forKey: .frequencyDay)
        try container.encodeIfPresent(categoryID, forKey: .categoryID)
        try container.encodeIfPresent(subcategoryID, forKey: .subcategoryID)
    }

    // Fonction pour le protocole Equatable
    static func == (lhs: SubscriptionModel, rhs: SubscriptionModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.amount == rhs.amount &&
               lhs.type == rhs.type &&
               lhs.frequency == rhs.frequency &&
               lhs.frequencyDate == rhs.frequencyDate &&
               lhs.frequencyDay == rhs.frequencyDay &&
               lhs.categoryID == rhs.categoryID &&
               lhs.subcategoryID == rhs.subcategoryID
    }

    // Fonction pour le protocole Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(amount)
        hasher.combine(type)
        hasher.combine(frequency)
        hasher.combine(frequencyDate)
        hasher.combine(frequencyDay)
        hasher.combine(categoryID)
        hasher.combine(subcategoryID)
    }
}
