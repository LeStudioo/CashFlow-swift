//
//  AnalyticsHomeView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
// Localizations 01/10/2023

import SwiftUI
import UIKit
import Charts

struct AnalyticsHomeView: View {
    
    // Builder
    @EnvironmentObject private var accountRepository: AccountStore
    @EnvironmentObject private var transactionRepository: TransactionStore
    
    // Environment
    @EnvironmentObject private var router: NavigationManager
    
    // Custom
    @State private var dailyExpenses: [AmountByDay] = []
    @State private var dailyIncomes: [AmountByDay] = []
    @State private var dailySubscriptionsExpenses: [AmountByDay] = []
    @State private var dailySubscriptionsIncomes: [AmountByDay] = []
    
    @State private var selectedDate: Date = Date()
    @State private var selectedYear: Int = Date().year
    @State private var amount: Double = 0

    // MARK: -
    var body: some View {
        ScrollView {
            if !transactionRepository.transactions.isEmpty {
                VStack(spacing: 16) {
                    GenericBarChart(
                        title: "cashflowchart_title".localized,
                        selectedDate: $selectedDate,
                        values: accountRepository.cashflow,
                        amount: amount
                    )
                    .onChange(of: selectedDate) { _ in
                        Task {
                            if selectedDate.year != selectedYear {
                                selectedYear = selectedDate.year
                                await fetchCashFlow()
                            }
                            amount = accountRepository.cashFlowAmount(for: selectedDate)
                        }
                    }
                    .task {
                        await fetchCashFlow()
                        amount = accountRepository.cashFlowAmount(for: selectedDate)
                    }
                    
                    NavigationButton(push: router.pushTransactionsForMonth(month: selectedDate, type: .income)) {
                        GenericLineChart(
                            selectedDate: selectedDate,
                            values: dailyIncomes,
                            config: .init(
                                title: "chart_incomes_incomes_in".localized + " " + selectedDate.formatted(.monthAndYear),
                                mainColor: Color.primary500
                            )
                        )
                    }
                    NavigationButton(push: router.pushTransactionsForMonth(month: selectedDate, type: .expense)) {
                        GenericLineChart(
                            selectedDate: selectedDate,
                            values: dailyExpenses,
                            config: .init(
                                title: "chart_expenses_expenses_in".localized + " " + selectedDate.formatted(.monthAndYear),
                                mainColor: Color.error400
                            )
                        )
                    }
                    GenericLineChart(
                        selectedDate: selectedDate,
                        values: dailySubscriptionsIncomes,
                        config: .init(
                            title: "chart_auto_incomes_incomes_in".localized + " " + selectedDate.formatted(.monthAndYear),
                            mainColor: Color.primary500
                        )
                    )
                    GenericLineChart(
                        selectedDate: selectedDate,
                        values: dailySubscriptionsExpenses,
                        config: .init(
                            title: "chart_auto_expenses_expenses_in".localized + " " + selectedDate.formatted(.monthAndYear),
                            mainColor: Color.error400
                        )
                    )
                }
                .padding(.horizontal)
                
                Rectangle()
                    .frame(height: 120)
                    .opacity(0)
            } else {
                CustomEmptyView(
                    type: .empty(.analytics),
                    isDisplayed: transactionRepository.transactions.isEmpty
                )
            }
        } // ScrollView
        .scrollIndicators(.hidden)
        .navigationTitle("word_analytic".localized)
        .navigationBarTitleDisplayMode(.large)
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .onChange(of: selectedDate) { _ in
            if let account = accountRepository.selectedAccount, let accountID = account.id {
                Task {
                    await transactionRepository.fetchTransactionsByPeriod(
                        accountID: accountID,
                        startDate: selectedDate,
                        endDate: selectedDate.endOfMonth
                    )
                    updateChartData()
                }
            }
        }
        .onAppear {
            updateChartData()
        }
    } // body
    
    private func updateChartData() {
        withAnimation(.smooth) {
            dailyExpenses = transactionRepository.dailyTransactions(for: selectedDate, type: .expense)
            dailyIncomes = transactionRepository.dailyTransactions(for: selectedDate, type: .income)
            dailySubscriptionsExpenses = transactionRepository.dailySubscriptions(for: selectedDate, type: .expense)
            dailySubscriptionsIncomes = transactionRepository.dailySubscriptions(for: selectedDate, type: .income)
        }
    }
    
    func fetchCashFlow() async {
        if let selectedAccount = accountRepository.selectedAccount, let accountID = selectedAccount.id {
            await accountRepository.fetchCashFlow(accountID: accountID, year: selectedDate.year)
        }
    }
    
} // struct

// MARK: - Preview
#Preview {
    AnalyticsHomeView()
}
