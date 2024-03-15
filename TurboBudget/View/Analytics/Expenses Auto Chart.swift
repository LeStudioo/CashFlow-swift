//
//  ExpensesFromAutomationsChosenMonthChart.swift
//  CashFlow
//
//  Created by KaayZenn on 24/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import Charts

struct ExpensesFromAutomationsChosenMonthChart: View {
    
    // Builder
    @ObservedObject var account: Account
    
    // Custom
    @ObservedObject var filter: Filter = sharedFilter
    
    // Environement
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - body
    var body: some View {
        let dailyExpensesAutomations = TransactionManager().dailyAutomatedExpenseAmountsForSelectedMonth(account: account, selectedDate: filter.date)
        
        // Money Expenses From Automations in chosen month Chart
        if dailyExpensesAutomations.map({ $0.amount }).reduce(0, -) != 0 {
            VStack {
                let monthOfSelectedDate = Calendar.current.dateComponents([.month], from: filter.date)
                
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            if let month = monthOfSelectedDate.month {
                                Text("chart_auto_expenses_expenses_in".localized + " " + Calendar.current.monthSymbols[month - 1])
                                    .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                                    .font(Font.mediumSmall())
                            }
                            
                            Text(dailyExpensesAutomations.map { $0.amount }.reduce(0, +).currency )
                                .foregroundStyle(Color(uiColor: .label))
                                .font(.semiBoldText18())
                        }
                        
                        Spacer()
                    }
                    .padding(8)
                    
                    Chart(dailyExpensesAutomations, id: \.self) { item in
                        if let day = Calendar.current.dateComponents([.day], from: item.day).day {
                            LineMark(x: .value("", day),
                                     y: .value("", item.amount))
                            .foregroundStyle(Color.error400)
                            .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                            .interpolationMethod(.catmullRom)
                            
                            AreaMark(x: .value("", day),
                                     y: .value("", item.amount))
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(LinearGradient(colors: [.error400.opacity(0.6), .clear], startPoint: .top, endPoint: .bottom))
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
    } // Edn body
} // End struct

// MARK: - Preview
#Preview {
    ExpensesFromAutomationsChosenMonthChart(account: Account.preview)
}
