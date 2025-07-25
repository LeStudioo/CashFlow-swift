//
//  HomeScreenRecentTransactionsView.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/11/2024.
//

import SwiftUI
import NavigationKit
import TheoKit
import DesignSystemModule
import PreferencesModule

struct HomeScreenRecentTransactionsView: View {
    
    // EnvironmentObject
    @EnvironmentObject private var transactionStore: TransactionStore
    
    // Preferences
    @StateObject var preferencesDisplayHome: PreferencesDisplayHome = .shared
    
    // MARK: -
    var body: some View {
        if preferencesDisplayHome.transaction_isDisplayed {
            VStack(spacing: Spacing.standard) {
                HomeScreenComponentHeaderView(type: .recentTransactions)
                
                if transactionStore.transactions.isNotEmpty {
                    VStack(spacing: Spacing.medium) {
                        let transactions = transactionStore.transactions.prefix(preferencesDisplayHome.transaction_value)
                        ForEach(transactions) { transaction in
                            NavigationButton(route: .push, destination: AppDestination.transaction(.detail(transaction: transaction))) {
                                TransactionRowView(transaction: transaction)
                            }
                        }
                    }
                } else {
                    CustomEmptyView(
                        type: .empty(.transactions(.home)),
                        isDisplayed: true
                    )
                }
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    HomeScreenRecentTransactionsView()
}
