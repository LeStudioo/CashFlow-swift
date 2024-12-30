//
//  SavingsPlanChart.swift
//  CashFlow
//
//  Created by Theo Sementa on 30/12/2024.
//

import SwiftUI
import Charts

struct SavingsPlanChart: View {
    
    @EnvironmentObject private var contributionStore: ContributionStore
    @EnvironmentObject private var themeManager: ThemeManager
    
    @State private var selectedDate: Date = Date()
    @State private var selectedYear: Int = Date().year
    
    @State private var contributionsByMonth: [Double] = []
    @State private var currentAmount: Double = 0
    
    // MARK: -
    var body: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 10) {
                Text(selectedDate.formatted(Date.FormatStyle().month(.wide).year()).capitalized)
                    .foregroundStyle(Color.customGray)
                    .font(Font.mediumSmall())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(currentAmount.toCurrency())
                    .foregroundStyle(Color.text)
                    .font(.semiBoldText18())
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(8)
            
            Chart {
                ForEach(contributionsByMonth.indices, id: \.self) { index in
                    let value = contributionsByMonth[index]
                    BarMark(
                        x: .value("x", "\(index)"),
                        y: .value("y", value)
                    )
                    .foregroundStyle(selectedDate.month == (index + 1) ? Color.blue.gradient : themeManager.theme.color.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
            }
            .chartYAxis(.hidden)
            .chartXAxis {
                AxisMarks { value in
                    let month = value.index > 11 ? "" : Calendar.current.monthSymbols[value.index]
                    AxisValueLabel { Text(String(month.prefix(3))) }
                }
            }
            .frame(height: 180)
            
            VStack(spacing: 8) {
                SwitchDateButton(date: $selectedDate, type: .month)
                SwitchDateButton(date: $selectedDate, type: .year)
            }
        }
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.background100)
        }
        .onChange(of: selectedDate) { _ in
            if selectedDate.year != selectedYear {
                selectedYear = selectedDate.year
                contributionsByMonth = contributionStore.getContributionsAmountByMonth(for: selectedDate.year)
            }
            currentAmount = contributionsByMonth[selectedDate.month - 1]
        }
        .onChange(of: contributionStore.contributions.count) { _ in
            contributionsByMonth = contributionStore.getContributionsAmountByMonth(for: selectedDate.year)
            currentAmount = contributionsByMonth[selectedDate.month - 1]
        }
        .onAppear {
            contributionsByMonth = contributionStore.getContributionsAmountByMonth(for: selectedDate.year)
            currentAmount = contributionsByMonth[selectedDate.month - 1]
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    SavingsPlanChart()
}
