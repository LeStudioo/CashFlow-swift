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
    var selectedDate: Date
    var values: [AmountOfTransactionsByDay]
    var config: Configuration
    
    @ObservedObject var filter = FilterManager.shared
        
    // Computed
    var amounts: [Double] { return values.map(\.amount) }
    
    // MARK: -
    var body: some View {
        if amounts.reduce(0, +) != 0 {
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(config.title + " " + selectedDate.formatted(Date.FormatStyle().month(.wide).year()))
                        .foregroundStyle(Color.customGray)
                        .font(Font.mediumSmall())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(amounts.reduce(0, +).toCurrency())
                        .foregroundStyle(Color(uiColor: .label))
                        .font(.semiBoldText18())
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(8)
                
                Chart {
                    ForEach(values) { item in
                        LineMark(x: .value("Day", item.day),
                                y: .value("Value", item.amount))
                        .interpolationMethod(.catmullRom)
                        .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                        .foregroundStyle(config.mainColor)
                        
                        AreaMark(x: .value("Day", item.day),
                                y: .value("Value", item.amount))
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
        selectedDate: .now,
        values: AmountOfTransactionsByDay.mockAll,
        config: .init(
            title: "chart_auto_expenses_expenses_in".localized,
            mainColor: .red
        )
    )
}
