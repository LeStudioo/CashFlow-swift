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
    @EnvironmentObject private var transactionRepository: TransactionStore
    
    // Environment
    @EnvironmentObject private var router: NavigationManager
    
    // Custom
    @ObservedObject var filter = FilterManager.shared
    
    // MARK: -
    var body: some View {
        ScrollView {
            if !transactionRepository.transactions.isEmpty {
                VStack(spacing: 16) {
                    CashFlowChart()
                    
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

// MARK: - Preview
#Preview {
    AnalyticsHomeView()
}
