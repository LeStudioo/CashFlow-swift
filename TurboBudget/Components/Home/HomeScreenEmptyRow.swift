//
//  HomeScreenEmptyRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/11/2024.
//

import SwiftUI

struct HomeScreenEmptyRow: View {
    
    // Builder
    var type: HomeScreenEmptyRowType
    
    @EnvironmentObject private var router: NavigationManager
    
    // MARK: -
    var body: some View {
        NavigationButton(present: type.route(router: router)) {
            HStack {
                Text(type.title)
                    .font(Font.mediumText16())
                    .foregroundStyle(Color.label)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(type.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 4, y: 4)
            }
            .padding()
            .frame(height: 160)
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.colorCell)
            }
        }
    } // body
} // struct

// MARK: -
enum HomeScreenEmptyRowType {
    case savingsPlan
    case subscription
    case recentTransactions
    
    // TODO: Localized + ISO
    var title: String {
        switch self {
        case .savingsPlan:          return "savingsplans_for_home_no_savings_plan".localized
        case .subscription:         return "automations_for_home_no_auto".localized
        case .recentTransactions:   return "home_screen_no_transaction".localized
        }
    }
    
    var image: String {
        switch self {
        case .savingsPlan:          return "NoSavingPlan\(ThemeManager.theme.nameNotLocalized.capitalized)"
        case .subscription:         return "NoAutomation\(ThemeManager.theme.nameNotLocalized.capitalized)"
        case .recentTransactions:   return "NoTransaction\(ThemeManager.theme.nameNotLocalized.capitalized)"
        }
    }
    
    func route(router: NavigationManager) -> () {
        switch self {
        case .savingsPlan:          return router.presentCreateSavingsPlan()
        case .subscription:         return router.presentCreateAutomation()
        case .recentTransactions:   return router.presentCreateTransaction()
        }
    }
}

// MARK: - Preview
#Preview {
    HomeScreenEmptyRow(type: .recentTransactions)
}
