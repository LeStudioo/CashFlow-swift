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
    
    // MARK: -
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("cashflowchart_title".localized)
                        .foregroundStyle(Color.customGray)
                        .font(Font.mediumSmall())
                    
                    // TODO: Refaire
                    Text(transactionRepository.amountCashFlowByMonth(month: filter.date).toCurrency())
                        .foregroundStyle(Color(uiColor: .label))
                        .font(.semiBoldH3())
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
                    .clipShape(RoundedRectangle(cornerRadius: 30))
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
                fetchCashFlow()
            }
        }
        .onAppear {
            fetchCashFlow()
        }
    } // body
    
    func fetchCashFlow() {
        Task {
            if let selectedAccount = accountRepository.selectedAccount, let accountID = selectedAccount.id {
                await accountRepository.fetchCashFlow(accountID: accountID, year: selectedDate.year)
            }
        }
    }
    
} // struct

// MARK: - Preview
#Preview {
    CashFlowChart(selectedDate: .constant(.now))
}
