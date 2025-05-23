//
//  TransactionDTO.swift
//  CashFlow
//
//  Created by Theo Sementa on 30/04/2025.
//

import Foundation

struct TransactionDTO: Codable {
    var id: Int?
    var name: String?
    var amount: Double?
    var type: Int?
    var dateISO: String?
    var creationDate: String?
    var categoryID: Int?
    var subcategoryID: Int?
    var note: String?
    
    var isFromSubscription: Bool?
    var isFromApplePay: Bool?
    var nameFromApplePay: String?
    var autoCat: Bool?
    
    var senderAccountID: Int?
    var receiverAccountID: Int?
    
    var address: String?
    var lat: Double?
    var long: Double?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case amount
        case type
        case dateISO = "date"

        case creationDate
        case categoryID
        case subcategoryID
        case isFromSubscription
        case isFromApplePay
        case nameFromApplePay
        case senderAccountID
        case receiverAccountID
        case note
        case autoCat
        case address
        case lat
        case long
    }
}

// MARK: - Transaction
extension TransactionDTO {
    
    /// Transaction init
    init(
        id: Int? = nil,
        name: String? = nil,
        amount: Double? = nil,
        type: Int? = nil,
        dateISO: String? = nil,
        creationDate: String? = nil,
        categoryID: Int? = nil,
        subcategoryID: Int? = nil,
        isFromSubscription: Bool? = nil,
        isFromApplePay: Bool? = nil,
        nameFromApplePay: String? = nil,
        autoCat: Bool? = nil,
        note: String? = nil,
        address: String? = nil,
        lat: Double? = nil,
        long: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.type = type
        self.dateISO = dateISO
        self.creationDate = creationDate
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
        self.isFromSubscription = isFromSubscription
        self.isFromApplePay = isFromApplePay
        self.nameFromApplePay = nameFromApplePay
        self.autoCat = autoCat
        self.note = note
        self.address = address
        self.lat = lat
        self.long = long
    }
    
    /// Classic Transaction Body
    static func body(
        name: String,
        amount: Double,
        type: Int,
        dateISO: String,
        categoryID: Int? = nil,
        subcategoryID: Int? = nil
    ) -> TransactionDTO {
        return .init(
            name: name,
            amount: amount,
            type: type,
            dateISO: dateISO,
            categoryID: categoryID,
            subcategoryID: subcategoryID
        )
    }
    
}

// MARK: - Transfer
extension TransactionDTO {
    
    /// Transfer init
    init(
        id: Int? = nil,
        amount: Double? = nil,
        dateISO: String? = nil,
        creationDate: String? = nil,
        senderAccountID: Int? = nil,
        receiverAccountID: Int? = nil,
        note: String? = nil
    ) {
        self.id = id
        self.amount = amount
        self.dateISO = dateISO
        self.creationDate = creationDate
        self.senderAccountID = senderAccountID
        self.receiverAccountID = receiverAccountID
        self.note = note
    }
    
}

extension TransactionDTO {
    
    func toModel() throws -> TransactionModel {
        guard let id,
              let amount,
              let dateISO
        else { throw NetworkError.unknown }
                
        let date = dateISO.toDate()
        let category = CategoryStore.shared.findCategoryById(categoryID)
        
        let subcategory = CategoryStore.shared.findSubcategoryById(subcategoryID)
        
        let senderAccount = AccountStore.shared.findByID(senderAccountID)
        let receiverAccount = AccountStore.shared.findByID(receiverAccountID)
        
        return .init(
            id: id,
            name: name ?? "",
            amount: amount,
            date: date ?? .now,
            creationDate: creationDate?.toDate(),
            category: category,
            subcategory: subcategory,
            note: note,
            isFromSubscription: isFromSubscription ?? false,
            isFromApplePay: isFromApplePay ?? false,
            nameFromApplePay: nameFromApplePay,
            autoCat: autoCat,
            senderAccount: senderAccount,
            receiverAccount: receiverAccount,
            address: address,
            lat: lat,
            long: long
        )
    }
    
}
