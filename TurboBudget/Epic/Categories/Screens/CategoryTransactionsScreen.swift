//
//  CategoryTransactionsScreen.swift
//  CashFlow
//
//  Created by KaayZenn on 18/08/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI
import NavigationKit
import TheoKit
import DesignSystemModule
import CoreModule

struct CategoryTransactionsScreen: View {
    
    // MARK: Dependencies
    var category: CategoryModel
    var selectedDate: Date
    
    // MARK: Environments
    @EnvironmentObject private var transactionStore: TransactionStore
    
    // MARK: States
    @State private var searchText: String = ""
    @State private var amountExpense: Double = 0
    @State private var amountIncome: Double = 0
    
    // MARK: - View
    var body: some View {
        let transactions = transactionStore.getTransactions(for: category, in: selectedDate)
        let transactionsFiltered = transactions.search(searchText)
        
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
                                    TransactionRowView(transaction: transaction)
                                }
                            }
                            .noDefaultStyle()
                            .padding(.bottom, Padding.medium)
                        },
                        header: {
                            DetailOfExpensesAndIncomesByMonth(
                                month: selectedDate,
                                amountOfExpenses: amountExpense,
                                amountOfIncomes: amountIncome
                            )
                        }
                    )
                    .padding(.horizontal, Padding.large)
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
        .navigationTitle(Word.Main.transactions)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .background(TKDesignSystem.Colors.Background.Theme.bg50)
        .toolbar {
            ToolbarDismissPushButton()
        }
        .searchable(text: $searchText, prompt: "word_search".localized)
        .onAppear {
            if category.isIncome {
                amountIncome = transactions
                    .compactMap(\.amount)
                    .reduce(0, +)
            } else {
                amountExpense = transactions
                    .compactMap(\.amount)
                    .reduce(0, +)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    CategoryTransactionsScreen(category: .mock, selectedDate: .now)
}
