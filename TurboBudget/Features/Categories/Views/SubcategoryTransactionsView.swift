//
//  SubcategoryTransactionsView.swift
//  CashFlow
//
//  Created by KaayZenn on 16/08/2023.
//
// Localizations 01/10/2023

import SwiftUI
import NavigationKit

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
        
        VStack {
            if transactionsFiltered.isNotEmpty {
                List {
                    Section(content: {
                        ForEach(transactionsFiltered) { transaction in
                            NavigationButton(
                                route: .push,
                                destination: AppDestination.transaction(.detail(transaction: transaction))
                            ) {
                                TransactionRow(transaction: transaction)
                            }
                        }
                        .padding(.horizontal)
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                        .listRowBackground(Color.background.edgesIgnoringSafeArea(.all))
                    }, header: {
                        DetailOfExpensesAndIncomesByMonth(
                            month: selectedDate,
                            amountOfExpenses: transactionsExpenses.compactMap(\.amount).reduce(0, +),
                            amountOfIncomes: 0
                        )
                        .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                    })
                    .foregroundStyle(Color.text)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .background(Color.background.edgesIgnoringSafeArea(.all))
                .animation(.smooth, value: transactionsFiltered.count)
            } else {
                CustomEmptyView(
                    type: transactionsFiltered.isEmpty && !searchText.isEmpty ? .noResults(searchText) : .empty(.transactions),
                    isDisplayed: transactionsFiltered.isEmpty
                )
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .navigationTitle(Word.Main.transactions)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarDismissPushButton()
        }
        .searchable(text: $searchText, prompt: "word_search".localized)
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // body
} // struct

// MARK: - Preview
#Preview {
    SubcategoryTransactionsView(subcategory: .mock, selectedDate: .now)
}
