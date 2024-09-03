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
    
    // Environment
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var automationRepo: AutomationRepository
    
    // Preferences
    @Preference(\.isAutomationsDisplayedHomeScreen) private var isAutomationsDisplayedHomeScreen
    @Preference(\.numberOfAutomationsDisplayedInHomeScreen) private var numberOfAutomationsDisplayedInHomeScreen
    
    // MARK: - body
    var body: some View {
        VStack {
            NavigationButton(push: router.pushHomeAutomations()) {
                HStack {
                    Text("automations_for_home_title".localized)
                        .foregroundStyle(Color.customGray)
                        .font(.semiBoldCustom(size: 22))
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .foregroundStyle(HelperManager().getAppTheme().color)
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            if automationRepo.automations.count != 0 {
                VStack {
                    ForEach(automationRepo.automations.prefix(numberOfAutomationsDisplayedInHomeScreen)) { automation in
                        Button(action: {
                            if let transaction = automation.automationToTransaction {
                                router.pushTransactionDetail(transaction: transaction)
                            }
                        }, label: {
                            AutomationRow(automation: automation)
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
        .isDisplayed(isAutomationsDisplayedHomeScreen)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    AutomationsForHomeScreen()
}
