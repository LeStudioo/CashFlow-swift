//
//  RecentTransactionsView.swift
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

struct RecentTransactionsView: View {
    
    // Environement
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var accountRepository: AccountRepository
    @EnvironmentObject private var transactionRepository: TransactionRepository
    
    // Custom
    @StateObject private var viewModel = RecentTransactionsViewModel()
    
    // String variables
    @State private var searchText: String = ""
        
    // Computed var
    var searchResults: [TransactionModel] {
        if searchText.isEmpty {
            return transactionRepository.transactions
        } else { //Searching
            let transactionsFilterByTitle = transactionRepository.transactions
                .filter { $0.name?.localizedStandardContains(searchText) ?? false }
            
            let transactionsFilterByDate = transactionRepository.transactions
                .filter { HelperManager().formattedDateWithMonthYear(date: $0.date.withDefault).localizedStandardContains(searchText) }
            
            if transactionsFilterByTitle.isEmpty {
                return transactionsFilterByDate
            } else {
                return transactionsFilterByTitle
            }
        }
    }
    
    // MARK: -
    var body: some View {
        VStack {
            if transactionRepository.transactions.count != 0 && searchResults.count != 0 {
                TransactionsListView()
            } else { // No Transactions
                ErrorView(
                    searchResultsCount: searchResults.count,
                    searchText: searchText,
                    image: "NoTransaction",
                    text: "error_message_transaction".localized
                )
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .navigationTitle("word_recent_transactions".localized)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarDismissPushButton()
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationButton(push: router.pushFilter()) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundStyle(Color(uiColor: .label))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                }
            }
        }
        .searchable(text: $searchText.animation(), prompt: "word_search".localized)
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    RecentTransactionsView()
}
