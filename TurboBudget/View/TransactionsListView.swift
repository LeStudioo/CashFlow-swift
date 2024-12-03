//
//  TransactionsListView.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import SwiftUI

struct TransactionsListView: View {
    
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var accountRepository: AccountRepository
    @EnvironmentObject private var transactionRepository: TransactionRepository
    
    @State private var isLoading: Bool = false
    
    // MARK: -
    var body: some View {
        List(transactionRepository.transactionsByMonth.sorted(by: { $0.key > $1.key }), id: \.key) { month, transactions in
            Section {
                ForEach(transactions) { transaction in
                    NavigationButton(push: router.pushTransactionDetail(transaction: transaction)) {
                        TransactionRow(transaction: transaction)
                            .padding(.horizontal)
                    }
                    .id(transaction.id)
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
                    amountOfExpenses: transactionRepository.amountExpensesForSelectedMonth(month: month),
                    amountOfIncomes: transactionRepository.amountIncomesForSelectedMonth(month: month)
                )
            } // Section
        } // List
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
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
                            await self.transactionRepository.fetchTransactionsWithPagination(accountID: accountID)
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
