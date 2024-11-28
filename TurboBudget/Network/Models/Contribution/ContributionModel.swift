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

class ContributionModel: Codable, Identifiable, Equatable, ObservableObject, Hashable {
    @Published var id: Int?
    @Published var amount: Double?
    @Published var typeNum: Int? // ContributionType
    @Published var date: String?

    // Initialiseur
    init(id: Int? = nil, amount: Double? = nil, typeNum: Int? = nil, date: String? = nil) {
        self.id = id
        self.amount = amount
        self.typeNum = typeNum
        self.date = date
    }

    // Conformance au protocole Codable
    private enum CodingKeys: String, CodingKey {
        case id, amount, date
        case typeNum = "type"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        amount = try container.decodeIfPresent(Double.self, forKey: .amount)
        typeNum = try container.decodeIfPresent(Int.self, forKey: .typeNum)
        date = try container.decodeIfPresent(String.self, forKey: .date)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(typeNum, forKey: .typeNum)
        try container.encodeIfPresent(date, forKey: .date)
    }

    // Fonction pour le protocole Equatable
    static func == (lhs: ContributionModel, rhs: ContributionModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.amount == rhs.amount &&
               lhs.typeNum == rhs.typeNum &&
               lhs.date == rhs.date
            
    }

    // Fonction pour le protocole Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(amount)
        hasher.combine(typeNum)
        hasher.combine(date)
    }
}

extension ContributionModel {
    
    var type: ContributionType? {
        return ContributionType(rawValue: typeNum ?? 0)
    }
    
}
