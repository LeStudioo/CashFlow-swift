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
    @Published var typeNum: Int?
    @Published var frequencyNum: Int? // SubscriptionFrequency
    @Published var frequencyDate: String? // if frequency == 1
    @Published var categoryID: Int?
    @Published var subcategoryID: Int?

    // Initialiseur
    init(
        id: Int? = nil,
        name: String? = nil,
        amount: Double? = nil,
        typeNum: Int? = nil,
        frequencyNum: Int? = nil,
        frequencyDate: String? = nil,
        categoryID: Int? = nil,
        subcategoryID: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.typeNum = typeNum
        self.frequencyNum = frequencyNum
        self.frequencyDate = frequencyDate
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
    }
    
    /// Body
    init(
        name: String,
        amount: Double,
        type: TransactionType,
        frequency: SubscriptionFrequency,
        categoryID: Int,
        subcategoryID: Int? = nil
    ) {
        self.name = name
        self.amount = amount
        self.typeNum = type.rawValue
        self.frequencyNum = frequency.rawValue
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
    }

    // Conformance au protocole Codable
    private enum CodingKeys: String, CodingKey {
        case id, name, amount, frequencyDate, frequencyDay, categoryID, subcategoryID
        case typeNum = "type"
        case frequencyNum = "frequency"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        amount = try container.decodeIfPresent(Double.self, forKey: .amount)
        typeNum = try container.decodeIfPresent(Int.self, forKey: .typeNum)
        frequencyNum = try container.decodeIfPresent(Int.self, forKey: .frequencyNum)
        frequencyDate = try container.decodeIfPresent(String.self, forKey: .frequencyDate)
        categoryID = try container.decodeIfPresent(Int.self, forKey: .categoryID)
        subcategoryID = try container.decodeIfPresent(Int.self, forKey: .subcategoryID)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(typeNum, forKey: .typeNum)
        try container.encodeIfPresent(frequencyNum, forKey: .frequencyNum)
        try container.encodeIfPresent(frequencyDate, forKey: .frequencyDate)
        try container.encodeIfPresent(categoryID, forKey: .categoryID)
        try container.encodeIfPresent(subcategoryID, forKey: .subcategoryID)
    }

    // Fonction pour le protocole Equatable
    static func == (lhs: SubscriptionModel, rhs: SubscriptionModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.amount == rhs.amount &&
               lhs.typeNum == rhs.typeNum &&
               lhs.frequencyNum == rhs.frequencyNum &&
               lhs.frequencyDate == rhs.frequencyDate &&
               lhs.categoryID == rhs.categoryID &&
               lhs.subcategoryID == rhs.subcategoryID
    }

    // Fonction pour le protocole Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(amount)
        hasher.combine(typeNum)
        hasher.combine(frequencyNum)
        hasher.combine(frequencyDate)
        hasher.combine(categoryID)
        hasher.combine(subcategoryID)
    }
}

extension SubscriptionModel {
    
    var category: CategoryModel? {
        return CategoryRepository.shared.findCategoryById(categoryID)
    }
    
    var subcategory: SubcategoryModel? {
        return CategoryRepository.shared.findSubcategoryById(subcategoryID)
    }
    
    var type: TransactionType {
        return TransactionType(rawValue: typeNum ?? 0) ?? .expense
    }
    
    var frequency: SubscriptionFrequency? {
        return SubscriptionFrequency(rawValue: frequencyNum ?? 0)
    }
    
    var date: Date {
        return self.frequencyDate?.toDate() ?? .now
    }
    
}
