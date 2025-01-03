//
//  AccountModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 12/11/2024.
//

import Foundation

enum AccountType: Int, CaseIterable {
    case classic = 0
    case savings = 1
}

struct AccountModel: Codable, Identifiable, Equatable, Hashable {
    var id: Int?
    var _name: String?
    var _balance: Double?
    var typeNum: Int?
    var maxAmount: Double?

    /// Classic Account Initialiseur
    init(
        id: Int? = nil,
        name: String? = nil,
        balance: Double? = nil,
        typeNum: Int? = nil
    ) {
        self.id = id
        self._name = name
        self._balance = balance
        self.typeNum = typeNum
    }
    
    /// Savings Account Initialiseur
    init(
        id: Int? = nil,
        name: String? = nil,
        balance: Double? = nil,
        typeNum: Int? = nil,
        maxAmount: Double? = nil
    ) {
        self.id = id
        self._name = name
        self._balance = balance
        self.typeNum = typeNum
        self.maxAmount = maxAmount
    }
    
    /// Classic Account Body
    init(
        name: String,
        balance: Double,
        typeNum: Int = AccountType.classic.rawValue
    ) {
        self._name = name
        self._balance = balance
        self.typeNum = typeNum
    }
    
    /// Savings Account Body
    init(
        name: String,
        balance: Double,
        typeNum: Int = AccountType.savings.rawValue,
        maxAmount: Double
    ) {
        self._name = name
        self._balance = balance
        self.typeNum = typeNum
        self.maxAmount = maxAmount
    }

    // Conformance au protocole Codable
    private enum CodingKeys: String, CodingKey {
        case id, maxAmount
        case _name = "name"
        case _balance = "balance"
        case typeNum = "type"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        _name = try container.decodeIfPresent(String.self, forKey: ._name)
        _balance = try container.decodeIfPresent(Double.self, forKey: ._balance)
        typeNum = try container.decodeIfPresent(Int.self, forKey: .typeNum)
        maxAmount = try container.decodeIfPresent(Double.self, forKey: .maxAmount)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(_name, forKey: ._name)
        try container.encodeIfPresent(_balance, forKey: ._balance)
        try container.encodeIfPresent(typeNum, forKey: .typeNum)
        try container.encodeIfPresent(maxAmount, forKey: .maxAmount)
    }
}

extension AccountModel {
    
    var name: String {
        return self._name ?? ""
    }
    
    var balance: Double {
        return self._balance ?? 0
    }
    
    var type: AccountType? {
        guard let typeNum else { return nil }
        return AccountType(rawValue: typeNum)
    }
    
}
