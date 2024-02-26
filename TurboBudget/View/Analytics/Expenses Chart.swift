//
//  ExpensesChosenMonthChart.swift
//  CashFlow
//
//  Created by KaayZenn on 24/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import Charts

struct ExpensesChosenMonthChart: View {
    
    // Builder
    @ObservedObject var account: Account
    
    //Custom type
    @ObservedObject var filter: Filter = sharedFilter
    
    // Environement
    @Environment(\.colorScheme) private var colorScheme
    
    //MARK: - Body
    var body: some View {
        let sortedExpensesTransactionsByDay = TransactionManager().dailyExpenseAmountsForSelectedMonth(account: account, selectedDate: filter.date)
        
        // Money Expenses in chosen month Chart
        if sortedExpensesTransactionsByDay.map({ $0.amount }).reduce(0, -) != 0 {
            VStack {
                let monthOfSelectedDate = Calendar.current.dateComponents([.month], from: filter.date)
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            if let month = monthOfSelectedDate.month {
                                Text("chart_expenses_expenses_in".localized + " " + Calendar.current.monthSymbols[month - 1])
                                    .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                                    .font(Font.mediumSmall())
                            }
                            
                            Text(sortedExpensesTransactionsByDay.map { $0.amount }.reduce(0, +).currency )
                                .foregroundColor(.colorLabel)
                                .font(.semiBoldText18())
                        }
                        Spacer()
                        
                    }
                    .padding(8)
                    
                    Chart(sortedExpensesTransactionsByDay, id: \.self) { item in
                        if let day = Calendar.current.dateComponents([.day], from: item.day).day {
                            LineMark(x: .value("", day),
                                     y: .value("", item.amount))
                            .interpolationMethod(.catmullRom)
                            .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                            .foregroundStyle(Color.error400)
                            
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
    } // End body
} // End struct

//MARK: - Preview
#Preview {
    ExpensesChosenMonthChart(account: Account.preview)
}
