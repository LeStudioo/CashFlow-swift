//
//  GenericBarChart.swift
//  CashFlow
//
//  Created by Theo Sementa on 30/12/2024.
//

import SwiftUI
import Charts

struct GenericBarChart: View {
    
    // Builder
    var title: String
    @Binding var selectedDate: Date
    var values: [Double]
    var amount: Double
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .foregroundStyle(Color.customGray)
                        .font(Font.mediumSmall())
                    
                    Text(amount.toCurrency())
                        .foregroundStyle(Color.text)
                        .font(DesignSystem.FontDS.Title.semibold)
                        .animation(.smooth, value: amount)
                        .contentTransition(.numericText())
                }
                Spacer()
            }
            .padding(8)
            
            Chart {
                ForEach(values.indices, id: \.self) { index in
                    let value = values[index]
                    BarMark(
                        x: .value("x", "\(index)"),
                        y: .value("y", value)
                    )
                    .foregroundStyle(selectedDate.month == (index + 1) ? Color.blue.gradient : themeManager.theme.color.gradient)
                    .offset(x: 0, y: value > 0 ? -2 : 2)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: value > 0 ? 8 : 2,
                            bottomLeadingRadius: value < 0 ? 8 : 2,
                            bottomTrailingRadius: value < 0 ? 8 : 2,
                            topTrailingRadius: value > 0 ? 8 : 2,
                            style: .continuous
                        )
                    )
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
                AxisMarks { value in
                    let month = value.index > 11 ? "" : Calendar.current.monthSymbols[value.index]
                    AxisValueLabel {
                        Text(String(month.prefix(3)))
                            .padding(.top, 8)
                    }
                }
            }
            .frame(height: 200)
            
            VStack(spacing: 8) {
                SwitchDateButton(date: $selectedDate, type: .month)
                SwitchDateButton(date: $selectedDate, type: .year)
            }
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.background100)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    GenericBarChart(
        title: "",
        selectedDate: .constant(.now),
        values: [12, 34, 56, 42, 35, 0, 0, 0, 0, 0, 0, 0],
        amount: 340
    )
    .environmentObject(ThemeManager.shared)
}
