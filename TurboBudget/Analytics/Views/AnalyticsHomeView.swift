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
    @ObservedObject var filter = FilterManager.shared
    
    @State private var dailyExpenses: [AmountOfTransactionsByDay] = []
    @State private var dailyIncomes: [AmountOfTransactionsByDay] = []
    @State private var dailySubscriptionsExpenses: [AmountOfTransactionsByDay] = []
    @State private var dailySubscriptionsIncomes: [AmountOfTransactionsByDay] = []
    
    @State private var selectedDate: Date = Date()

    // MARK: -
    var body: some View {
        ScrollView {
            if !transactionRepository.transactions.isEmpty {
                VStack(spacing: 16) {
                    CashFlowChart(selectedDate: $selectedDate)
                    
                    AnalyticsLineChart(
                        selectedDate: selectedDate,
                        values: dailyIncomes,
                        config: .init(
                            title: "chart_incomes_incomes_in".localized,
                            mainColor: Color.primary500
                        )
                    )
                    AnalyticsLineChart(
                        selectedDate: selectedDate,
                        values: dailyExpenses,
                        config: .init(
                            title: "chart_expenses_expenses_in".localized,
                            mainColor: Color.error400
                        )
                    )
                    AnalyticsLineChart(
                        selectedDate: selectedDate,
                        values: dailySubscriptionsIncomes,
                        config: .init(
                            title: "chart_auto_incomes_incomes_in".localized,
                            mainColor: Color.primary500
                        )
                    )
                    AnalyticsLineChart(
                        selectedDate: selectedDate,
                        values: dailySubscriptionsExpenses,
                        config: .init(
                            title: "chart_auto_expenses_expenses_in".localized,
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
    } // End body
    
    private func updateChartData() {
        withAnimation(.smooth) {
            dailyExpenses = transactionRepository.dailyTransactions(for: selectedDate, type: .expense)
            dailyIncomes = transactionRepository.dailyTransactions(for: selectedDate, type: .income)
            dailySubscriptionsExpenses = transactionRepository.dailySubscriptions(for: selectedDate, type: .expense)
            dailySubscriptionsIncomes = transactionRepository.dailySubscriptions(for: selectedDate, type: .income)
        }
    }
    
} // End struct

// MARK: - Preview
#Preview {
    AnalyticsHomeView()
}
