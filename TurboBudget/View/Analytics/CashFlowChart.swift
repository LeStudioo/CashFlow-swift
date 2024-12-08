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
        
    // Custom
    @ObservedObject var filter = FilterManager.shared
    @EnvironmentObject private var accountRepository: AccountRepository
    @EnvironmentObject private var transactionRepository: TransactionRepository
    @EnvironmentObject private var themeManager: ThemeManager
    
    // Environement
    @Environment(\.colorScheme) private var colorScheme
    
    // Boolean variables
    @State private var showAlert: Bool = false
    
    // MARK: -
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("cashflowchart_title".localized)
                        .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                        .font(Font.mediumSmall())
                    
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
                        .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
                .padding(8)
            }
            
            Chart {
                ForEach(accountRepository.cashflow.indices, id: \.self) { index in
                    let value = accountRepository.cashflow[index]
//                    let components = Calendar.current.dateComponents([.month, .year], from: filter.date)
//                    let month = transactionsByMonth[index].key

                    BarMark(x: .value("x", "\(index)"),
                            y: .value("y", value))
//                    .foregroundStyle((components.month ?? 0) == month ? Color.yellow.gradient : themeManager.theme.color.gradient)
                    .foregroundStyle(themeManager.theme.color.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                }
            }
            .chartYAxis(.hidden)
            .chartXAxis() {
                AxisMarks { value in
                    let month = value.index > 11 ? "" : Calendar.current.monthSymbols[value.index]
                    AxisValueLabel { Text(String(month.prefix(3))) }
                }
            }
            .frame(height: 180)
        }
        .padding(8)
        .background(Color.colorCell)
        .cornerRadius(15)
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("cashflowchart_alert_title".localized), message: Text("cashflowchart_alert_desc".localized), dismissButton: .cancel(Text("word_ok".localized)) )
        })
        .task {
            if let selectedAccount = accountRepository.selectedAccount, let accountID = selectedAccount.id {
                await accountRepository.fetchCashFlow(accountID: accountID, year: Date().year)
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    CashFlowChart()
}
