//
//  TransactionsListView.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import SwiftUI
import NavigationKit
import StatsKit

struct TransactionsListView: View {
    
    @EnvironmentObject private var accountStore: AccountStore
    @EnvironmentObject private var transactionStore: TransactionStore
    
    @State private var isLoading: Bool = false
    
    // MARK: -
    var body: some View {
        List(transactionStore.transactionsByMonth.sorted(by: { $0.key > $1.key }), id: \.key) { month, transactions in
            Section {
                ForEach(transactions) { transaction in
                    NavigationButton(
                        route: .push,
                        destination: AppDestination.transaction(.detail(transaction: transaction))
                    ) {
                        TransactionRow(transaction: transaction)
                    }
                    .id(transaction.id)
                    .padding(.horizontal)
                    .onAppear {
                        if transactionStore.transactions.last?.id == transaction.id && !isLoading {
                            self.isLoading = true
                        }
                    }
                }
                .noDefaultStyle()
                .padding(.vertical, DesignSystem.Padding.extraSmall)
            } header: {
                DetailOfExpensesAndIncomesByMonth(
                    month: month,
                    amountOfExpenses: transactions.filter { $0.type == .expense }
                        .compactMap(\.amount)
                        .reduce(0, +),
                    amountOfIncomes: transactions.filter { $0.type == .income }
                        .compactMap(\.amount)
                        .reduce(0, +)
                )
            } // Section
        } // List
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .overlay(alignment: .bottom) {
            if isLoading {
                CashFlowLoader()
            }
        }
        .animation(.smooth, value: transactionStore.transactions.count)
        .onChange(of: isLoading) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    Task {
                        if let selectedAccount = self.accountStore.selectedAccount, let accountID = selectedAccount._id {
                            let startDateOneMonthAgo = self.transactionStore.currentDateForFetch.oneMonthAgo
                            let endDateOneMonthAgo = startDateOneMonthAgo.endOfMonth
                            await self.transactionStore.fetchTransactionsByPeriod(
                                accountID: accountID,
                                startDate: startDateOneMonthAgo,
                                endDate: endDateOneMonthAgo
                            )
                            self.isLoading = false
                        }
                    }
                }
            }
        }
        .onAppear {
            EventService.sendEvent(key: .transactionListPage)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    TransactionsListView()
}
