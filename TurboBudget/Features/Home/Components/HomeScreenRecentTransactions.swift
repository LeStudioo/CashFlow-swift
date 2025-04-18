//
//  HomeScreenRecentTransactions.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/11/2024.
//

import SwiftUI
import NavigationKit

struct HomeScreenRecentTransactions: View {
    
    // EnvironmentObject
    @EnvironmentObject private var transactionStore: TransactionStore
    
    // Preferences
    @StateObject var preferencesDisplayHome: PreferencesDisplayHome = .shared
    
    // MARK: -
    var body: some View {
        if preferencesDisplayHome.transaction_isDisplayed {
            VStack {
                HomeScreenComponentHeader(type: .recentTransactions)
                
                if transactionStore.transactions.isNotEmpty {
                    ForEach(transactionStore.transactions.prefix(preferencesDisplayHome.transaction_value)) { transaction in
                        NavigationButton(route: .push, destination: AppDestination.transaction(.detail(transaction: transaction))) {
                            TransactionRow(transaction: transaction)
                        }
                    }
                } else {
                    HomeScreenEmptyRow(type: .recentTransactions)
                }
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    HomeScreenRecentTransactions()
}
