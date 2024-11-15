//
//  CreditCardModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation

class CreditCardModel: Codable, Identifiable, Equatable, ObservableObject, Hashable {
    @Published var id: Int?
    @Published var uuid: UUID?
    @Published var holder: String
    @Published var number: String
    @Published var cvc: String
    @Published var expirateDate: String

    // Initialiseur
    init(id: Int? = nil, uuid: UUID? = nil, holder: String, number: String, cvc: String, expirateDate: String) {
        self.id = id
        self.uuid = uuid
        self.holder = holder
        self.number = number
        self.cvc = cvc
        self.expirateDate = expirateDate
    }

    // Enumération pour les clés de codage/décodage
    private enum CodingKeys: String, CodingKey {
        case id, uuid, holder, number, cvc, expirateDate
    }

    // Implémentation de Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        uuid = try container.decodeIfPresent(UUID.self, forKey: .uuid)
        holder = try container.decode(String.self, forKey: .holder)
        number = try container.decode(String.self, forKey: .number)
        cvc = try container.decode(String.self, forKey: .cvc)
        expirateDate = try container.decode(String.self, forKey: .expirateDate)
    }

    // Implémentation de Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(uuid, forKey: .uuid)
        try container.encode(holder, forKey: .holder)
        try container.encode(number, forKey: .number)
        try container.encode(cvc, forKey: .cvc)
        try container.encode(expirateDate, forKey: .expirateDate)
    }

    // Implémentation de Equatable
    static func == (lhs: CreditCardModel, rhs: CreditCardModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.uuid == rhs.uuid &&
               lhs.holder == rhs.holder &&
               lhs.number == rhs.number &&
               lhs.cvc == rhs.cvc &&
               lhs.expirateDate == rhs.expirateDate
    }

    // Implémentation de Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(uuid)
        hasher.combine(holder)
        hasher.combine(number)
        hasher.combine(cvc)
        hasher.combine(expirateDate)
    }
}
