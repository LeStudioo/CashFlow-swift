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
    
    //Custom type
    @Binding var account: Account?
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    @ObservedObject var filter: Filter = sharedFilter
    
    //Environnements
    @Environment(\.colorScheme) private var colorScheme
    
    //State or Binding String
    
    //State or Binding Int, Float and Double
    
    //State or Binding Bool
    @Binding var update: Bool
    
    //State or Binding Date
    
    //State or Binding Orientation
    
    //Enum
    
    //Computed var
    
    private var sortedViews: [AnyView] {
        let viewsDictionary: [String: AnyView] = [
            NSLocalizedString("word_incomes", comment: ""): AnyView(IncomesChosenMonthChart(account: $account, update: $update)),
            NSLocalizedString("word_expenses", comment: ""): AnyView(ExpensesChosenMonthChart(account: $account, update: $update)),
            NSLocalizedString("word_automations_incomes", comment: ""): AnyView(IncomesFromAutomationsChosenMonthChart(account: $account, update: $update)),
            NSLocalizedString("word_automations_expenses", comment: ""): AnyView(ExpensesFromAutomationsChosenMonthChart(account: $account, update: $update))
        ]
        let sortedKeys = userDefaultsManager.orderOfCharts
        
        return sortedKeys.compactMap { viewsDictionary[$0] }
    }
    
    //MARK: - Body
    var body: some View {
        VStack {
            if let account, account.transactions.count > 0 {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Cash Flow Chart
                        CashFlowChart(account: $account, update: $update)
                        
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
                                        
                                        Text(NSLocalizedString("analytic_home_no_stats", comment: ""))
                                            .font(.semiBoldText16())
                                            .multilineTextAlignment(.center)
                                    }
                                    Spacer()
                                }
                                
                                Spacer()
                            }
                        } else {
                            ForEach(sortedViews.indices, id: \.self) { index in
                                sortedViews[index]
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
                            
                            Text(NSLocalizedString("analytic_home_no_stats", comment: ""))
                                .font(.semiBoldText16())
                                .multilineTextAlignment(.center)
                        }
                        .offset(y: -50)
                        Spacer()
                    }
                    
                    Spacer()
                }
            }// End account
        } // END VStack
        .padding(update ? 0 : 0)
        .navigationTitle(NSLocalizedString("word_analytic", comment: ""))
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if let account, account.transactions.count > 0 {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            filter.fromAnalytics = true
                            filter.showMenu.toggle()
                            update.toggle()
                        }
                    }, label: {
                        Image(systemName: "calendar")
                            .foregroundColor(.colorLabel)
                    })
                }
            }
        }
        .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
        .onRotate { _ in
            update.toggle()
        }
    }//END body
    
    //MARK: Fonctions
}//END struct

//MARK: - Preview
struct AnalyticsHomeView_Previews: PreviewProvider {
    
    @State static var account: Account? = previewAccount1()
    @State static var accountNil: Account? = nil
    @State static var previewUpdate: Bool = false
    
    static var previews: some View {
        AnalyticsHomeView(account: $account, update: $previewUpdate)
        AnalyticsHomeView(account: $accountNil, update: $previewUpdate)
    }
}


