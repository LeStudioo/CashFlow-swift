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
    var _id: Int?
    var _name: String?
    var _balance: Double?
    var typeNum: Int?
    var maxAmount: Double?
    var createdAtRaw: String?
    var isMain: Bool?
    
    var id: String {
        return String(_id ?? 0)
    }

    /// Classic Account Initialiseur
    init(
        id: Int? = nil,
        name: String? = nil,
        balance: Double? = nil,
        typeNum: Int? = nil,
        createdAtRaw: String? = nil,
        isMain: Bool? = nil
    ) {
        self._id = id
        self._name = name
        self._balance = balance
        self.typeNum = typeNum
        self.createdAtRaw = createdAtRaw
        self.isMain = isMain
    }
    
    /// Savings Account Initialiseur
    init(
        id: Int? = nil,
        name: String? = nil,
        balance: Double? = nil,
        typeNum: Int? = nil,
        maxAmount: Double? = nil,
        createdAtRaw: String? = nil,
        isMain: Bool? = nil
    ) {
        self._id = id
        self._name = name
        self._balance = balance
        self.typeNum = typeNum
        self.maxAmount = maxAmount
        self.createdAtRaw = createdAtRaw
        self.isMain = isMain
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
        case maxAmount
        case _id = "id"
        case _name = "name"
        case _balance = "balance"
        case typeNum = "type"
        case createdAtRaw = "createdAt"
        case isMain
    }
}

extension AccountModel: Searchable {
    var searchableText: String {
        return name
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
    
    var createdAt: Date? {
        guard let createdAtRaw else { return nil }
        return createdAtRaw.toDate()
    }
    
}
