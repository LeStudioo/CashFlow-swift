//
//  HomeScreenComponentHeader.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/11/2024.
//

import SwiftUI

struct HomeScreenComponentHeader: View {
    
    // Builder
    var type: HomeScreenComponentHeaderType
    
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        NavigationButton(push: type.route(router: router)) {
            HStack {
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
    
    func route(router: NavigationManager) {
        switch self {
        case .recentTransactions:   return router.pushAllTransactions()
        case .savingsPlan:          return router.pushHomeSavingPlans()
        case .subscription:         return router.pushHomeAutomations()
        }
    }
}

// MARK: - Preview
#Preview {
    HomeScreenComponentHeader(type: .recentTransactions)
}
