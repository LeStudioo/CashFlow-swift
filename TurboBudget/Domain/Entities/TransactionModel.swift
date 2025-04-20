//
//  TransactionModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 12/11/2024.
//

import Foundation
import SwiftUICore
import CoreLocation

enum TransactionType: Int, CaseIterable {
    case expense = 0
    case income = 1
    case transfer = 2
    
    var name: String {
        switch self {
        case .expense:  return Word.Classic.expense
        case .income:   return Word.Classic.income
        case .transfer: return Word.Main.transfer
        }
    }
}

struct TransactionModel: Codable, Identifiable, Equatable, Hashable {
    var id: Int?
    var _name: String?
    var amount: Double?
    var typeNum: Int? // TransactionType
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
    
    /// Transaction init
    init(
        id: Int? = nil,
        _name: String? = nil,
        amount: Double? = nil,
        typeNum: Int? = nil,
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
        self._name = _name
        self.amount = amount
        self.typeNum = typeNum
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
    init(
        _name: String,
        amount: Double,
        typeNum: Int,
        dateISO: String,
        categoryID: Int,
        subcategoryID: Int? = nil
    ) {
        self._name = _name
        self.amount = amount
        self.typeNum = typeNum
        self.dateISO = dateISO
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
    }
    
    /// Transfer init
    init(
        id: Int? = nil,
        amount: Double? = nil,
        typeNum: Int? = nil,
        dateISO: String? = nil,
        creationDate: String? = nil,
        senderAccountID: Int? = nil,
        receiverAccountID: Int? = nil,
        note: String? = nil
    ) {
        self.id = id
        self.amount = amount
        self.typeNum = typeNum
        self.dateISO = dateISO
        self.creationDate = creationDate
        self.senderAccountID = senderAccountID
        self.receiverAccountID = receiverAccountID
        self.note = note
    }
    
    // Conformance au protocole Codable
    private enum CodingKeys: String, CodingKey {
        case id
        case amount
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
        case _name = "name"
        case typeNum = "type"
        case dateISO = "date"
        case address
        case lat
        case long
    }
}

extension TransactionModel {
    
    var category: CategoryModel? {
        return CategoryStore.shared.findCategoryById(categoryID)
    }
    
    var subcategory: SubcategoryModel? {
        return CategoryStore.shared.findSubcategoryById(subcategoryID)
    }
    
    var type: TransactionType {
        return TransactionType(rawValue: typeNum ?? 0) ?? .expense
    }
    
    var date: Date {
        return self.dateISO?.toDate() ?? .now
    }
    
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat ?? 0, longitude: long ?? 0)
    }

}

extension TransactionModel {
    
    var isSender: Bool {
        guard let selectedAccount = AccountStore.shared.selectedAccount, let accountID = selectedAccount._id else { return false }
        return senderAccountID == accountID
    }
    
    var name: String {
        switch type {
        case .expense, .income:
            return self._name ?? ""
        case .transfer:
            guard let receiverAccountID = receiverAccountID else { return "" }
            guard let senderAccountID = senderAccountID else { return "" }
            
            if isSender {
                let receiverAccountName = AccountStore.shared.findByID(receiverAccountID)?.name ?? ""
                return [Word.Classic.sent, Word.Preposition.to, receiverAccountName].joined(separator: " ")
            } else {
                let senderAccountName = AccountStore.shared.findByID(senderAccountID)?.name ?? ""
                return [Word.Classic.received, Word.Preposition.from, senderAccountName].joined(separator: " ")
            }
        }
    }
    
    var symbol: String {
        switch type {
        case .expense:  return "-"
        case .income:   return "+"
        case .transfer:
            if isSender {
                return "-"
            } else {
                return "+"
            }
        }
    }
    
    var color: Color {
        switch type {
        case .expense:
            return .error400
        case .income:
            return .primary500
        case .transfer:
            return isSender ? .error400 : .primary500
        }
    }
    
}
