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

    //Custom type
    @Binding var account: Account?
    @ObservedObject var filter: Filter = sharedFilter

    //Environnements
    @Environment(\.colorScheme) private var colorScheme

    //State or Binding String

    //State or Binding Int, Float and Double

    //State or Binding Bool
    @Binding var update: Bool
    @State private var showAlert: Bool = false
    
    //State or Binding Date

	//Enum
	
	//Computed var
    var allTransactions: [Transaction] {
        if let account {
            return account.transactions.filter { Calendar.current.isDate($0.date, equalTo: filter.date, toGranularity: .year) }
        } else { return [] }
    }

    //MARK: - Body
    var body: some View {
        if let account {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(NSLocalizedString("cashflowchart_title", comment: ""))
                            .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                            .font(Font.mediumSmall())
                        
                        Text(TransactionManager().totalCashFlowForSelectedMonth(account: account, selectedDate: filter.date).currency)
                            .foregroundColor(.colorLabel)
                            .font(.semiBoldH3())
                    }
                    Spacer()
                }
                .padding(8)
                .overlay(alignment: .topTrailing) {
                    Button(action: { showAlert.toggle() }, label: {
                        Image(systemName: "info.circle")
                            .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                    })
                    .padding(8)
                }
                Chart {
                    ForEach(Array(AccountManager().groupAndSortTransactionsByMonth(allTransactions: allTransactions)).sorted(by: { $0.key < $1.key }).indices, id: \.self) { index in

                        let components = Calendar.current.dateComponents([.month, .year], from: filter.date)

                        let sortedTransactionsByMonth = AccountManager().groupAndSortTransactionsByMonth(allTransactions: allTransactions)
                        let sortedMonthsAndTransactions = Array(sortedTransactionsByMonth).sorted(by: { $0.key < $1.key })
                        let month = sortedMonthsAndTransactions[index].key
                        let transactions = TransactionManager().totalCashFlowForSpecificMonthYear(transactions: allTransactions, month: month, year: components.year ?? 0)

                        BarMark(x: .value("x", "\(index)"),
                                y: .value("y", transactions))
                        .foregroundStyle((components.month ?? 0) == month ? Color.yellow.gradient : HelperManager().getAppTheme().color.gradient)
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
            .padding(update ? 0 : 0)
            .padding(8)
            .background(Color.colorCell)
            .cornerRadius(15)
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text(NSLocalizedString("cashflowchart_alert_title", comment: "")), message: Text(NSLocalizedString("cashflowchart_alert_desc", comment: "")), dismissButton: .cancel(Text(NSLocalizedString("word_ok", comment: ""))) )
            })
        } else { EmptyView().frame(height: 0) }
    }//END body

    //MARK: Fonctions

}//END struct

//MARK: - Preview
struct CashFlowChart_Previews: PreviewProvider {
    
    @State static var previewUpdate: Bool = false
    @State static var previewAccount: Account? = previewAccount1()
    
    static var previews: some View {
        CashFlowChart(account: $previewAccount, update: $previewUpdate)
    }
}
