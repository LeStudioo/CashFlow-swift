//
//  TransactionModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 12/11/2024.
//

import Foundation

enum TransactionType: Int, CaseIterable {
    case expenses = 0
    case income = 1
    case transfer = 2
}

class TransactionModel: Codable, Identifiable, Equatable, ObservableObject, Hashable {
    @Published var id: Int?
    @Published var name: String?
    @Published var amount: Double?
    @Published var type: Int? // TransactionType
    @Published var date: String?
    @Published var creationDate: String?
    @Published var categoryID: String?
    @Published var subcategoryID: String?
    
    @Published var isFromSubscription: Bool?
    @Published var isFromApplePay: Bool?
    @Published var nameFromApplePay: String?
    
    @Published var senderAccountID: Int?
    @Published var receiverAccountID: Int?
    
    // Transaction init
    init(
        id: Int? = nil,
        name: String? = nil,
        amount: Double? = nil,
        type: Int? = nil,
        date: String? = nil,
        creationDate: String? = nil,
        categoryID: String? = nil,
        subcategoryID: String? = nil,
        isFromSubscription: Bool? = nil,
        isFromApplePay: Bool? = nil,
        nameFromApplePay: String? = nil
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.type = type
        self.date = date
        self.creationDate = creationDate
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
        self.isFromSubscription = isFromSubscription
        self.isFromApplePay = isFromApplePay
        self.nameFromApplePay = nameFromApplePay
    }
    
    // Transfer init
    init(
        id: Int? = nil,
        amount: Double? = nil,
        type: Int? = nil,
        date: String? = nil,
        creationDate: String? = nil,
        senderAccountID: Int? = nil,
        receiverAccountID: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.type = type
        self.date = date
        self.creationDate = creationDate
        self.senderAccountID = senderAccountID
        self.receiverAccountID = receiverAccountID
    }
    
    // Conformance au protocole Codable
    private enum CodingKeys: String, CodingKey {
        case id, name, amount, type, date, creationDate, categoryID, subcategoryID, isFromSubscription, isFromApplePay, nameFromApplePay, senderAccountID, receiverAccountID
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        amount = try container.decodeIfPresent(Double.self, forKey: .amount)
        type = try container.decodeIfPresent(Int.self, forKey: .type)
        date = try container.decodeIfPresent(String.self, forKey: .date)
        creationDate = try container.decodeIfPresent(String.self, forKey: .creationDate)
        categoryID = try container.decodeIfPresent(String.self, forKey: .categoryID)
        subcategoryID = try container.decodeIfPresent(String.self, forKey: .subcategoryID)
        isFromSubscription = try container.decodeIfPresent(Bool.self, forKey: .isFromSubscription)
        isFromApplePay = try container.decodeIfPresent(Bool.self, forKey: .isFromApplePay)
        nameFromApplePay = try container.decodeIfPresent(String.self, forKey: .nameFromApplePay)
        senderAccountID = try container.decodeIfPresent(Int.self, forKey: .senderAccountID)
        receiverAccountID = try container.decodeIfPresent(Int.self, forKey: .receiverAccountID)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(date, forKey: .date)
        try container.encodeIfPresent(creationDate, forKey: .creationDate)
        try container.encodeIfPresent(categoryID, forKey: .categoryID)
        try container.encodeIfPresent(subcategoryID, forKey: .subcategoryID)
        try container.encodeIfPresent(isFromSubscription, forKey: .isFromSubscription)
        try container.encodeIfPresent(isFromApplePay, forKey: .isFromApplePay)
        try container.encodeIfPresent(nameFromApplePay, forKey: .nameFromApplePay)
        try container.encodeIfPresent(senderAccountID, forKey: .senderAccountID)
        try container.encodeIfPresent(receiverAccountID, forKey: .receiverAccountID)
    }
    
    // Fonction pour le protocole Equatable
    static func == (lhs: TransactionModel, rhs: TransactionModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.amount == rhs.amount &&
        lhs.type == rhs.type &&
        lhs.date == rhs.date &&
        lhs.creationDate == rhs.creationDate &&
        lhs.categoryID == rhs.categoryID &&
        lhs.subcategoryID == rhs.subcategoryID &&
        lhs.isFromSubscription == rhs.isFromSubscription &&
        lhs.isFromApplePay == rhs.isFromApplePay &&
        lhs.nameFromApplePay == rhs.nameFromApplePay &&
        lhs.senderAccountID == rhs.senderAccountID &&
        lhs.receiverAccountID == rhs.receiverAccountID
    }
    
    // Fonction pour le protocole Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(amount)
        hasher.combine(type)
        hasher.combine(date)
        hasher.combine(creationDate)
        hasher.combine(categoryID)
        hasher.combine(subcategoryID)
        hasher.combine(isFromSubscription)
        hasher.combine(isFromApplePay)
        hasher.combine(nameFromApplePay)
        hasher.combine(senderAccountID)
        hasher.combine(receiverAccountID)
    }
}

