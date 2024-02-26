//
//  IncomesChosenMonthChart.swift
//  CashFlow
//
//  Created by KaayZenn on 24/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import Charts

struct IncomesChosenMonthChart: View {
    
    // Builder
    @ObservedObject var account: Account
    
    // Custom
    @ObservedObject var filter: Filter = sharedFilter
    
    // Environement
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - body
    var body: some View {
        let sortedTransactionsIncomeByDay = TransactionManager().dailyIncomeAmountsForSelectedMonth(account: account, selectedDate: filter.date)
        
        // Money Income in chosen month Chart
        if sortedTransactionsIncomeByDay.map({ $0.amount }).reduce(0, +) != 0 {
            VStack {
                let monthOfSelectedDate = Calendar.current.dateComponents([.month, .year], from: filter.date)
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            if let month = monthOfSelectedDate.month {
                                Text("chart_incomes_incomes_in".localized + " " + Calendar.current.monthSymbols[month - 1])
                                    .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                                    .font(Font.mediumSmall())
                            }
                            
                            Text(sortedTransactionsIncomeByDay.map { $0.amount }.reduce(0, +).currency)
                                .foregroundColor(.colorLabel)
                                .font(.semiBoldText18())
                        }
                        
                        Spacer()
                    }
                    .padding(8)
                    
                    Chart(sortedTransactionsIncomeByDay, id: \.self) { item in
                        if let day = Calendar.current.dateComponents([.day], from: item.day).day {
                            LineMark(x: .value("", day),
                                     y: .value("", item.amount))
                            .foregroundStyle(Color.primary500)
                            .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                            .interpolationMethod(.catmullRom)
                            
                            AreaMark(x: .value("", day),
                                     y: .value("", item.amount))
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(LinearGradient(colors: [.primary500.opacity(0.6), .clear], startPoint: .top, endPoint: .bottom))
                        }
                        
                    }
                    .chartXScale(domain: 0...31)
                    
                }
                .padding(8)
                .background(Color.colorCell)
                .cornerRadius(15)
            }
        } else {
            EmptyView().frame(height: 0)
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    IncomesChosenMonthChart(account: Account.preview)
}
