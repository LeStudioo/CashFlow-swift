//
//  PredefinedCategoryNew.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation
import SwiftUI

enum PredefinedCategoryNew: String, CaseIterable {
    case notInCategory
    case income
    case shopping
    case restaurants
    case pets
    case loans
    case savings
    case taxes
    case housing
    case leisure
    case withdrawal
    case health
    case transport
    case work
}

extension PredefinedCategoryNew: Identifiable {
    var id: String { return self.rawValue }
}

extension PredefinedCategoryNew {
    
    var oldID: String {
        switch self {
        case .notInCategory:    return "PREDEFCAT00"
        case .income:           return "PREDEFCAT0"
        case .shopping:         return "PREDEFCAT1"
        case .restaurants:      return "PREDEFCAT2"
        case .pets:             return "PREDEFCAT3"
        case .loans:            return "PREDEFCAT4"
        case .savings:          return "PREDEFCAT5"
        case .taxes:            return "PREDEFCAT6"
        case .housing:          return "PREDEFCAT7"
        case .leisure:          return "PREDEFCAT8"
        case .withdrawal:       return "PREDEFCAT9"
        case .health:           return "PREDEFCAT10"
        case .transport:        return "PREDEFCAT11"
        case .work:             return "PREDEFCAT12"
        }
    }
    
    var title: String {
        switch self {
        case .notInCategory:    return "category00_name".localized
        case .income:           return "word_incomes".localized
        case .shopping:         return "category1_name".localized
        case .restaurants:      return "category2_name".localized
        case .pets:             return "category3_name".localized
        case .loans:            return "category4_name".localized
        case .savings:          return "category5_name".localized
        case .taxes:            return "category6_name".localized
        case .housing:          return "category7_name".localized
        case .leisure:          return "category8_name".localized
        case .withdrawal:       return "category9_name".localized
        case .health:           return "category10_name".localized
        case .transport:        return "category11_name".localized
        case .work:             return "category12_name".localized
        }
    }
    
    var icon: String {
        switch self {
        case .notInCategory:    return "questionmark"
        case .income:           return "tray.and.arrow.down"
        case .shopping:         return "cart.fill"
        case .restaurants:      return "fork.knife"
        case .pets:             return "pawprint.fill"
        case .loans:            return "creditcard.fill"
        case .savings:          return "chart.bar.fill"
        case .taxes:            return "chart.line.downtrend.xyaxis"
        case .housing:          return "house.fill"
        case .leisure:          return "sun.max"
        case .withdrawal:       return "creditcard.and.123"
        case .health:           return "cross"
        case .transport:        return "car.side.fill"
        case .work:             return "building.2.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .notInCategory:    return .gray.lighter(by: 4)
        case .income:           return .green
        case .shopping:         return .red
        case .restaurants:      return .orange
        case .pets:             return .yellow
        case .loans:            return .green
        case .savings:          return .mint
        case .taxes:            return .teal
        case .housing:          return .cyan
        case .leisure:          return .blue
        case .withdrawal:       return .indigo
        case .health:           return .purple
        case .transport:        return .pink
        case .work:             return .brown
        }
    }
    
}
