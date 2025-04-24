//
//  HomeScreenComponentHeader.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/11/2024.
//

import SwiftUI
import NavigationKit

struct HomeScreenComponentHeader: View {
    
    // Builder
    var type: HomeScreenComponentHeaderType
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        NavigationButton(route: .push, destination: type.destination) {
            HStack(spacing: 8) {
                Image(systemName: type.icon)
                    .foregroundStyle(Color.customGray)
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                
                Text(type.title)
                    .foregroundStyle(Color.customGray)
                    .font(.semiBoldCustom(size: 22))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "arrow.right")
                    .foregroundStyle(themeManager.theme.color)
                    .font(.system(size: 20, weight: .medium, design: .rounded))
            }
        }
    } // body
} // struct

// MARK: -
enum HomeScreenComponentHeaderType {
    case recentTransactions
    case savingsPlan
    case subscription
    
    var title: String {
        switch self {
        case .recentTransactions:   return Word.Title.Transaction.home
        case .savingsPlan:          return Word.Title.SavingsPlan.home
        case .subscription:         return Word.Title.Subscription.home
        }
    }
    
    var destination: AppDestination {
        switch self {
        case .recentTransactions:   return AppDestination.transaction(.list)
        case .savingsPlan:          return AppDestination.savingsPlan(.list)
        case .subscription:         return AppDestination.subscription(.list)
        }
    }
    
    var icon: String {
        switch self {
        case .recentTransactions:   return "creditcard.and.123"
        case .savingsPlan:          return "dollarsign.square.fill"
        case .subscription:         return "clock.arrow.circlepath"
        }
    }
}

// MARK: - Preview
#Preview {
    HomeScreenComponentHeader(type: .recentTransactions)
}
