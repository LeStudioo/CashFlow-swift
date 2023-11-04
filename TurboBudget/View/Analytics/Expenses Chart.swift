//
//  ExpensesChosenMonthChart.swift
//  CashFlow
//
//  Created by KaayZenn on 24/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import Charts

struct ExpensesChosenMonthChart: View {
    
    //Custom type
    @Binding var account: Account?
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    @ObservedObject var filter: Filter = sharedFilter
    
    //Environnements
    @Environment(\.colorScheme) private var colorScheme
    
    //State or Binding String
    
    //State or Binding Int, Float and Double
    
    //State or Binding Date
    
    //State or Binding Bool
    @Binding var update: Bool
    
    //Enum
    
    //Computed var
    
    //MARK: - Body
    var body: some View {
        if let account {
            let sortedExpensesTransactionsByDay = TransactionManager().dailyExpenseAmountsForSelectedMonth(account: account, selectedDate: filter.date)
            
            // Money Expenses in chosen month Chart
            if userDefaultsManager.isExpenseTransactionsChart && sortedExpensesTransactionsByDay.map({ $0.amount }).reduce(0, -) != 0 {
                VStack {
                    let monthOfSelectedDate = Calendar.current.dateComponents([.month], from: filter.date)
                    NavigationLink(destination: { RecentExpensesView(account: $account, update: $update) }, label: {
                        VStack {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    if let month = monthOfSelectedDate.month {
                                        Text(NSLocalizedString("chart_expenses_expenses_in", comment: "") + " " + Calendar.current.monthSymbols[month - 1])
                                            .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                                            .font(Font.mediumSmall())
                                    }
                                    
                                    Text(sortedExpensesTransactionsByDay.map { $0.amount }.reduce(0, +).currency )
                                        .foregroundColor(.colorLabel)
                                        .font(.semiBoldText18())
                                }
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                            }
                            .padding(8)
                            
                            Chart(sortedExpensesTransactionsByDay, id: \.self) { item in
                                if let day = Calendar.current.dateComponents([.day], from: item.day).day {
                                    LineMark(x: .value("", day),
                                             y: .value("", item.amount))
                                    .interpolationMethod(.catmullRom)
                                    .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                    .foregroundStyle(Color.error400)
                                    
                                    AreaMark(x: .value("", day),
                                             y: .value("", item.amount))
                                    .interpolationMethod(.catmullRom)
                                    .foregroundStyle(LinearGradient(colors: [.error400.opacity(0.6), .clear], startPoint: .top, endPoint: .bottom))
                                }
                            }
                            .chartXScale(domain: 0...31)
                            
                        }
                        .padding(8)
                        .background(Color.colorCell)
                        .cornerRadius(15)
                    })
                }
                .padding(update ? 0 : 0)
            } else {
                EmptyView().frame(height: 0)
            }
        }
    }//END body
    
    //MARK: Fonctions
    
}//END struct

//MARK: - Preview
struct ExpensesChosenMonthChart_Previews: PreviewProvider {
    
    @State static var updatePreview: Bool = false
    @State static var previewAccount: Account? = previewAccount1()
    
    static var previews: some View {
        ExpensesChosenMonthChart(account: $previewAccount, update: $updatePreview)
    }
}
