//
//  CarouselOfChartsView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import Charts
import TheoKit
import DesignSystemModule

struct CarouselOfChartsView: View {
    
    // Environment
    @EnvironmentObject private var transactionStore: TransactionStore
    @EnvironmentObject private var themeManager: ThemeManager
    
    // State variables
    @State private var selectedChart: Int = 0
    @State private var dailyExpenses: [AmountByDay] = []
    @State private var dailyIncomes: [AmountByDay] = []
    @State private var totalExpenses: Double = 0
    @State private var totalIncomes: Double = 0
    
    // MARK: -
    var body: some View {
        VStack {
            TabView(selection: $selectedChart) {
                GenericLineChart(
                    selectedDate: .now,
                    values: dailyExpenses,
                    config: .init(
                        title: "carousel_charts_expenses_current_month".localized,
                        mainColor: Color.error400
                    )
                )
                .padding(.horizontal, Padding.large)
                .tag(0)
                
                GenericLineChart(
                    selectedDate: .now,
                    values: dailyIncomes,
                    config: .init(
                        title: "carousel_charts_incomes_current_month".localized,
                        mainColor: Color.primary500
                    )
                )
                .padding(.horizontal, Padding.large)
                .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 300)
            
            PageControl(maxPages: 2, currentPage: selectedChart)
        }
        .onAppear {
            updateChartData()
        }
        .onChange(of: transactionStore.transactions.count) { _ in
            updateChartData()
        }
    } // body
    
    private func updateChartData() {
        dailyExpenses = transactionStore.dailyTransactions(for: .now, type: .expense)
        dailyIncomes = transactionStore.dailyTransactions(for: .now, type: .income)
        totalExpenses = dailyExpenses.map(\.amount).reduce(0, +)
        totalIncomes = dailyIncomes.map(\.amount).reduce(0, +)
    }
    
} // struct

// MARK: - Preview
#Preview {
    CarouselOfChartsView()
}
