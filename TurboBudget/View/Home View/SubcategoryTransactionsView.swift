//
//  SubcategoryTransactionsView.swift
//  CashFlow
//
//  Created by KaayZenn on 16/08/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct SubcategoryTransactionsView: View {
    
    //Custom type
    var subcategory: PredefinedSubcategory
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    
    //Environnements
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    //State or Binding String
    @State private var searchText: String = ""
    
    //State or Binding Int, Float and Double
    
    //State or Binding Bool
    @State private var ascendingOrder: Bool = false
    
    //Enum
    @State private var filterTransactions: FilterForRecentTransaction = .month
    
    //Computed var
    var getAllMonthForTransactions: [DateComponents] {
        var array: [DateComponents] = []
        for transaction in subcategory.transactions {
            let components = Calendar.current.dateComponents([.month, .year], from: transaction.date)
            if !array.contains(components) {
                array.append(components)
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
    
    //Binding update
    @Binding var update: Bool
    
    //MARK: - Body
    var body: some View {
        VStack {
            if subcategory.transactions.count != 0 && searchResults.count != 0 {
                List(getAllMonthForTransactions, id: \.self) { dateComponents in
                    if let month = Calendar.current.date(from: dateComponents) {
                        if searchResults.map({ $0.date }).contains(where: { Calendar.current.isDate($0, equalTo: month, toGranularity: .month) }) {
                            Section(content: {
                                ForEach(searchResults) { transaction in
                                    if Calendar.current.isDate(transaction.date, equalTo: month, toGranularity: .month) {
                                        ZStack {
                                            NavigationLink(destination: {
                                                TransactionDetailView(transaction: transaction, update: $update)
                                            }, label: { EmptyView()} )
                                            .opacity(0)
                                            CellTransactionView(transaction: transaction, update: $update)
                                        }
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                                .listRowBackground(Color.colorBackground.edgesIgnoringSafeArea(.all))
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
                            .foregroundStyle(Color.colorLabel)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
            } else { // No Transactions
                ErrorView(
                    searchResultsCount: searchResults.count,
                    searchText: searchText,
                    image: "NoTransaction",
                    text: NSLocalizedString("error_message_transaction", comment: "")
                )
            }
        }
        .padding(update ? 0 : 0)
        .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
        .navigationTitle(NSLocalizedString("word_transactions", comment: ""))
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.colorLabel)
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu(content: {
                    Menu(content: {
                        Button(action: { withAnimation { filterTransactions = .month } }, label: { Label(NSLocalizedString("word_month", comment: ""), systemImage: "calendar") })
                        Button(action: { withAnimation { filterTransactions = .expenses } }, label: { Label(NSLocalizedString("word_expenses", comment: ""), systemImage: "arrow.down.forward") })
                    }, label: {
                        Label(NSLocalizedString("word_filter", comment: ""), systemImage: "slider.horizontal.3")
                    })
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.colorLabel)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
            }
        }
        .searchable(text: $searchText.animation(), prompt: NSLocalizedString("word_search", comment: ""))
        .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
        //        .sheet(isPresented: $showAddTransaction, onDismiss: { update.toggle() }) { AddTransactionView(account: $account) }
        .onDisappear { update.toggle() }
    }//END body
}//END struct

//MARK: - Preview
#Preview {
    SubcategoryTransactionsView(subcategory: subCategory1Category1, update: Binding.constant(false))
}
