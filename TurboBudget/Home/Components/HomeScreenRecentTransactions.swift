//
//  HomeScreenRecentTransactions.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/11/2024.
//

import SwiftUI

struct HomeScreenRecentTransactions: View {
    
    // EnvironmentObject
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var transactionRepository: TransactionStore
    
    // Preferences
    @StateObject var preferencesDisplayHome: PreferencesDisplayHome = .shared
    
    // MARK: -
    var body: some View {
        if preferencesDisplayHome.transaction_isDisplayed {
            VStack {
                HomeScreenComponentHeader(type: .recentTransactions)
                
                if transactionRepository.transactions.count != 0 {
                    ForEach(transactionRepository.transactions.prefix(preferencesDisplayHome.transaction_value)) { transaction in
                        NavigationButton(push: router.pushTransactionDetail(transaction: transaction)) {
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
