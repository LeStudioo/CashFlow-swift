//
//  CarouselOfChartsView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import Charts

struct CarouselOfChartsView: View {
    
    // Environment
    @EnvironmentObject private var transactionStore: TransactionStore
    @EnvironmentObject private var themeManager: ThemeManager
    
    // State variables
    @State private var selectedChart: Int = 0
    @State private var dailyExpenses: [AmountOfTransactionsByDay] = []
    @State private var dailyIncomes: [AmountOfTransactionsByDay] = []
    @State private var totalExpenses: Double = 0
    @State private var totalIncomes: Double = 0
    
    // MARK: -
    var body: some View {
        VStack {
            TabView(selection: $selectedChart) {
                // CHART of expenses in actual month
                VStack(spacing: 8) {
                    titleOfChart(
                        text: "carousel_charts_expenses_current_month".localized,
                        amount: totalExpenses
                    )
                    .padding(.horizontal)
                    .padding(.top)
                    
                    if totalExpenses != 0 {
                        Chart {
                            ForEach(dailyExpenses) { item in
                                LineMark(x: .value("Day", item.day),
                                        y: .value("Value", item.amount))
                                .interpolationMethod(.catmullRom)
                                .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                                .foregroundStyle(Color.error400)
                                
                                AreaMark(x: .value("Day", item.day),
                                        y: .value("Value", item.amount))
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(LinearGradient(colors: [.error400.opacity(0.6), .clear], startPoint: .top, endPoint: .bottom))
                            }
                        }
                        .chartYAxis {
                            AxisMarks { value in
                                AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                                    .foregroundStyle(Color.background200)
                                AxisValueLabel {
                                    if let doubleValue = value.as(Double.self) {
                                        Text(doubleValue.toCurrency())
                                            .font(.system(size: 11, weight: .semibold))
                                            .padding(.leading, 4)
                                    }
                                }
                            }
                        }
                        .chartXAxis {
                            AxisMarks { _ in
                                AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                                    .foregroundStyle(Color.background200)
                                AxisValueLabel()
                                    .font(.system(size: 11, weight: .semibold))
                                    .offset(y: 4)
                            }
                        }
                        .padding()
                    } else {
                        Image("NoSpend\(themeManager.theme.nameNotLocalized.capitalized)")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .padding(.bottom, 8)
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.background100)
                }
                .padding(.horizontal)
                .tag(0)
                
                // CHART of incomes in actual month
                VStack(spacing: 8) {
                    titleOfChart(
                        text: "carousel_charts_incomes_current_month".localized,
                        amount: totalIncomes
                    )
                    .padding(.horizontal)
                    .padding(.top)
                    
                    if totalIncomes != 0 {
                        Chart {
                            ForEach(dailyIncomes) { item in
                                LineMark(x: .value("Day", item.day),
                                        y: .value("Value", item.amount))
                                .interpolationMethod(.catmullRom)
                                .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                                .foregroundStyle(Color.primary500)
                                
                                AreaMark(x: .value("Day", item.day),
                                        y: .value("Value", item.amount))
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(LinearGradient(colors: [.primary500.opacity(0.6), .clear], startPoint: .top, endPoint: .bottom))
                            }
                        }
                        .chartYAxis {
                            AxisMarks { value in
                                AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                                    .foregroundStyle(Color.background200)
                                AxisValueLabel {
                                    if let doubleValue = value.as(Double.self) {
                                        Text(doubleValue.toCurrency())
                                            .font(.system(size: 11, weight: .semibold))
                                            .padding(.leading, 4)
                                    }
                                }
                            }
                        }
                        .chartXAxis {
                            AxisMarks { _ in
                                AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                                    .foregroundStyle(Color.background200)
                                AxisValueLabel()
                                    .font(.system(size: 11, weight: .semibold))
                                    .offset(y: 4)
                            }
                        }
                        .padding()
                    } else {
                        Image("NoAccount\(themeManager.theme.nameNotLocalized.capitalized)")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .padding(.bottom, 8)
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.background100)
                }
                .padding(.horizontal)
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
    
    @ViewBuilder
    func titleOfChart(text: String, amount: Double) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(text)
                    .foregroundStyle(Color.customGray)
                    .font(Font.mediumText16())
                
                Text(amount.toCurrency())
                    .foregroundStyle(Color.text)
                    .font(.semiBoldH3())
            }
            Spacer()
        }
    }
} // struct

// MARK: - Preview
#Preview {
    CarouselOfChartsView()
}
