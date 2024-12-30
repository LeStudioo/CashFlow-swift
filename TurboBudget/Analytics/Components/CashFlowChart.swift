//
//  CashFlowChart.swift
//  CashFlow
//
//  Created by KaayZenn on 24/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import Charts

struct CashFlowChart: View {
    
    // Builder
    @Binding var selectedDate: Date
    
    // Custom
    @ObservedObject var filter = FilterManager.shared
    @EnvironmentObject private var accountRepository: AccountStore
    @EnvironmentObject private var transactionRepository: TransactionStore
    @EnvironmentObject private var themeManager: ThemeManager
    
    // Boolean variables
    @State private var showAlert: Bool = false
    @State private var selectedYear: Int = Date().year
    
    @State private var amount: String = ""
    
    // MARK: -
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("cashflowchart_title".localized)
                        .foregroundStyle(Color.customGray)
                        .font(Font.mediumSmall())
                    
                    Text(amount)
                        .foregroundStyle(Color.text)
                        .font(.semiBoldH3())
                        .animation(.smooth, value: amount)
                        .contentTransition(.numericText())
                }
                Spacer()
            }
            .padding(8)
            .overlay(alignment: .topTrailing) {
                Button(action: { showAlert.toggle() }, label: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(Color.customGray)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
                .padding(8)
            }
            
            Chart {
                ForEach(accountRepository.cashflow.indices, id: \.self) { index in
                    let value = accountRepository.cashflow[index]
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
        .alert(isPresented: $showAlert, content: {
            Alert(
                title: Text("cashflowchart_alert_title".localized),
                message: Text("cashflowchart_alert_desc".localized),
                dismissButton: .cancel(Text("word_ok".localized))
            )
        })
        .onChange(of: selectedDate) { _ in
            if selectedDate.year != selectedYear {
                selectedYear = selectedDate.year
                Task {
                    await fetchCashFlow()
                }
            }
            amount = accountRepository.cashFlowAmount(for: selectedDate).toCurrency()
        }
        .task {
            await fetchCashFlow()
            amount = accountRepository.cashFlowAmount(for: selectedDate).toCurrency()
        }
    } // body
    
    func fetchCashFlow() async {
        if let selectedAccount = accountRepository.selectedAccount, let accountID = selectedAccount.id {
            await accountRepository.fetchCashFlow(accountID: accountID, year: selectedDate.year)
        }
    }
    
} // struct

// MARK: - Preview
#Preview {
    CashFlowChart(selectedDate: .constant(.now))
}
