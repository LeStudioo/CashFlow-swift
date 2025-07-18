//
//  AnalyticsHomeView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
// Localizations 01/10/2023

import SwiftUI
import UIKit
import NavigationKit
import TheoKit
import DesignSystemModule

struct AnalyticsScreen: View {
    
    // Stores
    @EnvironmentObject private var accountStore: AccountStore
    @EnvironmentObject private var transactionStore: TransactionStore
    @EnvironmentObject private var router: Router<AppDestination>
        
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
        VStack(spacing: 0) {
            if !transactionStore.transactions.isEmpty {
                BetterScrollView(maxBlurRadius: Blur.topbar) {
                    NavigationBar(
                        title: "word_statistics".localized,
                        withDismiss: false,
                        actionButton: .init(
                            icon: .iconGear,
                            action: { router.push(.settings(.home)) },
                            isDisabled: false
                        )
                    )
                } content: { _ in
                    VStack(spacing: Spacing.large) {
                        GenericBarChart(
                            title: "cashflowchart_title".localized,
                            selectedDate: $selectedDate,
                            values: accountStore.cashflow,
                            amount: amount
                        )
                        .onChange(of: selectedDate) { _ in
                            Task {
                                if selectedDate.year != selectedYear {
                                    selectedYear = selectedDate.year
                                    await fetchCashFlow()
                                }
                                amount = accountStore.cashFlowAmount(for: selectedDate)
                            }
                        }
                        .task {
                            await fetchCashFlow()
                            amount = accountStore.cashFlowAmount(for: selectedDate)
                        }
                        
                        NavigationButton(
                            route: .push,
                            destination: AppDestination.transaction(.specificList(month: selectedDate, type: .income))) {
                                GenericLineChart(
                                    selectedDate: selectedDate,
                                    values: dailyIncomes,
                                    config: .init(
                                        title: "chart_incomes_incomes_in".localized + " " + selectedDate.formatted(.monthAndYear),
                                        mainColor: Color.primary500
                                    )
                                )
                            }
                        
                        NavigationButton(
                            route: .push,
                            destination: AppDestination.transaction(.specificList(month: selectedDate, type: .expense))) {
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
                    .padding(.horizontal, Padding.large)
                    
                    Rectangle()
                        .frame(height: 120)
                        .opacity(0)
                }
            } else {
                CustomEmptyView(
                    type: .empty(.analytics),
                    isDisplayed: transactionStore.transactions.isEmpty
                )
            }
        } // VStack
        .background(TKDesignSystem.Colors.Background.Theme.bg50)
        .onChange(of: selectedDate) { _ in
            if let account = accountStore.selectedAccount, let accountID = account._id {
                Task {
                    await transactionStore.fetchTransactionsByPeriod(
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
            dailyExpenses = transactionStore.dailyTransactions(for: selectedDate, type: .expense)
            dailyIncomes = transactionStore.dailyTransactions(for: selectedDate, type: .income)
            dailySubscriptionsExpenses = transactionStore.dailySubscriptions(for: selectedDate, type: .expense)
            dailySubscriptionsIncomes = transactionStore.dailySubscriptions(for: selectedDate, type: .income)
        }
    }
    
    func fetchCashFlow() async {
        if let selectedAccount = accountStore.selectedAccount, let accountID = selectedAccount._id {
            await accountStore.fetchCashFlow(accountID: accountID, year: selectedDate.year)
        }
    }
    
} // struct

// MARK: - Preview
#Preview {
    AnalyticsScreen()
}
