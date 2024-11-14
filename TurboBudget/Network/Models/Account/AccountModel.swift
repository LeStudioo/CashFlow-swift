//
//  AccountModel.swift
//  FixBounce
//
//  Created by Theo Sementa on 12/11/2024.
//

import Foundation

enum AccountType: Int, CaseIterable {
    case classic = 0
    case savings = 1
}

class AccountModel: Codable, Identifiable, Equatable, ObservableObject, Hashable {
    @Published var id: Int?
    @Published var name: String?
    @Published var balance: Double?
    @Published var type: Int?
    @Published var maxAmount: Double?

    // Classic Account Initialiseur
    init(
        id: Int? = nil,
        name: String? = nil,
        balance: Double? = nil,
        type: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.balance = balance
        self.type = type
    }
    
    // Savings Account Initialiseur
    init(
        id: Int? = nil,
        name: String? = nil,
        balance: Double? = nil,
        type: Int? = nil,
        maxAmount: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.balance = balance
        self.type = type
        self.maxAmount = maxAmount
    }

    // Conformance au protocole Codable
    private enum CodingKeys: String, CodingKey {
        case id, name, balance, type, maxAmount
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        balance = try container.decodeIfPresent(Double.self, forKey: .balance)
        type = try container.decodeIfPresent(Int.self, forKey: .type)
        maxAmount = try container.decodeIfPresent(Double.self, forKey: .maxAmount)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(balance, forKey: .balance)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(maxAmount, forKey: .maxAmount)
    }

    // Fonction pour le protocole Equatable
    static func == (lhs: AccountModel, rhs: AccountModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.balance == rhs.balance &&
               lhs.type == rhs.type &&
               lhs.maxAmount == rhs.maxAmount
    }

    // Fonction pour le protocole Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(balance)
        hasher.combine(type)
        hasher.combine(maxAmount)
    }
}

