//
//  CarouselOfChartsView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import Charts

struct CarouselOfChartsView: View {

    //Custom type
    @Binding var account: Account?
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared

    //Environnements
    @Environment(\.colorScheme) private var colorScheme
    
    //State or Binding String

    //State or Binding Int, Float and Double
    @State private var selectedChart: Int = 0

    //State or Binding Bool
    @Binding var update: Bool

    //Enum
    
    //Computed var
    
    //Color

    //MARK: - Body
    var body: some View {
        if let account {
            VStack {
                TabView(selection: $selectedChart) {
                    
                    //CHART of expenses in actual month
                    VStack {
                        titleOfChart(text: NSLocalizedString("carousel_charts_expenses_current_month", comment: ""), amount: account.amountOfExpensesInActualMonth())
                        
                        if account.dailyAmountOfExpensesInActualMonth().map({ $0.amount }).reduce(0, +) != 0 {
                            Chart {
                                ForEach(account.dailyAmountOfExpensesInActualMonth(), id: \.self) { item in
                                    LineMark(x: .value("Day", item.day),
                                             y: .value("Value", item.amount))
                                    .interpolationMethod(.catmullRom)
                                    .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                    .foregroundStyle(Color.error400)
                                    
                                    AreaMark(x: .value("Day", item.day),
                                             y: .value("Value", item.amount))
                                    .interpolationMethod(.catmullRom)
                                    .foregroundStyle(LinearGradient(colors: [.error400.opacity(0.6), .clear], startPoint: .top, endPoint: .bottom))
                                }
                            }
                            .padding(8)
                        } else {
                            Image("NoSpend\(themeSelected)")
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .padding(.bottom, 8)
                        }
                    }
                    .background(Color.colorCell)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .tag(0)
                    
                    //CHART of incomes in actual month
                    VStack {
                        titleOfChart(text: NSLocalizedString("carousel_charts_incomes_current_month", comment: ""), amount: account.amountIncomeInActualMonth())
                        
                        if account.amountIncomePerDayInActualMonth().map({ $0.amount }).reduce(0, +) != 0 {
                            Chart {
                                ForEach(account.amountIncomePerDayInActualMonth(), id: \.self) { item in
                                    LineMark(x: .value("Day", item.day),
                                             y: .value("Value", item.amount))
                                    .interpolationMethod(.catmullRom)
                                    .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                    .foregroundStyle(Color.primary500)
                                    
                                    AreaMark(x: .value("Day", item.day),
                                             y: .value("Value", item.amount))
                                    .interpolationMethod(.catmullRom)
                                    .foregroundStyle(LinearGradient(colors: [.primary500.opacity(0.6), .clear], startPoint: .top, endPoint: .bottom))
                                }
                            }
                            .padding(8)
                        } else {
                            Image("NoAccount\(themeSelected)")
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .padding(.bottom, 8)
                        }
                    }
                    .background(Color.colorCell)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 250)
                
                PageControl(maxPages: 2, currentPage: selectedChart)
            }
            .padding(update ? 0 : 0)
        }
    }//END body

    //MARK: Fonctions
    
    //MARK: ViewBuilder
    @ViewBuilder
    func titleOfChart(text: String, amount: Double) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(text)
                    .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                    .font(Font.mediumText16())
                
                Text(amount.currency)
                    .foregroundColor(.colorLabel)
                    .font(.semiBoldH3())
            }
            Spacer()
        }
        .padding()
    }
}//END struct

//MARK: - Preview
#Preview {
    CarouselOfChartsView(account: Binding.constant(previewAccount1()), update: Binding.constant(false))
}
