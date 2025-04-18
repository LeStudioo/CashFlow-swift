//
//  CategoryTransactionsView.swift
//  CashFlow
//
//  Created by KaayZenn on 18/08/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI
import NavigationKit

struct CategoryTransactionsView: View {
    
    // Builder
    var category: CategoryModel
    var selectedDate: Date
    
    // Environment
    @EnvironmentObject private var transactionStore: TransactionStore
    
    // String variables
    @State private var searchText: String = ""
    
    @State private var amountExpense: Double = 0
    @State private var amountIncome: Double = 0
    
    // MARK: -
    var body: some View {
        let transactions = transactionStore.getTransactions(for: category, in: selectedDate)
        let transactionsFiltered = transactions.search(for: searchText)
        
        VStack {
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
                            .padding(.horizontal)
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                            .listRowBackground(Color.background.edgesIgnoringSafeArea(.all))
                        },
                        header: {
                        DetailOfExpensesAndIncomesByMonth(
                            month: selectedDate,
                            amountOfExpenses: amountExpense,
                            amountOfIncomes: amountIncome
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
        .onAppear {
            if category.isRevenue {
                amountIncome = transactions
                    .compactMap(\.amount)
                    .reduce(0, +)
            } else {
                amountExpense = transactions
                    .compactMap(\.amount)
                    .reduce(0, +)
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CategoryTransactionsView(category: .mock, selectedDate: .now)
}
