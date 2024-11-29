//
//  TransactionsListView.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/11/2024.
//
// https://stackoverflow.com/questions/72647382/customise-section-headers-only-when-headers-are-pinned-otherwise-not-swiftui

import SwiftUI

struct TransactionsListView: View {
    
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var accountRepository: AccountRepository
    @EnvironmentObject private var transactionRepository: TransactionRepository
    
    @State private var lastTransactionID: Int? = nil
    @State private var pinned: Int? = nil
    
    // MARK: -
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                    ForEach(Array(transactionRepository.monthsOfTransactions.enumerated()), id: \.offset) { index, month in
                        Section {
                            ForEach(transactionRepository.transactions) { transaction in
                                if Calendar.current.isDate(transaction.date, equalTo: month, toGranularity: .month) {
                                    NavigationButton(push: router.pushTransactionDetail(transaction: transaction)) {
                                        TransactionRow(transaction: transaction)
                                            .padding(.horizontal)
                                    }
                                    .id(transaction.id)
                                    .onAppear {
                                        if let lastTransaction = transactionRepository.transactions.last, lastTransaction == transaction {
                                            self.lastTransactionID = lastTransaction.id
                                        }
                                    }
                                }
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                            .listRowBackground(Color.background.edgesIgnoringSafeArea(.all))
                        } header: {
                            DetailOfExpensesAndIncomesByMonth(
                                month: month,
                                amountOfExpenses: transactionRepository.amountExpensesForSelectedMonth(month: month),
                                amountOfIncomes: transactionRepository.amountIncomesForSelectedMonth(month: month),
                                isPinned: index == pinned
                            )
                            .background(GeometryReader {
                                // detect current position of header
                                Color.clear.preference(
                                    key: ViewOffsetKey.self,
                                    value: $0.frame(in: .named("transactionsList")).origin.y
                                )
                            })
                        } // Section
                        .onPreferenceChange(ViewOffsetKey.self) {
                            if $0 == 0 || $0 >= 0.01 {
                                if $0 == 0 {
                                    self.pinned = index
                                } else if self.pinned == index {
                                    self.pinned = nil
                                }
                            }
                        }
                    } // ForEach
                    
                    Section(content: { }, footer: {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    })
                    .listRowSeparator(.hidden)
                    .task {
                        if let lastTransactionID {
                            if let selectedAccount = accountRepository.selectedAccount, let accountID = selectedAccount.id {
                                await transactionRepository.fetchTransactionsWithPagination(accountID: accountID)
                                scrollProxy.scrollTo(lastTransactionID)
                            }
                        }
                    }
                } // End List
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .background(Color.background.edgesIgnoringSafeArea(.all))
                .animation(.smooth, value: transactionRepository.transactions.count)
            } // Scroll View
        } // ScrollViewReader
        .coordinateSpace(name: "transactionsList")
    } // body
} // struct

// MARK: - Preview
#Preview {
    TransactionsListView()
}
