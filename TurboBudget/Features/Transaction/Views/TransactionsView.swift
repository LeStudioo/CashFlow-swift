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

struct TransactionsView: View {
    
    // Environement
    @EnvironmentObject private var transactionStore: TransactionStore
            
    // MARK: -
    var body: some View {
        TransactionsListView()
            .overlay {
                CustomEmptyView(
                    type: .empty(.transactions),
                    isDisplayed: transactionStore.transactions.isEmpty
                )
            }
            .navigationTitle(Word.Main.transactions)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarDismissPushButton()
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationButton(route: .sheet, destination: AppDestination.transaction(.create)) {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.text)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                    }
                }
            }
    } // body
} // struct

// MARK: - Preview
#Preview {
    TransactionsView()
}
