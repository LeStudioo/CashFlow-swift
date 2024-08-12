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
    var router: NavigationManager
    var subcategory: PredefinedSubcategory
    
    // Repo
    @EnvironmentObject private var transactionRepo: TransactionRepository
    
    //Environnements
    @Environment(\.dismiss) private var dismiss
    
    //State or Binding String
    @State private var searchText: String = ""
        
    //State or Binding Bool
    @State private var ascendingOrder: Bool = false
    
    //Enum
    @State private var filterTransactions: FilterForRecentTransaction = .month
    
    //Computed var
    var getAllMonthForTransactions: [DateComponents] {
        var array: [DateComponents] = []
        for transaction in subcategory.transactions {
            if !transaction.isFault {
                let components = Calendar.current.dateComponents([.month, .year], from: transaction.date)
                if !array.contains(components) {
                    array.append(components)
                }
            }
        }
        
        return array
    }
    
    var searchResults: [Transaction] {
        if searchText.isEmpty {
            if filterTransactions == .expenses {
                if ascendingOrder {
                    return subcategory.transactions.filter { $0.amount < 0 }.sorted { $0.amount < $1.amount }.reversed()
                } else {
                    return subcategory.transactions.filter { $0.amount < 0 }.sorted { $0.amount < $1.amount }
                }
            } else if filterTransactions == .incomes {
                if ascendingOrder {
                    return subcategory.transactions.filter { $0.amount > 0 }.sorted { $0.amount > $1.amount }.reversed()
                } else {
                    return subcategory.transactions.filter { $0.amount > 0 }.sorted { $0.amount > $1.amount }
                }
            } else {
                return subcategory.transactions
            }
        } else {
            return subcategory.transactions.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    //MARK: - Body
    var body: some View {
        VStack {
            if subcategory.transactions.count != 0 && searchResults.count != 0 {
                List(getAllMonthForTransactions, id: \.self) { dateComponents in
                    if let month = Calendar.current.date(from: dateComponents) {
                        if searchResults.map({ $0.date }).contains(where: { Calendar.current.isDate($0, equalTo: month, toGranularity: .month) }) {
                            Section(content: {
                                ForEach(searchResults) { transaction in
                                    if !transaction.isFault {
                                        if Calendar.current.isDate(transaction.date, equalTo: month, toGranularity: .month) {
                                            Button(action: {
                                                router.pushTransactionDetail(transaction: transaction)
                                            }, label: {
                                                TransactionRow(transaction: transaction)
                                            })
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
                                        amountOfExpenses: subcategory.amountExpensesByMonth(month: month),
                                        amountOfIncomes: subcategory.amountIncomesByMonth(month: month)
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
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .background(Color.background.edgesIgnoringSafeArea(.all))
                .animation(.smooth, value: transactionRepo.transactions.count)
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
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(uiColor: .label))
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu(content: {
                    Menu(content: {
                        Button(action: { withAnimation { filterTransactions = .month } }, label: { Label("word_month".localized, systemImage: "calendar") })
                        Button(action: { withAnimation { filterTransactions = .expenses } }, label: { Label("word_expenses".localized, systemImage: "arrow.down.forward") })
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
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    SubcategoryTransactionsView(
        router: .init(isPresented: .constant(.subcategoryTransactions(subcategory: .PREDEFSUBCAT1CAT1))),
        subcategory: .PREDEFSUBCAT1CAT1
    )
}
