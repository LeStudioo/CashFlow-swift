//
//  CreditCardModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation

struct CreditCardModel: Codable, Identifiable, Equatable, Hashable {
    var id: Int?
    var uuid: UUID?
    var holder: String
    var number: String
    var cvc: String
    var expirateDate: String
    var limitByMonth: Double?

    // Initialiseur
    init(id: Int? = nil, uuid: UUID? = nil, holder: String, number: String, cvc: String, expirateDate: String, limitByMonth: Double? = nil) {
        self.id = id
        self.uuid = uuid
        self.holder = holder
        self.number = number
        self.cvc = cvc
        self.expirateDate = expirateDate
        self.limitByMonth = limitByMonth
    }

    // Enumération pour les clés de codage/décodage
    private enum CodingKeys: String, CodingKey {
        case id, uuid, holder, number, cvc, expirateDate, limitByMonth
    }

    // Implémentation de Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        uuid = try container.decodeIfPresent(UUID.self, forKey: .uuid)
        holder = try container.decode(String.self, forKey: .holder)
        number = try container.decode(String.self, forKey: .number)
        cvc = try container.decode(String.self, forKey: .cvc)
        expirateDate = try container.decode(String.self, forKey: .expirateDate)
        limitByMonth = try container.decode(Double.self, forKey: .limitByMonth)
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
        try container.encode(limitByMonth, forKey: .limitByMonth)
    }
}

extension CreditCardModel {
    
    var balanceAvailable: Double? {
        guard let limitByMonth else { return nil }
        let spent = TransactionStore.shared.expensesCurrentMonth
            .compactMap(\.amount)
            .reduce(0, +)
        
        return limitByMonth - spent
    }
    
}

extension CreditCardModel {
    
    static let mock: CreditCardModel = .init(
        uuid: UUID(),
        holder: "Test Holder",
        number: "1234 5678 9012 3456",
        cvc: "123",
        expirateDate: Date().toISO(),
        limitByMonth: 1500
    )
    
}
