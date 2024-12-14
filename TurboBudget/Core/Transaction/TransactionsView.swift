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
    @EnvironmentObject private var accountRepository: AccountRepository
    @EnvironmentObject private var transactionRepository: TransactionRepository
        
    // String variables
    @State private var searchText: String = ""
        
    // Computed var
    var searchResults: [TransactionModel] {
        if searchText.isEmpty {
            return transactionRepository.transactions
        } else { //Searching
            let transactionsFilterByTitle = transactionRepository.transactions
                .filter { $0.name.localizedStandardContains(searchText) }
            
            let transactionsFilterByDate = transactionRepository.transactions
                .filter { $0.date.formatted(.monthAndYear).localizedStandardContains(searchText) }
            
            if transactionsFilterByTitle.isEmpty {
                return transactionsFilterByDate
            } else {
                return transactionsFilterByTitle
            }
        }
    }
    
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
                
                //            ToolbarItem(placement: .navigationBarTrailing) {
                //                NavigationButton(push: router.pushFilter()) {
                //                    Image(systemName: "line.3.horizontal.decrease.circle")
                //                        .foregroundStyle(Color(uiColor: .label))
                //                        .font(.system(size: 18, weight: .medium, design: .rounded))
                //                }
                //            }
            }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    TransactionsView()
}
