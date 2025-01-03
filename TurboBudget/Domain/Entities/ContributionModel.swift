//
//  ContributionModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 12/11/2024.
//

import Foundation

enum ContributionType: Int, CaseIterable {
    case addition = 0
    case withdrawal = 1
    
    var name: String {
        switch self {
        case .addition:     return "contribution_add".localized
        case .withdrawal:   return "contribution_withdraw".localized
        }
    }
}

struct ContributionModel: Codable, Identifiable, Equatable, Hashable {
    var id: Int?
    var amount: Double?
    var typeNum: Int? // ContributionType
    var dateString: String?

    // Initialiseur
    init(id: Int? = nil, amount: Double? = nil, typeNum: Int? = nil, dateString: String? = nil) {
        self.id = id
        self.amount = amount
        self.typeNum = typeNum
        self.dateString = dateString
    }

    // Conformance au protocole Codable
    private enum CodingKeys: String, CodingKey {
        case id, amount
        case dateString = "date"
        case typeNum = "type"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        amount = try container.decodeIfPresent(Double.self, forKey: .amount)
        typeNum = try container.decodeIfPresent(Int.self, forKey: .typeNum)
        dateString = try container.decodeIfPresent(String.self, forKey: .dateString)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(typeNum, forKey: .typeNum)
        try container.encodeIfPresent(dateString, forKey: .dateString)
    }
}

extension ContributionModel {
    
    var type: ContributionType {
        return ContributionType(rawValue: typeNum ?? 0) ?? .addition
    }
    
    var symbol: String {
        switch type {
        case .addition:     return "+"
        case .withdrawal:   return "-"
        }
    }
    
    var date: Date {
        return self.dateString?.toDate() ?? .now
    }
    
}
