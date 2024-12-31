//
//  TransactionsView.swift
//  CashFlow
//
//  Created by Théo Sementa on 03/07/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI

struct TransactionsView: View {
    
    // Environement
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var transactionRepository: TransactionStore
            
    // MARK: -
    var body: some View {
        TransactionsListView()
            .overlay {
                CustomEmptyView(
                    type: .empty(.transactions),
                    isDisplayed: transactionRepository.transactions.isEmpty
                )
            }
            .navigationTitle(Word.Main.transactions)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarDismissPushButton()
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationButton(present: router.presentCreateTransaction()) {
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
