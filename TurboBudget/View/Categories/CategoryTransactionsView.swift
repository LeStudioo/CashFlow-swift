//
//  CategoryTransactionsView.swift
//  CashFlow
//
//  Created by KaayZenn on 18/08/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI

struct CategoryTransactionsView: View {
    
    // Builder
    var category: PredefinedCategory
    
    // Environment
    @EnvironmentObject private var router: NavigationManager
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    // String variables
    @State private var searchText: String = ""
        
    // Boolean variables
    @State private var ascendingOrder: Bool = false
        
    // Enum
    @State private var filterTransactions: FilterForRecentTransaction = .month
    
    // Computed var
    var getAllMonthForTransactions: [DateComponents] {
        var array: [DateComponents] = []
        for transaction in category.transactions {
            let components = Calendar.current.dateComponents([.month, .year], from: transaction.date.withDefault)
            if !array.contains(components) { array.append(components) }
        }
        return array
    }
    
    var searchResults: [TransactionModel] {
        if searchText.isEmpty {
            if filterTransactions == .expenses {
                if ascendingOrder {
                    return category.expenses.sorted { $0.amount ?? 0 < $1.amount ?? 0 }.reversed()
                } else {
                    return category.expenses.sorted { $0.amount ?? 0 < $1.amount ?? 0 }
                }
            } else if filterTransactions == .incomes {
                if ascendingOrder {
                    return category.incomes.sorted { $0.amount ?? 0 > $1.amount ?? 0 }.reversed()
                } else {
                    return category.incomes.sorted { $0.amount ?? 0 > $1.amount ?? 0 }
                }
            } else {
                return category.transactions
            }
        } else {
            return category.transactions.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }
    
    // MARK: - body
    var body: some View {
        VStack {
            if category.transactions.count != 0 && searchResults.count != 0 {
                List(getAllMonthForTransactions, id: \.self) { dateComponents in
                    if let month = Calendar.current.date(from: dateComponents) {
                        if searchResults.map({ $0.date.withDefault }).contains(where: { Calendar.current.isDate($0, equalTo: month, toGranularity: .month) }) {
                            Section(content: {
                                ForEach(searchResults) { transaction in
                                    if Calendar.current.isDate(transaction.date.withDefault, equalTo: month, toGranularity: .month) {
                                        NavigationButton(push: router.pushTransactionDetail(transaction: transaction)) {
                                            TransactionRow(transaction: transaction)
                                        }
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                                .listRowBackground(Color.background.edgesIgnoringSafeArea(.all))
                            }, header: {
                                if filterTransactions == .month {
                                    DetailOfExpensesAndIncomesByMonth(
                                        month: month,
                                        amountOfExpenses: category.amountExpensesByMonth(month: month),
                                        amountOfIncomes: category.amountIncomesByMonth(month: month)
                                    )
                                    .listRowInsets(EdgeInsets(top: -12, leading: 0, bottom: 8, trailing: 0))
                                } else if filterTransactions == .expenses || filterTransactions == .incomes {
                                    DetailOfExpensesOrIncomesByMonth(
                                        filterTransactions: $filterTransactions,
                                        month: month,
                                        amountOfExpenses: searchResults.filter({ $0.date.withDefault >= month.startOfMonth && $0.date.withDefault <= month.endOfMonth }).map({ $0.amount ?? 0 }).reduce(0, +),
                                        amountOfIncomes: searchResults.filter({ $0.date.withDefault >= month.startOfMonth && $0.date.withDefault <= month.endOfMonth }).map({ $0.amount ?? 0 }).reduce(0, +),
                                        ascendingOrder: $ascendingOrder
                                    )
                                    .listRowInsets(EdgeInsets(top: -12, leading: 0, bottom: 8, trailing: 0))
                                }
                            })
                            .foregroundStyle(Color(uiColor: .label))
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .background(Color.background.edgesIgnoringSafeArea(.all))
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
        .navigationTitle("word_recent_transactions")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarDismissPushButton()
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu(content: {
                    Menu(content: {
                        Button(action: { withAnimation { filterTransactions = .month } }, label: { Label("word_month", systemImage: "calendar") })
                        if category.id != PredefinedCategory.PREDEFCAT0.id {
                            Button(action: { withAnimation { filterTransactions = .expenses } }, label: { Label("word_expenses", systemImage: "arrow.down.forward") })
                        } else {
                            Button(action: { withAnimation { filterTransactions = .incomes } }, label: { Label("word_incomes", systemImage: "arrow.up.right") })
                        }
                    }, label: {
                        Label("word_filter", systemImage: "slider.horizontal.3")
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
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CategoryTransactionsView(category: .PREDEFCAT1)
}
