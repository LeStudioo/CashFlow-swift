//
//  TransactionModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 12/11/2024.
//

import Foundation
import SwiftUICore
import CoreLocation
import TheoKit
import CoreModule

struct TransactionModel: Identifiable, Equatable, Hashable {
    var id: Int
    var name: String
    var amount: Double
    var date: Date
    var creationDate: Date?
    var category: CategoryModel?
    var subcategory: SubcategoryModel?
    var note: String?
    
    var isFromSubscription: Bool
    var isFromApplePay: Bool
    var nameFromApplePay: String?
    var autoCat: Bool?
    
    var senderAccount: AccountModel?
    var receiverAccount: AccountModel?
    
    var address: String?
    var lat: Double?
    var long: Double?
}

extension TransactionModel {
    
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat ?? 0, longitude: long ?? 0)
    }

}

extension TransactionModel: Searchable {
    var searchableText: String {
        return nameDisplayed
    }
}

extension TransactionModel {
    
    var type: TransactionType {
        if self.senderAccount != nil, self.receiverAccount != nil {
            return .transfer
        }
        
        if category?.isIncome == true {
            return .income
        } else {
            return .expense
        }
    }
    
    var isSender: Bool {
        guard let selectedAccount = AccountStore.shared.selectedAccount else { return false }
        return senderAccount?.id == selectedAccount.id
    }
    
    var nameDisplayed: String {
        switch type {
        case .expense, .income:
            return self.name
        case .transfer:
            guard let senderAccount, let receiverAccount else { return "" }
            
            if isSender {
                let receiverAccountName = receiverAccount.name
                return [Word.Classic.sent, Word.Preposition.to, receiverAccountName].joined(separator: " ")
            } else {
                let senderAccountName = senderAccount.name
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
            return TKDesignSystem.Colors.Error.c500
        case .income:
            return .primary500
        case .transfer:
            return isSender ? TKDesignSystem.Colors.Error.c500 : .primary500
        }
    }
    
}
