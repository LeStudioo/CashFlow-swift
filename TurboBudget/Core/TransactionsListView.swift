//
//  TransactionsListView.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import SwiftUI

struct TransactionsListView: View {
    
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var accountRepository: AccountStore
    @EnvironmentObject private var transactionRepository: TransactionStore
    
    @State private var isLoading: Bool = false
    
    // MARK: -
    var body: some View {
        List(transactionRepository.transactionsByMonth.sorted(by: { $0.key > $1.key }), id: \.key) { month, transactions in
            Section {
                ForEach(transactions) { transaction in
                    NavigationButton(push: router.pushTransactionDetail(transaction: transaction)) {
                        TransactionRow(transaction: transaction)
                    }
                    .id(transaction.id)
                    .padding(.horizontal)
                    .onAppear {
                        if transactionRepository.transactions.last?.id == transaction.id && !isLoading {
                            self.isLoading = true
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                .listRowBackground(Color.background.edgesIgnoringSafeArea(.all))
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
        .animation(.smooth, value: transactionRepository.transactions.count)
        .onChange(of: isLoading) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    Task {
                        if let selectedAccount = self.accountRepository.selectedAccount, let accountID = selectedAccount.id {
                            let startDateOneMonthAgo = self.transactionRepository.currentDateForFetch.oneMonthAgo
                            let endDateOneMonthAgo = startDateOneMonthAgo.endOfMonth
                            await self.transactionRepository.fetchTransactionsByPeriod(
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
    } // body
} // struct

// MARK: - Preview
#Preview {
    TransactionsListView()
}
