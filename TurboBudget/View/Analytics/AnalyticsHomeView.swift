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
    @EnvironmentObject private var transactionRepository: TransactionRepository
    
    // Environment
    @EnvironmentObject private var router: NavigationManager
    
    // Custom
    @ObservedObject var filter = FilterManager.shared
    
    // MARK: -
    var body: some View {
        VStack {
            if transactionRepository.transactions.count > 0 {
                ScrollView {
                    VStack(spacing: 20) {
                        // Cash Flow Chart
                        CashFlowChart()
                        
                        if transactionRepository.amountCashFlowByMonth(month: filter.date) == 0 {
                            CustomEmptyView(
                                type: .empty(situation: .analytics),
                                isDisplayed: true
                            )
                        } else {
                            AnalyticsLineChart(
                                values: transactionRepository.dailyIncomeAmountsForSelectedMonth(selectedDate: filter.date),
                                config: .init(
                                    title: "chart_incomes_incomes_in".localized,
                                    mainColor: Color.primary500
                                )
                            )
                            AnalyticsLineChart(
                                values: transactionRepository.dailyExpenseAmountsForSelectedMonth(selectedDate: filter.date),
                                config: .init(
                                    title: "chart_expenses_expenses_in".localized,
                                    mainColor: Color.error400
                                )
                            )
                            AnalyticsLineChart(
                                values: transactionRepository.dailyAutomatedIncomeAmountsForSelectedMonth(selectedDate: filter.date),
                                config: .init(
                                    title: "chart_auto_incomes_incomes_in".localized,
                                    mainColor: Color.primary500
                                )
                            )
                            AnalyticsLineChart(
                                values: transactionRepository.dailyAutomatedExpenseAmountsForSelectedMonth(selectedDate: filter.date),
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
                    type: .empty(situation: .analytics),
                    isDisplayed: true
                )
            } // End account
        } // End VStack
        .navigationTitle("word_analytic".localized)
        .navigationBarTitleDisplayMode(.large)
//        .toolbar {
//            if !transactionRepository.transactions.isEmpty {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationButton(push: router.pushFilter()) {
//                        Image(systemName: "line.3.horizontal.decrease.circle")
//                            .foregroundStyle(Color(uiColor: .label))
//                            .font(.system(size: 18, weight: .medium, design: .rounded))
//                    }
//                }
//            }
//        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // End body
} // End struct

//MARK: - Preview
#Preview {
    AnalyticsHomeView()
}


