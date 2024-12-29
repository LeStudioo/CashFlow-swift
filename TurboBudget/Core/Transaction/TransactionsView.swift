//
//  TransactionsView.swift
//  CashFlow
//
//  Created by Théo Sementa on 03/07/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI

enum FilterForRecentTransaction: Int, CaseIterable {
    case month, expenses, incomes, category
}

struct TransactionsView: View {
    
    // Environement
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var accountRepository: AccountStore
    @EnvironmentObject private var transactionRepository: TransactionStore
        
    // String variables
    @State private var searchText: String = ""
    
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
            }
    } // body
} // struct

// MARK: - Preview
#Preview {
    TransactionsView()
}
