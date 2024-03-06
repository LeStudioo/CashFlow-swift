//
//  AutomationsForHomeScreen.swift
//  CashFlow
//
//  Created by KaayZenn on 21/07/2023.
//
// Localizations 01/10/2023
// Refactor 25/02/2024

import SwiftUI

struct AutomationsForHomeScreen: View {
    
    // Builder
    var router: NavigationManager
    @ObservedObject var account: Account
    
    // Environment
    @Environment(\.colorScheme) private var colorScheme
    
    // Preferences
    @Preference(\.numberOfAutomationsDisplayedInHomeScreen) private var numberOfAutomationsDisplayedInHomeScreen
    
    // MARK: - body
    var body: some View {
        VStack {
            Button(action: {
                router.pushHomeAutomations(account: account)
            }, label: {
                HStack {
                    Text("automations_for_home_title".localized)
                        .foregroundStyle(Color.customGray)
                        .font(.semiBoldCustom(size: 22))
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .foregroundStyle(HelperManager().getAppTheme().color)
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                }
            })
            .padding(.horizontal)
            .padding(.top)
            
            if account.automations.count != 0 {
                VStack {
                    ForEach(account.automations.prefix(numberOfAutomationsDisplayedInHomeScreen)) { automation in
                        Button(action: {
                            if let transaction = automation.automationToTransaction {
                                router.pushTransactionDetail(transaction: transaction)
                            }
                        }, label: {
                            CellAutomationView(automation: automation)
                        })
                    }
                }
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("automations_for_home_no_auto".localized)
                            .font(Font.mediumText16())
                        
                        Spacer(minLength: 20)
                        
                        Image("NoAutomation\(themeSelected)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .shadow(radius: 4, y: 4)
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal)
                .frame(height: 160)
                .background(Color.colorCell)
                .cornerRadius(20)
                .padding(.horizontal)
                .onTapGesture {
                    router.presentCreateAutomation()
                }
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    AutomationsForHomeScreen(
        router: .init(isPresented: .constant(.homeAutomations(account: Account.preview))),
        account: Account.preview
    )
}
