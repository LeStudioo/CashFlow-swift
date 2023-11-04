//
//  RecentIncomesView.swift
//  CashFlow
//
//  Created by KaayZenn on 21/07/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct RecentIncomesView: View {
    
    //Custom type
    @Binding var account: Account?
    @ObservedObject var filter: Filter = sharedFilter
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    
    //Environnements
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    //State or Binding String
    @State private var searchText: String = ""
    
    //State or Binding Int, Float and Double
    
    //State or Binding Bool
    @Binding var update: Bool
    @State private var isEditing: Bool = false
    @State private var showAddTransaction: Bool = false
    @State private var ascendingOrder: Bool = false
    
    //Enum
    @State private var filterTransactions: FilterForRecentTransaction = .incomes
    
    //Computed var
    var getAllMonthForTransactions: [DateComponents] {
        var array: [DateComponents] = []
        
        if let account {
            for transaction in account.transactions {
                let components = Calendar.current.dateComponents([.month, .year], from: transaction.date)
                let monthOfSelectedDate = Calendar.current.dateComponents([.month, .year], from: filter.date)
                let finalDate: Date = Calendar.current.date(from: monthOfSelectedDate) ?? .now
                if !array.contains(components) && Calendar.current.isDate(finalDate, equalTo: transaction.date, toGranularity: .month) {
                    array.append(components)
                }
            }
        }
        
        return array
    }
        
    var searchResults: [Transaction] {
        if let account {
            if searchText.isEmpty {
                if ascendingOrder {
                    return account.transactions.filter { $0.amount > 0 && !$0.comeFromAuto }.sorted { $0.amount > $1.amount }.reversed()
                } else {
                    return account.transactions.filter { $0.amount > 0 && !$0.comeFromAuto }.sorted { $0.amount > $1.amount }
                }
            } else {
                return account.transactions.filter { $0.amount > 0 && !$0.comeFromAuto }.sorted { $0.amount > $1.amount }.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            }
        } else { return [] }
    }
    
    //MARK: - Body
    var body: some View {
        VStack {
            if searchResults.count != 0 && getAllMonthForTransactions.count != 0 {
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
                                DetailOfExpensesOrIncomesByMonth(
                                    filterTransactions: $filterTransactions,
                                    month: month,
                                    amountOfExpenses: 0,
                                    amountOfIncomes: searchResults.filter({ $0.date >= month.startOfMonth && $0.date <= month.endOfMonth }).map({ $0.amount }).reduce(0, +),
                                    ascendingOrder: $ascendingOrder
                                )
                                .listRowInsets(EdgeInsets(top: -12, leading: 0, bottom: 8, trailing: 0))
                            })
                            .foregroundStyle(Color.colorLabel)
                        }
                    }
                } // End List
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
            } else { //SearchResult == 0
                VStack(spacing: 20) {
                    Image("NoResults\(themeSelected)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .shadow(radius: 4, y: 4)
                        .frame(width: isIPad ? (orientation.isLandscape ? UIScreen.main.bounds.width / 3 : UIScreen.main.bounds.width / 2) : UIScreen.main.bounds.width / 1.5 )
                    
                    Text(NSLocalizedString("word_no_results", comment: "") + " '\(searchText)'")
                        .font(Font.mediumText16())
                        .multilineTextAlignment(.center)
                }
                .offset(y: -20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding(update ? 0 : 0)
        .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
        .navigationTitle(NSLocalizedString("word_incomes", comment: ""))
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
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Menu(content: {
                    Button(action: { showAddTransaction.toggle() }, label: {
                        Label(NSLocalizedString("word_add", comment: ""), systemImage: "plus")
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
        .onDisappear { update.toggle() }
        .onChange(of: update) { _ in
            if searchResults.count == 0 { dismiss() }
        }
    }//END body
    
    //MARK: Fonctions
    func amountIncomesByMonth(month: Date) -> Double {
        if let account {
            return account.getAllTransactionsIncomeForChosenMonth(selectedDate: month).filter { !$0.comeFromAuto }.map({ $0.amount }).reduce(0, +)
        } else { return 0 }
    }
    
}//END struct

//MARK: - Preview
struct RecentIncomesView_Previews: PreviewProvider {
    
    @State static var prevUpdate: Bool = false
    @State static var previewAccount: Account? = previewAccount1()
    
    static var previews: some View {
        RecentIncomesView(account: $previewAccount, update: $prevUpdate)
    }
}
