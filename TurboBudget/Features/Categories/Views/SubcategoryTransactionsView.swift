//
//  SubcategoryTransactionsView.swift
//  CashFlow
//
//  Created by KaayZenn on 16/08/2023.
//
// Localizations 01/10/2023

import SwiftUI
import NavigationKit
import TheoKit

struct SubcategoryTransactionsView: View {
    
    // Builder
    var subcategory: SubcategoryModel
    var selectedDate: Date
    
    // Repo
    @EnvironmentObject private var transactionStore: TransactionStore
        
    // State or Binding String
    @State private var searchText: String = ""
    
    // MARK: -
    var body: some View {
        let transactionsExpenses = transactionStore.getExpenses(for: subcategory, in: selectedDate)
        let transactionsFiltered = transactionsExpenses.search(for: searchText)
        
        VStack(spacing: 0) {
            NavigationBar(
                title: Word.Main.transactions,
                placeholder: "word_search".localized,
                searchText: $searchText,
            )
         
            if transactionsFiltered.isNotEmpty {
                List {
                    Section(
                        content: {
                            ForEach(transactionsFiltered) { transaction in
                                NavigationButton(
                                    route: .push,
                                    destination: AppDestination.transaction(.detail(transaction: transaction))
                                ) {
                                    TransactionRow(transaction: transaction)
                                }
                            }
                            .noDefaultStyle()
                            .padding(.bottom, DesignSystem.Padding.medium)
                        }, header: {
                            DetailOfExpensesAndIncomesByMonth(
                                month: selectedDate,
                                amountOfExpenses: transactionsExpenses.compactMap(\.amount).reduce(0, +),
                                amountOfIncomes: 0
                            )
                        }
                    )
                    .padding(.horizontal, TKDesignSystem.Padding.large)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .animation(.smooth, value: transactionsFiltered.count)
            } else {
                CustomEmptyView(
                    type: transactionsFiltered.isEmpty && !searchText.isEmpty ? .noResults(searchText) : .empty(.transactions(.list)),
                    isDisplayed: transactionsFiltered.isEmpty
                )
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationBarBackButtonHidden(true)
        .background(TKDesignSystem.Colors.Background.Theme.bg50)
    } // body
} // struct

// MARK: - Preview
#Preview {
    SubcategoryTransactionsView(subcategory: .mock, selectedDate: .now)
}
