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
    var router: NavigationManager
    @ObservedObject var account: Account
    
    // Environement
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
        for transaction in account.transactions {
            let components = Calendar.current.dateComponents([.month, .year], from: transaction.date)
            if !array.contains(components) { array.append(components) }
        }
        return array
    }
    
    var searchResults: [Transaction] {
        if searchText.isEmpty {
            if filterTransactions == .expenses {
                if ascendingOrder {
                    return account.transactions.filter { $0.amount < 0 }.sorted { $0.amount < $1.amount }.reversed()
                } else {
                    return account.transactions.filter { $0.amount < 0 }.sorted { $0.amount < $1.amount }
                }
            } else if filterTransactions == .incomes {
                if ascendingOrder {
                    return account.transactions.filter { $0.amount > 0 }.sorted { $0.amount > $1.amount }.reversed()
                } else {
                    return account.transactions.filter { $0.amount > 0 }.sorted { $0.amount > $1.amount }
                }
            } else if filterTransactions == .category {
                return account.transactions.filter({ $0.date >= Date().startOfMonth && $0.date <= Date().endOfMonth })
            } else {
                return account.transactions
            }
        } else { //Searching
            let transactionsFilterByTitle = account.transactions.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            let transactionsFilterByDate = account.transactions.filter { HelperManager().formattedDateWithMonthYear(date: $0.date).localizedCaseInsensitiveContains(searchText) }
            
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
            if account.transactions.count != 0 && searchResults.count != 0 {
                if filterTransactions == .category {
                    List(PredefinedCategoryManager().getAllCategoriesForTransactions(), id: \.self) { category in
                        if searchResults.map({ PredefinedCategoryManager().categoryByUniqueID(idUnique: $0.predefCategoryID) }).contains(category) {
                            Section(content: {
                                ForEach(searchResults) { transaction in
                                    if let categoryOfTransaction = PredefinedCategoryManager().categoryByUniqueID(idUnique: transaction.predefCategoryID), categoryOfTransaction == category {
                                        Button(action: {
                                            router.pushTransactionDetail(transaction: transaction)
                                        }, label: {
                                            CellTransactionView(transaction: transaction)
                                        })
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                                .listRowBackground(Color.colorBackground.edgesIgnoringSafeArea(.all))
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
                    .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
                } else {
                    List(getAllMonthForTransactions, id: \.self) { dateComponents in
                        if let month = Calendar.current.date(from: dateComponents) {
                            if searchResults.map({ $0.date }).contains(where: { Calendar.current.isDate($0, equalTo: month, toGranularity: .month) }) {
                                Section(content: {
                                    ForEach(searchResults) { transaction in
                                        if Calendar.current.isDate(transaction.date, equalTo: month, toGranularity: .month) {
                                            Button(action: {
                                                router.pushTransactionDetail(transaction: transaction)
                                            }, label: {
                                                CellTransactionView(transaction: transaction)
                                            })
                                        }
                                    }
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                                    .listRowBackground(Color.colorBackground.edgesIgnoringSafeArea(.all))
                                }, header: {
                                    if filterTransactions == .month {
                                        DetailOfExpensesAndIncomesByMonth(
                                            month: month,
                                            amountOfExpenses: account.amountExpensesByMonth(month: month),
                                            amountOfIncomes: account.amountIncomesByMonth(month: month)
                                        )
                                        .listRowInsets(EdgeInsets(top: -12, leading: 0, bottom: 8, trailing: 0))
                                    } else if filterTransactions == .expenses || filterTransactions == .incomes {
                                        DetailOfExpensesOrIncomesByMonth(
                                            filterTransactions: $filterTransactions,
                                            month: month,
                                            amountOfExpenses: searchResults.filter({ $0.date >= month.startOfMonth && $0.date <= month.endOfMonth }).map({ $0.amount }).reduce(0, -),
                                            amountOfIncomes: searchResults.filter({ $0.date >= month.startOfMonth && $0.date <= month.endOfMonth }).map({ $0.amount }).reduce(0, +),
                                            ascendingOrder: $ascendingOrder
                                        )
                                        .listRowInsets(EdgeInsets(top: -12, leading: 0, bottom: 8, trailing: 0))
                                    }
                                })
                                .foregroundStyle(Color(uiColor: .label))
                            }
                        }
                    } // End List
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
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
        .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
        .navigationTitle("word_recent_transactions".localized)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(uiColor: .label))
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu(content: {
                    Button(action: {
                        router.presentCreateTransaction()
                    }, label: {
                        Label("word_add".localized, systemImage: "plus")
                    })
                    Menu(content: {
                        Button(action: { withAnimation { filterTransactions = .month } }, label: { Label("word_month".localized, systemImage: "calendar") })
                        
                        Button(action: { withAnimation { filterTransactions = .expenses } }, label: { Label("word_expenses".localized, systemImage: "arrow.down.forward") })
                        
                        Button(action: { withAnimation { filterTransactions = .incomes } }, label: { Label("word_incomes".localized, systemImage: "arrow.up.right") })
                        
                        Button(action: { withAnimation { filterTransactions = .category } }, label: { Label("word_categories".localized, systemImage: "rectangle.stack") })
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
        .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    RecentTransactionsView(
        router: .init(isPresented: .constant(.allTransactions(account: .preview))),
        account: Account.preview
    )
}
