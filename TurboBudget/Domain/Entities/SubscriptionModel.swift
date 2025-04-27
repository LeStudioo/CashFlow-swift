//
//  SubscriptionModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 12/11/2024.
//

import Foundation
import SwiftUICore

enum SubscriptionFrequency: Int, Codable, CaseIterable {
    case monthly = 0
    case yearly = 1
    case weekly = 2
    
    var name: String {
        switch self {
        case .monthly: return Word.Frequency.monthly
        case .yearly: return Word.Frequency.yearly
        case .weekly: return Word.Frequency.weekly
        }
    }
}

struct SubscriptionModel: Identifiable, Equatable, Hashable {
    var id: Int
    var name: String
    var amount: Double
    var type: TransactionType
    var frequency: SubscriptionFrequency
    var frequencyDate: Date
    var categoryID: Int
    var subcategoryID: Int?
    var firstSubscriptionDate: Date?

    // Initialiseur
    init(
        id: Int,
        name: String,
        amount: Double,
        type: TransactionType,
        frequency: SubscriptionFrequency,
        frequencyDate: Date,
        categoryID: Int,
        subcategoryID: Int? = nil,
        firstSubscriptionDate: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.type = type
        self.frequency = frequency
        self.frequencyDate = frequencyDate
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
        self.firstSubscriptionDate = firstSubscriptionDate
    }
    
}

extension SubscriptionModel {
    
    var category: CategoryModel? {
        return CategoryStore.shared.findCategoryById(categoryID)
    }
    
    var subcategory: SubcategoryModel? {
        return CategoryStore.shared.findSubcategoryById(subcategoryID)
    }

    var symbol: String {
        switch type {
        case .expense:  return "-"
        case .income:   return "+"
        case .transfer: return ""
        }
    }
    
    var color: Color {
        switch type {
        case .expense:
            return .error400
        case .income:
            return .primary500
        default:
            return .gray
        }
    }
    
    var notifMessage: String {
        let daysBefore = PreferencesSubscription.shared.dayBeforeReceiveNotification
        let notifMessage = self.type == .expense ? Word.Notifications.willRemoved : Word.Notifications.willAdded
        return "\(self.amount)\(UserCurrency.symbol) \(notifMessage) \(daysBefore) \(Word.Classic.days). (\(self.name))"
    }
    
    var dateNotif: Date {
        var components = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: frequencyDate)
        components.hour = 10
        components.minute = 0
        components.timeZone = TimeZone.current
        return Calendar.current.date(from: components) ?? frequencyDate
    }
}
