//
//  SubscriptionFrequency.swift
//  CashFlow
//
//  Created by Theo Sementa on 30/04/2025.
//

import Foundation

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
