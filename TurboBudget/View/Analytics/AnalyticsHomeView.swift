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
    var router: NavigationManager
    @ObservedObject var account: Account
    
    // Custom
    @ObservedObject var filter = FilterManager.shared
    
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
                                            .frame(width: isIPad
                                                   ? UIScreen.main.bounds.width / 3
                                                   : UIScreen.main.bounds.width / 1.5
                                            )
                                        
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
                                .frame(width: isIPad 
                                       ? UIScreen.main.bounds.width / 3
                                       : UIScreen.main.bounds.width / 1.5
                                )
                            
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
                        router.pushFilter()
                    }, label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundStyle(Color(uiColor: .label))
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                    })
                }
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // End body
} // End struct

//MARK: - Preview
#Preview {
    AnalyticsHomeView(router: .init(isPresented: .constant(nil)), account: Account.preview)
}


