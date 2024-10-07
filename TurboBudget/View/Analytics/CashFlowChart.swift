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
    @ObservedObject var account: Account
    
    // Custom
    @ObservedObject var filter = FilterManager.shared
    @EnvironmentObject private var transactionRepo: TransactionRepository
    
    // Environement
    @Environment(\.colorScheme) private var colorScheme
    
    // Boolean variables
    @State private var showAlert: Bool = false
    
    //MARK: - body
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("cashflowchart_title".localized)
                        .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                        .font(Font.mediumSmall())
                    
                    Text(TransactionManager().totalCashFlowForSelectedMonth(account: account, selectedDate: filter.date).currency)
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
                let transactionsByMonth = transactionRepo.transactionsByMonth.sorted(by: { $0.key < $1.key })
                ForEach(transactionsByMonth.indices, id: \.self) { index in
                    
                    let components = Calendar.current.dateComponents([.month, .year], from: filter.date)
                    
                    let month = transactionsByMonth[index].key
                    let transactions = transactionRepo.totalCashFlowForSpecificMonthYear(month: month, year: components.year ?? 0)
                    
                    BarMark(x: .value("x", "\(index)"),
                            y: .value("y", transactions))
                    .foregroundStyle((components.month ?? 0) == month ? Color.yellow.gradient : ThemeManager.theme.color.gradient)
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
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CashFlowChart(account: Account.preview)
}
