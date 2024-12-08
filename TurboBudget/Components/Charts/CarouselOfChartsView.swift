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
    
    // Environement
    @EnvironmentObject private var transactionRepository: TransactionRepository
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var themeManager: ThemeManager
    
    // Number variables
    @State private var selectedChart: Int = 0
    
    // MARK: - body
    var body: some View {
        let expenseAmount = transactionRepository.amountOfTransactionsForCurrentMonth(type: .expense)
        let incomeAmount = transactionRepository.amountOfTransactionsForCurrentMonth(type: .income)

        VStack {
            TabView(selection: $selectedChart) {
                
                // CHART of expenses in actual month
                VStack {
                    titleOfChart(
                        text: "carousel_charts_expenses_current_month".localized,
                        amount: expenseAmount
                    )
                    
                    if expenseAmount != 0 {
                        Chart {
                            ForEach(transactionRepository.dailyAmountOfTransactionsInCurrentMonth(type: .expense)) { item in
                                LineMark(x: .value("Day", item.day),
                                         y: .value("Value", item.amount))
                                .interpolationMethod(.catmullRom)
                                .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                .foregroundStyle(Color.error400)
                                
                                AreaMark(x: .value("Day", item.day),
                                         y: .value("Value", item.amount))
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(LinearGradient(colors: [.error400.opacity(0.6), .clear], startPoint: .top, endPoint: .bottom))
                            }
                        }
                        .padding(8)
                    } else {
                        Image("NoSpend\(themeManager.theme.nameNotLocalized.capitalized)")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .padding(.bottom, 8)
                    }
                }
                .background(Color.colorCell)
                .cornerRadius(15)
                .padding(.horizontal)
                .tag(0)
                
                //CHART of incomes in actual month
                VStack {
                    titleOfChart(
                        text: "carousel_charts_incomes_current_month".localized,
                        amount: incomeAmount
                    )
                    
                    if incomeAmount != 0 {
                        Chart {
                            ForEach(transactionRepository.dailyAmountOfTransactionsInCurrentMonth(type: .income)) { item in
                                LineMark(x: .value("Day", item.day),
                                         y: .value("Value", item.amount))
                                .interpolationMethod(.catmullRom)
                                .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                .foregroundStyle(Color.primary500)
                                
                                AreaMark(x: .value("Day", item.day),
                                         y: .value("Value", item.amount))
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(LinearGradient(colors: [.primary500.opacity(0.6), .clear], startPoint: .top, endPoint: .bottom))
                            }
                        }
                        .padding(8)
                    } else {
                        Image("NoAccount\(themeManager.theme.nameNotLocalized.capitalized)")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .padding(.bottom, 8)
                    }
                }
                .background(Color.colorCell)
                .cornerRadius(15)
                .padding(.horizontal)
                .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 250)
            
            PageControl(maxPages: 2, currentPage: selectedChart)
        }
    } // End body
    
    // MARK: ViewBuilder
    @ViewBuilder
    func titleOfChart(text: String, amount: Double) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(text)
                    .foregroundStyle(Color.customGray)
                    .font(Font.mediumText16())
                
                Text(amount.toCurrency())
                    .foregroundStyle(Color(uiColor: .label))
                    .font(.semiBoldH3())
            }
            Spacer()
        }
        .padding()
    }
} // End struct

// MARK: - Preview
#Preview {
    CarouselOfChartsView()
}
