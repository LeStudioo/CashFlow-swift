//
//  SavingsAccountHomeView.swift
//  CashFlow
//
//  Created by KaayZenn on 23/11/2023.
//

import SwiftUI
import AlertKit
import NavigationKit
import TheoKit

struct SavingsAccountHomeView: View {
    
    // Environment
    @EnvironmentObject private var router: Router<AppDestination>
    @EnvironmentObject private var alertManager: AlertManager
    @EnvironmentObject private var purchaseManager: PurchasesManager
    @EnvironmentObject private var accountStore: AccountStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText: String = ""
    
    // Computed variables
    var totalSavings: Double {
        return accountStore.savingsAccounts
            .map { $0.balance }
            .reduce(0, +)
    }
    
    var columns: [GridItem] {
        if UIDevice.isIpad {
            return [GridItem(spacing: 16), GridItem(spacing: 16), GridItem(spacing: 16), GridItem(spacing: 16)]
        } else {
            return [GridItem(spacing: 16), GridItem(spacing: 16)]
        }
    }
    
    var savingsAccountsFiltered: [AccountModel] {
        if searchText.isEmpty {
            return accountStore.savingsAccounts
        } else {
            return accountStore.savingsAccounts.filter { $0.name.localizedStandardContains(searchText) }
        }
    }
    
    // MARK: -
    var body: some View {
        BetterScrollView(maxBlurRadius: DesignSystem.Blur.topbar) {
            NavigationBar(
                title: Word.Main.savingsAccounts,
                actionButton: .init(
                    title: "word_create".localized,
                    action: {
                        if purchaseManager.isCashFlowPro || accountStore.savingsAccounts.isEmpty {
                            router.push(.savingsPlan(.create))
                        } else {
                            alertManager.showPaywall(router: router)
                        }
                    },
                    isDisabled: false
                ),
                placeholder: "word_search".localized,
                searchText: $searchText.animation()
            )
        } content: { _ in
            if !accountStore.savingsAccounts.isEmpty {
                VStack(spacing: 32) {
                    VStack(spacing: 0) {
                        Text(totalSavings.toCurrency())
                            .fontWithLineHeight(DesignSystem.Fonts.Display.extraLarge)
                            .foregroundStyle(Color.label)
                        
                        Text(Word.SavingsAccount.totalSavings)
                            .fontWithLineHeight(DesignSystem.Fonts.Body.medium)
                            .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                    }
                    
                    LazyVGrid(columns: columns, spacing: 16, content: {
                        ForEach(savingsAccountsFiltered) { account in
                            NavigationButton(
                                route: .push,
                                destination: AppDestination.savingsAccount(.detail(savingsAccount: account))
                            ) {
                                SavingsAccountRow(savingsAccount: account)
                            }
                        }
                    })
                    .padding(.horizontal, TKDesignSystem.Padding.large)
                }
            } else {
                CustomEmptyView(
                    type: .empty(.savingsAccount),
                    isDisplayed: true
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(TKDesignSystem.Colors.Background.Theme.bg50)
    } // body
} // struct

// MARK: - Preview
#Preview {
    SavingsAccountHomeView()
}
