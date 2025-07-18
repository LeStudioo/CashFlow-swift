//
//  GenericLineChart.swift
//  CashFlow
//
//  Created by Theo Sementa on 30/12/2024.
//

import SwiftUI
import Charts
import TheoKit
import DesignSystemModule

struct GenericLineChart: View {
    
    // builder
    var selectedDate: Date
    var values: [AmountByDay]
    var config: Configuration
    
    // Computed
    var amounts: [Double] {
        return values.map(\.amount)
    }
    
    // MARK: -
    var body: some View {
        VStack(spacing: Spacing.large) {
            VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                Text(config.title)
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                    .fontWithLineHeight(DesignSystem.Fonts.Body.small)
                
                Text(amounts.reduce(0, +).toCurrency())
                    .foregroundStyle(Color.label)
                    .fontWithLineHeight(DesignSystem.Fonts.Title.medium)
            }
            .fullWidth(.leading)
            
            Chart {
                ForEach(values) { item in
                    LineMark(x: .value("Day", item.day),
                            y: .value("Value", item.amount))
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
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
            .frame(height: 180)
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
        }
        .padding(Padding.standard)
        .roundedRectangleBorder(
            TKDesignSystem.Colors.Background.Theme.bg100,
            radius: 16,
            lineWidth: 1,
            strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
        )
    } // body
} // struct

// MARK: - Configuration
extension GenericLineChart {
    struct Configuration {
        var title: String
        var mainColor: Color
    }
}

// MARK: - Preview
#Preview {
    GenericLineChart(
        selectedDate: .now,
        values: [.mockToday, .mockTomorrow],
        config: .init(
            title: "Preview chart",
            mainColor: Color.error400
        )
    )
}
