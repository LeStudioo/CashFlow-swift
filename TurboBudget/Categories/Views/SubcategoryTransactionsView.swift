//
//  SubcategoryTransactionsView.swift
//  CashFlow
//
//  Created by KaayZenn on 16/08/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct SubcategoryTransactionsView: View {
    
    // Builder
    var subcategory: SubcategoryModel
    
    // Repo
    @EnvironmentObject private var transactionStore: TransactionStore
    
    // Environnements
    @EnvironmentObject private var router: NavigationManager
    @Environment(\.dismiss) private var dismiss
    
    // State or Binding String
    @State private var searchText: String = ""
    
    // State or Binding Bool
    @State private var ascendingOrder: Bool = false
    
    // Enum
    @State private var filterTransactions: FilterForRecentTransaction = .month
    
    // Computed var
    var searchResults: [TransactionModel] {
        if searchText.isEmpty {
            if filterTransactions == .expenses {
                if ascendingOrder {
                    return subcategory.expenses.sorted { $0.amount ?? 0 < $1.amount ?? 0 }.reversed()
                } else {
                    return subcategory.expenses.sorted { $0.amount ?? 0 < $1.amount ?? 0 }
                }
            } else if filterTransactions == .incomes {
                if ascendingOrder {
                    return subcategory.incomes.sorted { $0.amount ?? 0 > $1.amount ?? 0 }.reversed()
                } else {
                    return subcategory.incomes.sorted { $0.amount ?? 0 > $1.amount ?? 0 }
                }
            } else {
                return subcategory.transactions
            }
        } else {
            return subcategory.transactions.filter { $0.name.localizedStandardContains(searchText) }
        }
    }
    
    // MARK: -
    var body: some View {
        VStack {
            if subcategory.transactions.isNotEmpty && searchResults.isNotEmpty {
                List {
                    Section(content: {
                        ForEach(transactionStore.getExpenses(for: subcategory, in: .now)) { transaction in
                            NavigationButton(push: router.pushTransactionDetail(transaction: transaction)) {
                                TransactionRow(transaction: transaction)
                                    .padding(.horizontal)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                        .listRowBackground(Color.background.edgesIgnoringSafeArea(.all))
                    }, header: {
                        //                                if filterTransactions == .month {
                        DetailOfExpensesAndIncomesByMonth(
                            month: .now,
                            amountOfExpenses: transactionStore.getExpenses(for: subcategory, in: .now).compactMap(\.amount).reduce(0, +),
                            amountOfIncomes: transactionStore.getIncomes(for: subcategory, in: .now).compactMap(\.amount).reduce(0, +)
                        )
                        .listRowInsets(EdgeInsets(top: -12, leading: 0, bottom: 8, trailing: 0))
                        //                                } else if filterTransactions == .expenses || filterTransactions == .incomes {
                        //                                    DetailOfExpensesOrIncomesByMonth(
                        //                                        filterTransactions: $filterTransactions,
                        //                                        month: month,
                        //                                        amountOfExpenses: searchResults.filter({ $0.date.withDefault >= month.startOfMonth && $0.date.withDefault <= month.endOfMonth }).map({ $0.amount ?? 0 }).reduce(0, +),
                        //                                        amountOfIncomes: searchResults.filter({ $0.date.withDefault >= month.startOfMonth && $0.date.withDefault <= month.endOfMonth }).map({ $0.amount ?? 0 }).reduce(0, +),
                        //                                        ascendingOrder: $ascendingOrder
                        //                                    )
                        //                                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        //                                }
                    })
                    .foregroundStyle(Color(uiColor: .label))
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .background(Color.background.edgesIgnoringSafeArea(.all))
                .animation(.smooth, value: transactionStore.transactions.count)
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
        .navigationTitle("word_transactions".localized)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarDismissPushButton()
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu(content: {
                    Menu(content: {
                        Button(
                            action: { withAnimation { filterTransactions = .month } },
                            label: { Label("word_month".localized, systemImage: "calendar") }
                        )
                        Button(
                            action: { withAnimation { filterTransactions = .expenses } },
                            label: { Label("word_expenses".localized, systemImage: "arrow.down.forward") }
                        )
                    }, label: {
                        Label("word_filter".localized, systemImage: "slider.horizontal.3")
                    })
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color(uiColor: .label))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
            }
        }
        .searchable(text: $searchText.animation(), prompt: "word_search".localized)
        .background(Color.background.edgesIgnoringSafeArea(.all))
        //        .sheet(isPresented: $showAddTransaction) { AddTransactionView(account: $account) }
    } // body
} // struct

// MARK: - Preview
#Preview {
    SubcategoryTransactionsView(subcategory: .mock)
}
