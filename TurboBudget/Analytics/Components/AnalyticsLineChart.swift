//
//  AnalyticsLineChart.swift
//  CashFlow
//
//  Created by Theo Sementa on 13/11/2024.
//

import SwiftUI
import Charts

struct AnalyticsLineChart: View {
    
    // builder
    var values: [AmountOfTransactionsByDay]
    var config: Configuration
    
    @ObservedObject var filter = FilterManager.shared
        
    // Computed
    var amounts: [Double] { return values.map(\.amount) }
    
    // MARK: -
    var body: some View {
        if amounts.reduce(0, +) != 0 {
            let monthOfSelectedDate = Calendar.current.dateComponents([.month], from: filter.date)
            
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    if let month = monthOfSelectedDate.month {
                        Text(config.title + " " + Calendar.current.monthSymbols[month - 1])
                            .foregroundStyle(Color.customGray)
                            .font(Font.mediumSmall())
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Text(amounts.reduce(0, +).toCurrency() )
                        .foregroundStyle(Color(uiColor: .label))
                        .font(.semiBoldText18())
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(8)
                
                Chart(values, id: \.self) { item in
                    if let day = Calendar.current.dateComponents([.day], from: item.day).day {
                        LineMark(x: .value("", day),
                                 y: .value("", item.amount))
                        .foregroundStyle(config.mainColor)
                        .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                        .interpolationMethod(.catmullRom)
                        
                        AreaMark(x: .value("", day),
                                 y: .value("", item.amount))
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [config.mainColor.opacity(0.6), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                }
                .chartXScale(domain: 0...31)
            }
            .padding(8)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.background100)
            }
        } else {
            EmptyView()
                .frame(height: 0)
        }
    } // body
} // struct

// MARK: - Configuration
extension AnalyticsLineChart {
    struct Configuration {
        var title: String
        var mainColor: Color
    }
}

// MARK: - Preview
#Preview {
    AnalyticsLineChart(
        values: AmountOfTransactionsByDay.mockAll,
        config: .init(
            title: "chart_auto_expenses_expenses_in".localized,
            mainColor: .red
        )
    )
}
