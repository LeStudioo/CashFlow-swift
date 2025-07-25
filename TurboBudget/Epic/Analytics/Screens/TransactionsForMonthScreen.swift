//
//  TransactionsForMonthScreen.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/12/2024.
//

import SwiftUI
import NavigationKit
import CoreModule

struct TransactionsForMonthScreen: View {
    
    // Builder
    var selectedDate: Date
    var type: TransactionType
    
    // Environment
    @EnvironmentObject private var transactionStore: TransactionStore
    
    // String variables
    @State private var searchText: String = ""
    
    // MARK: -
    var body: some View {
        let transactions = transactionStore.getTransactions(in: selectedDate).filter { $0.type == type }
        let transactionsFiltered = transactions.search(searchText)
        
        VStack {
            if transactionsFiltered.isNotEmpty {
                List {
                    Section(content: {
                        ForEach(transactionsFiltered) { transaction in
                            NavigationButton(
                                route: .push,
                                destination: AppDestination.transaction(.detail(transaction: transaction))) {
                                    TransactionRowView(transaction: transaction)
                                }
                        }
                        .padding(.horizontal)
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                        .listRowBackground(Color.Background.bg50.edgesIgnoringSafeArea(.all))
                    }, header: {
                        DetailOfExpensesAndIncomesByMonth(
                            month: selectedDate,
                            amountOfExpenses: transactionStore.getExpenses(transactions: transactions)
                                .compactMap(\.amount)
                                .reduce(0, +),
                            amountOfIncomes: transactionStore.getIncomes(transactions: transactions)
                                .compactMap(\.amount)
                                .reduce(0, +)
                        )
                        .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                    })
                    .foregroundStyle(Color.text)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .background(Color.Background.bg50.edgesIgnoringSafeArea(.all))
                .animation(.smooth, value: transactionsFiltered.count)
            } else {
                CustomEmptyView(
                    type: transactionsFiltered.isEmpty && !searchText.isEmpty ? .noResults(searchText) : .empty(.transactions(.list)),
                    isDisplayed: transactionsFiltered.isEmpty
                )
            }
        }
        .background(Color.Background.bg50.edgesIgnoringSafeArea(.all))
        .navigationTitle(Word.Main.transactions)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarDismissPushButton()
        }
        .searchable(text: $searchText, prompt: "word_search".localized)
        .background(Color.Background.bg50.edgesIgnoringSafeArea(.all))
    } // body
} // struct

// MARK: - Preview
#Preview {
    TransactionsForMonthScreen(selectedDate: .now, type: .expense)
}
