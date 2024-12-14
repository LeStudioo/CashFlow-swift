//
//  TransactionModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 12/11/2024.
//

import Foundation
import SwiftUICore

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

class TransactionModel: Codable, Identifiable, Equatable, ObservableObject, Hashable {
    @Published var id: Int?
    @Published var _name: String?
    @Published var amount: Double?
    @Published var typeNum: Int? // TransactionType
    @Published var dateISO: String?
    @Published var creationDate: String?
    @Published var categoryID: Int?
    @Published var subcategoryID: Int?
    @Published var note: String?
    
    @Published var isFromSubscription: Bool?
    @Published var isFromApplePay: Bool?
    @Published var nameFromApplePay: String?
    
    @Published var senderAccountID: Int?
    @Published var receiverAccountID: Int?
    
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
        note: String? = nil
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
        self.note = note
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
        self._name = _name
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
        case id, amount, creationDate, categoryID, subcategoryID, isFromSubscription, isFromApplePay, nameFromApplePay, senderAccountID, receiverAccountID, note
        case _name = "name"
        case typeNum = "type"
        case dateISO = "date"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        _name = try container.decodeIfPresent(String.self, forKey: ._name)
        amount = try container.decodeIfPresent(Double.self, forKey: .amount)
        typeNum = try container.decodeIfPresent(Int.self, forKey: .typeNum)
        dateISO = try container.decodeIfPresent(String.self, forKey: .dateISO)
        creationDate = try container.decodeIfPresent(String.self, forKey: .creationDate)
        categoryID = try container.decodeIfPresent(Int.self, forKey: .categoryID)
        subcategoryID = try container.decodeIfPresent(Int.self, forKey: .subcategoryID)
        isFromSubscription = try container.decodeIfPresent(Bool.self, forKey: .isFromSubscription)
        isFromApplePay = try container.decodeIfPresent(Bool.self, forKey: .isFromApplePay)
        nameFromApplePay = try container.decodeIfPresent(String.self, forKey: .nameFromApplePay)
        senderAccountID = try container.decodeIfPresent(Int.self, forKey: .senderAccountID)
        receiverAccountID = try container.decodeIfPresent(Int.self, forKey: .receiverAccountID)
        note = try container.decodeIfPresent(String.self, forKey: .note)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(_name, forKey: ._name)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(typeNum, forKey: .typeNum)
        try container.encodeIfPresent(dateISO, forKey: .dateISO)
        try container.encodeIfPresent(creationDate, forKey: .creationDate)
        try container.encodeIfPresent(categoryID, forKey: .categoryID)
        try container.encodeIfPresent(subcategoryID, forKey: .subcategoryID)
        try container.encodeIfPresent(isFromSubscription, forKey: .isFromSubscription)
        try container.encodeIfPresent(isFromApplePay, forKey: .isFromApplePay)
        try container.encodeIfPresent(nameFromApplePay, forKey: .nameFromApplePay)
        try container.encodeIfPresent(senderAccountID, forKey: .senderAccountID)
        try container.encodeIfPresent(receiverAccountID, forKey: .receiverAccountID)
        try container.encodeIfPresent(note, forKey: .note)
    }
    
    // Fonction pour le protocole Equatable
    static func == (lhs: TransactionModel, rhs: TransactionModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs._name == rhs._name &&
        lhs.amount == rhs.amount &&
        lhs.typeNum == rhs.typeNum &&
        lhs.dateISO == rhs.dateISO &&
        lhs.creationDate == rhs.creationDate &&
        lhs.categoryID == rhs.categoryID &&
        lhs.subcategoryID == rhs.subcategoryID &&
        lhs.isFromSubscription == rhs.isFromSubscription &&
        lhs.isFromApplePay == rhs.isFromApplePay &&
        lhs.nameFromApplePay == rhs.nameFromApplePay &&
        lhs.senderAccountID == rhs.senderAccountID &&
        lhs.receiverAccountID == rhs.receiverAccountID &&
        lhs.note == rhs.note
    }
    
    // Fonction pour le protocole Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(_name)
        hasher.combine(amount)
        hasher.combine(typeNum)
        hasher.combine(dateISO)
        hasher.combine(creationDate)
        hasher.combine(categoryID)
        hasher.combine(subcategoryID)
        hasher.combine(isFromSubscription)
        hasher.combine(isFromApplePay)
        hasher.combine(nameFromApplePay)
        hasher.combine(senderAccountID)
        hasher.combine(receiverAccountID)
        hasher.combine(note)
    }
}

extension TransactionModel {
    
    var category: CategoryModel? {
        return CategoryRepository.shared.findCategoryById(categoryID)
    }
    
    var subcategory: SubcategoryModel? {
        return CategoryRepository.shared.findSubcategoryById(subcategoryID)
    }
    
    var type: TransactionType {
        return TransactionType(rawValue: typeNum ?? 0) ?? .expense
    }
    
    var date: Date {
        return self.dateISO?.toDate() ?? .now
    }

}

extension TransactionModel {
    
    var isSender: Bool {
        guard let selectedAccount = AccountRepository.shared.selectedAccount, let accountID = selectedAccount.id else { return false }
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
                let receiverAccountName = AccountRepository.shared.findByID(receiverAccountID)?.name ?? ""
                return [Word.Classic.sent, Word.Preposition.to, receiverAccountName].joined(separator: " ")
            } else {
                let senderAccountName = AccountRepository.shared.findByID(senderAccountID)?.name ?? ""
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
