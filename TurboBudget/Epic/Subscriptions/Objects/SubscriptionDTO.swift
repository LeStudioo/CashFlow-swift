//
//  SubscriptionDTO.swift
//  CashFlow
//
//  Created by Theo Sementa on 27/04/2025.
//

import Foundation
import NetworkKit

struct SubscriptionDTO: Codable {
    var id: Int?
    var name: String?
    var amount: Double?
    var typeNum: Int?
    var frequencyNum: Int? // SubscriptionFrequency
    var frequencyDate: String?
    var categoryID: Int?
    var subcategoryID: Int?
    var firstSubscriptionDate: String?
    var transactions: [TransactionDTO]?

    // Initialiseur
    init(
        id: Int? = nil,
        name: String? = nil,
        amount: Double? = nil,
        typeNum: Int? = nil,
        frequencyNum: Int? = nil,
        frequencyDate: String? = nil,
        categoryID: Int? = nil,
        subcategoryID: Int? = nil,
        firstSubscriptionDate: String? = nil,
        transactions: [TransactionDTO]? = nil
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.typeNum = typeNum
        self.frequencyNum = frequencyNum
        self.frequencyDate = frequencyDate
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
        self.firstSubscriptionDate = firstSubscriptionDate
        self.transactions = transactions
    }
    
    /// Body
    init(
        name: String,
        amount: Double,
        type: TransactionType,
        frequency: SubscriptionFrequency,
        frequencyDate: Date,
        categoryID: Int,
        subcategoryID: Int? = nil
    ) {
        self.name = name
        self.amount = amount
        self.typeNum = type.rawValue
        self.frequencyNum = frequency.rawValue
        self.frequencyDate = frequencyDate.toISO()
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
    }

    // Conformance au protocole Codable
    private enum CodingKeys: String, CodingKey {
        case id, name, amount, frequencyDate, categoryID, subcategoryID, transactions
        case typeNum = "type"
        case frequencyNum = "frequency"
        case firstSubscriptionDate
    }
}

extension SubscriptionDTO {
 
    func toModel() throws -> SubscriptionModel {
        guard let id,
              let name,
              let amount,
              let typeNum,
              let frequencyNum,
              let frequencyDate,
              let categoryID else { throw NetworkError.unknown }
        
        guard let type = TransactionType(rawValue: typeNum),
              let frequency = SubscriptionFrequency(rawValue: frequencyNum),
              let date = frequencyDate.toDate() else {
            throw NetworkError.unknown
        }
        
        let transactionModels = try? transactions?.map { try $0.toModel() }
        
        return SubscriptionModel(
            id: id,
            name: name,
            amount: amount,
            type: type,
            frequency: frequency,
            frequencyDate: date,
            categoryID: categoryID,
            subcategoryID: subcategoryID,
            firstSubscriptionDate: firstSubscriptionDate?.toDate(),
            transactions: transactionModels
        )
    }
    
}
