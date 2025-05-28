//
//  HomeScreenComponentHeaderView.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/11/2024.
//

import SwiftUI
import NavigationKit
import TheoKit

struct HomeScreenComponentHeaderView: View {
    
    // Builder
    var type: HomeScreenComponentHeaderType
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        NavigationButton(route: .push, destination: type.destination) {
            HStack(spacing: 8) {
                Text(type.title)
                    .foregroundStyle(Color.label)
                    .font(TKDesignSystem.Fonts.Title.medium)
                    .fullWidth(.leading)
                
                Image(.iconArrowRight)
                    .renderingMode(.template)
                    .foregroundStyle(themeManager.theme.color)
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
        case .recentTransactions:   return "word_last_transactions".localized
        case .savingsPlan:          return "word_savingsplans".localized
        case .subscription:         return "word_subscriptions".localized
        }
    }
    
    var destination: AppDestination {
        switch self {
        case .recentTransactions:   return AppDestination.transaction(.list)
        case .savingsPlan:          return AppDestination.savingsPlan(.list)
        case .subscription:         return AppDestination.subscription(.list)
        }
    }
}

// MARK: - Preview
#Preview {
    HomeScreenComponentHeaderView(type: .recentTransactions)
}
