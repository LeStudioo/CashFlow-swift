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
    @ObservedObject var account: Account
    
    // Environment
    @EnvironmentObject private var router: NavigationManager
    
    // Custom
    @ObservedObject var filter = FilterManager.shared
    
    // MARK: -
    var body: some View {
        VStack {
            if account.transactions.count > 0 {
                ScrollView {
                    VStack(spacing: 20) {
                        // Cash Flow Chart
                        CashFlowChart(account: account)
                        
                        if account.amountCashFlowByMonth(month: filter.date) == 0 {
                            CustomEmptyView(
                                imageName: "NoIncome\(ThemeManager.theme.nameNotLocalized.capitalized)",
                                description: "analytic_home_no_stats".localized
                            )
                        } else {
                            AnalyticsLineChart(
                                values: TransactionManager().dailyIncomeAmountsForSelectedMonth(account: account, selectedDate: filter.date),
                                config: .init(
                                    title: "chart_incomes_incomes_in".localized,
                                    mainColor: Color.primary500
                                )
                            )
                            AnalyticsLineChart(
                                values: TransactionManager().dailyExpenseAmountsForSelectedMonth(account: account, selectedDate: filter.date),
                                config: .init(
                                    title: "chart_expenses_expenses_in".localized,
                                    mainColor: Color.error400
                                )
                            )
                            AnalyticsLineChart(
                                values: TransactionManager().dailyAutomatedIncomeAmountsForSelectedMonth(account: account, selectedDate: filter.date),
                                config: .init(
                                    title: "chart_auto_incomes_incomes_in".localized,
                                    mainColor: Color.primary500
                                )
                            )
                            AnalyticsLineChart(
                                values: TransactionManager().dailyAutomatedExpenseAmountsForSelectedMonth(account: account, selectedDate: filter.date),
                                config: .init(
                                    title: "chart_auto_expenses_expenses_in".localized,
                                    mainColor: Color.error400
                                )
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    Rectangle()
                        .frame(height: 120)
                        .opacity(0)
                    
                } // End ScrollView
                .scrollIndicators(.hidden)
            } else {
                CustomEmptyView(
                    imageName: "NoIncome\(ThemeManager.theme.nameNotLocalized.capitalized)",
                    description: "analytic_home_no_stats".localized
                )
            } // End account
        } // End VStack
        .navigationTitle("word_analytic".localized)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if account.transactions.count > 0 {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationButton(push: router.pushFilter()) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundStyle(Color(uiColor: .label))
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                    }
                }
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // End body
} // End struct

//MARK: - Preview
#Preview {
    AnalyticsHomeView(account: Account.preview)
}


