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
    
    // Builder
    @ObservedObject var account: Account
    
    // Environement
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var transactionRepository: TransactionRepository
    
    // Custom
    @StateObject private var viewModel = RecentTransactionsViewModel()
        
    // String variables
    @State private var searchText: String = ""
        
    // Boolean variables
    @State private var ascendingOrder: Bool = false
        
    // Enum
    @State private var filterTransactions: FilterForRecentTransaction = .month
    
    // Computed var
    var getAllMonthForTransactions: [DateComponents] {
        var array: [DateComponents] = []
        for transaction in transactionRepository.transactions {
            let components = Calendar.current.dateComponents([.month, .year], from: transaction.date.withDefault)
            if !array.contains(components) { array.append(components) }
        }
        return array
    }
    
    var searchResults: [TransactionModel] {
        if searchText.isEmpty {
            if filterTransactions == .expenses {
                if ascendingOrder {
                    return transactionRepository.expenses.sorted { $0.amount ?? 0 < $1.amount ?? 0 }.reversed()
                } else {
                    return transactionRepository.expenses.sorted { $0.amount ?? 0 < $1.amount ?? 0 }
                }
            } else if filterTransactions == .incomes {
                if ascendingOrder {
                    return transactionRepository.incomes.sorted { $0.amount ?? 0 > $1.amount ?? 0 }.reversed()
                } else {
                    return transactionRepository.incomes.sorted { $0.amount ?? 0 > $1.amount ?? 0 }
                }
            } else if filterTransactions == .category {
                return transactionRepository.transactions
                    .filter({ $0.date.withDefault >= Date().startOfMonth && $0.date.withDefault <= Date().endOfMonth })
            } else {
                return transactionRepository.transactions
            }
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
        
    // MARK: - body
    var body: some View {
        VStack {
            if transactionRepository.transactions.count != 0 && searchResults.count != 0 {
                if filterTransactions == .category {
                    List(PredefinedCategory.categoriesWithTransactions, id: \.self) { category in
                        if searchResults.map({ PredefinedCategory.findByID($0.categoryID ?? "") }).contains(category) {
                            Section(content: {
                                ForEach(searchResults) { transaction in
                                    if let categoryOfTransaction = PredefinedCategory.findByID(transaction.categoryID ?? ""),
                                       categoryOfTransaction == category {
                                        NavigationButton(push: router.pushTransactionDetail(transaction: transaction)) {
                                            TransactionRow(transaction: transaction)
                                        }
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                                .listRowBackground(Color.background.edgesIgnoringSafeArea(.all))
                            }, header: {
                                DetailOfCategory(category: category)
                                    .listRowInsets(EdgeInsets(top: -12, leading: 0, bottom: 8, trailing: 0))
                            })
                            .foregroundStyle(Color(uiColor: .label))
                        }
                    } // End List
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    .background(Color.background.edgesIgnoringSafeArea(.all))
                    .animation(.smooth, value: transactionRepository.transactions.count)
                } else {
                    List(getAllMonthForTransactions, id: \.self) { dateComponents in
                        if let month = Calendar.current.date(from: dateComponents) {
                            if viewModel.searchResults(account: account).map({ $0.date.withDefault }).contains(where: { Calendar.current.isDate($0, equalTo: month, toGranularity: .month) }) {
                                Section(content: {
                                    ForEach(viewModel.searchResults(account: account)) { transaction in
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
                                            amountOfExpenses: account.amountExpensesByMonth(month: month),
                                            amountOfIncomes: account.amountIncomesByMonth(month: month)
                                        )
                                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                                    } else if filterTransactions == .expenses || filterTransactions == .incomes {
                                        DetailOfExpensesOrIncomesByMonth(
                                            filterTransactions: $filterTransactions,
                                            month: month,
                                            amountOfExpenses: searchResults
                                                .filter({ $0.date.withDefault >= month.startOfMonth && $0.date.withDefault <= month.endOfMonth })
                                                .map({ $0.amount ?? 0 }).reduce(0, +),
                                            amountOfIncomes: searchResults
                                                .filter({ $0.date.withDefault >= month.startOfMonth && $0.date.withDefault <= month.endOfMonth })
                                                .map({ $0.amount ?? 0 }).reduce(0, +),
                                            ascendingOrder: $ascendingOrder
                                        )
                                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                                    }
                                })
                            }
                        }
                    } // End List
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    .background(Color.background.edgesIgnoringSafeArea(.all))
                    .animation(.smooth, value: transactionRepository.transactions.count)
                }
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
    RecentTransactionsView(account: Account.preview)
}
