//
//  HomeScreenEmptyRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/11/2024.
//

import SwiftUI
import NavigationKit

struct HomeScreenEmptyRow: View {
    
    // Builder
    var type: HomeScreenEmptyRowType
        
    // MARK: -
    var body: some View {
        NavigationButton(route: .sheet, destination: type.destination) {
            VStack(spacing: 24) {
                Text(type.title)
                    .font(Font.mediumText16())
                    .multilineTextAlignment(.center)
                
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .semibold))
            }
            
            .foregroundStyle(Color.text)
            .padding(24)
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.background100)
            }
        }
    } // body
} // struct

// MARK: -
enum HomeScreenEmptyRowType {
    case savingsPlan
    case subscription
    case recentTransactions
    
    var title: String {
        switch self {
        case .savingsPlan:          return Word.Empty.SavingsPlan.desc
        case .subscription:         return Word.Empty.Subscription.desc
        case .recentTransactions:   return Word.Empty.Transaction.desc
        }
    }
    
    var image: String {
        switch self {
        case .savingsPlan:          return "NoSavingPlan\(ThemeManager.shared.theme.nameNotLocalized.capitalized)"
        case .subscription:         return "NoAutomation\(ThemeManager.shared.theme.nameNotLocalized.capitalized)"
        case .recentTransactions:   return "NoTransaction\(ThemeManager.shared.theme.nameNotLocalized.capitalized)"
        }
    }
    
    var destination: AppDestination {
        switch self {
        case .savingsPlan:          return AppDestination.savingsPlan(.create)
        case .subscription:         return AppDestination.subscription(.create)
        case .recentTransactions:   return AppDestination.transaction(.create)
        }
    }
}

// MARK: - Preview
#Preview {
    HomeScreenEmptyRow(type: .recentTransactions)
}
