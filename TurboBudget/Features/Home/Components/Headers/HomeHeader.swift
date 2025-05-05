//
//  HomeHeader.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import SwiftUI
import NavigationKit
import TheoKit

struct HomeHeader: View {
    
    @EnvironmentObject private var accountStore: AccountStore
    @EnvironmentObject private var transactionStore: TransactionStore
    @EnvironmentObject private var purchaseManager: PurchasesManager
    
    // MARK: -
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading) {
                if let account = accountStore.selectedAccount {
                    Text(account.balance.toCurrency())
                        .font(DesignSystem.Fonts.Title.large)
                        .contentTransition(.numericText())
                        .animation(.smooth, value: account.balance)
                }
                
                Text("home_screen_available_balance".localized)
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                    .font(DesignSystem.Fonts.Body.small)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if !purchaseManager.isCashFlowPro {
                PremiumButton()
            }
            
            NavigationButton(route: .push, destination: AppDestination.settings(.home)) {
                Image(.iconGear)
                    .renderingMode(.template)
                    .foregroundStyle(Color.text)
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    HomeHeader()
}
