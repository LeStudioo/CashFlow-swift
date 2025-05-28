//
//  TransactionsView.swift
//  CashFlow
//
//  Created by Théo Sementa on 03/07/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI
import NavigationKit
import TheoKit

struct TransactionsScreen: View {
    
    // Environement
    @EnvironmentObject private var transactionStore: TransactionStore
    @EnvironmentObject private var router: Router<AppDestination>
            
    // MARK: -
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(
                title: Word.Main.transactions,
                actionButton: .init(
                    title: Word.Classic.create,
                    action: { router.push(.transaction(.create)) },
                    isDisabled: false
                )
            )
            TransactionsListScreen()
                .overlay {
                    CustomEmptyView(
                        type: .empty(.transactions(.list)),
                        isDisplayed: transactionStore.transactions.isEmpty
                    )
                }
        }
        .navigationBarBackButtonHidden(true)
        .background(TKDesignSystem.Colors.Background.Theme.bg50.ignoresSafeArea(.all))
    } // body
} // struct

// MARK: - Preview
#Preview {
    TransactionsScreen()
}
