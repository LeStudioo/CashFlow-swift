//
//  HomeScreenSavingsPlan.swift
//  CashFlow
//
//  Created by KaayZenn on 21/07/2023.
//
// Localizations 01/10/2023
// Refactor 25/02/2024

import SwiftUI

struct HomeScreenSavingsPlan: View {
        
    // Environment
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var savingsPlanRepository: SavingsPlanStore
    @EnvironmentObject private var contributionRepository: ContributionStore
    
    // Preferences
    @StateObject var preferencesDisplayHome: PreferencesDisplayHome = .shared

    // Other
    private let layout: [GridItem] = [
        GridItem(.flexible(minimum: 40), spacing: 20),
        GridItem(.flexible(minimum: 40), spacing: 20)
    ]
    
    // MARK: - body
    var body: some View {
        VStack {
            HomeScreenComponentHeader(type: .savingsPlan)
            
            if !savingsPlanRepository.savingsPlans.isEmpty {
                LazyVGrid(columns: layout, alignment: .center) {
                    ForEach(savingsPlanRepository.savingsPlans.prefix(preferencesDisplayHome.savingsPlan_value)) { savingsPlan in
                        NavigationButton(
                            push: router.pushSavingPlansDetail(savingsPlan: savingsPlan),
                            action: {
                                Task {
                                    if let savingsPlanID = savingsPlan.id {
                                        await contributionRepository.fetchContributions(savingsplanID: savingsPlanID)
                                    }
                                }
                            }, label: {
                                SavingsPlanRow(savingsPlan: savingsPlan)
                            }
                        )
                        .padding(.bottom)
                    }
                }
            } else {
                HomeScreenEmptyRow(type: .savingsPlan)
            }
        }
        .animation(.smooth, value: savingsPlanRepository.savingsPlans.count)
        .isDisplayed(preferencesDisplayHome.savingsPlan_isDisplayed)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    HomeScreenSavingsPlan()
}
