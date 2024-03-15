//
//  AnalyticsHomeView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
// Localizations 01/10/2023

import SwiftUI
import UIKit
import Charts

struct AnalyticsHomeView: View {
    
    // Builder
    @ObservedObject var account: Account
    
    // Custom
    @ObservedObject var filter: Filter = sharedFilter
    
    // Environement
    @Environment(\.colorScheme) private var colorScheme
    
    // Computed var
    private var chartsView: [AnyView] {
        return [
            AnyView(IncomesChosenMonthChart(account: account)),
            AnyView(ExpensesChosenMonthChart(account: account)),
            AnyView(IncomesFromAutomationsChosenMonthChart(account: account)),
            AnyView(ExpensesFromAutomationsChosenMonthChart(account: account))
        ]
    }
    
    //MARK: - body
    var body: some View {
        VStack {
            if account.transactions.count > 0 {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Cash Flow Chart
                        CashFlowChart(account: account)
                        
                        if account.amountCashFlowByMonth(month: filter.date) == 0 {
                            VStack {
                                Spacer()
                                
                                HStack {
                                    Spacer()
                                    VStack(spacing: 20) {
                                        Image("NoIncome\(themeSelected)")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .shadow(radius: 4, y: 4)
                                            .frame(width: isIPad ? (orientation.isPortrait ? UIScreen.main.bounds.width / 2 : UIScreen.main.bounds.width / 3) : UIScreen.main.bounds.width / 1.5 )
                                        
                                        Text("analytic_home_no_stats".localized)
                                            .font(.semiBoldText16())
                                            .multilineTextAlignment(.center)
                                    }
                                    Spacer()
                                }
                                
                                Spacer()
                            }
                        } else {
                            ForEach(chartsView.indices, id: \.self) { index in
                                chartsView[index]
                            }
                        }
                        
                    } // END VSTACK CHARTS
                    .padding(.horizontal)
                    
                    Rectangle()
                        .frame(height: 120)
                        .opacity(0)
                    
                } // End ScrollView
                .blur(radius: filter.showMenu ? 3 : 0)
                .disabled(filter.showMenu)
                .onTapGesture { withAnimation { filter.showMenu = false } }
            } else {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        VStack(spacing: 20) {
                            Image("NoIncome\(themeSelected)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .shadow(radius: 4, y: 4)
                                .frame(width: isIPad ? (orientation.isPortrait ? UIScreen.main.bounds.width / 2 : UIScreen.main.bounds.width / 3) : UIScreen.main.bounds.width / 1.5 )
                            
                            Text("analytic_home_no_stats".localized)
                                .font(.semiBoldText16())
                                .multilineTextAlignment(.center)
                        }
                        .offset(y: -50)
                        Spacer()
                    }
                    
                    Spacer()
                }
            } // End account
        } // End VStack
        .navigationTitle("word_analytic".localized)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if account.transactions.count > 0 {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            filter.fromAnalytics = true
                            filter.showMenu.toggle()
                        }
                    }, label: {
                        Image(systemName: "calendar")
                            .foregroundStyle(Color(uiColor: .label))
                    })
                }
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // End body
} // End struct

//MARK: - Preview
#Preview {
    AnalyticsHomeView(account: Account.preview)
}


