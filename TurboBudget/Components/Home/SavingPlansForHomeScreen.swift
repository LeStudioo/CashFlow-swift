//
//  SavingPlansForHomeScreen.swift
//  CashFlow
//
//  Created by KaayZenn on 21/07/2023.
//
// Localizations 01/10/2023
// Refactor 25/02/2024

import SwiftUI

struct SavingPlansForHomeScreen: View {
        
    // Environment
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var savingsPlanRepository: SavingsPlanRepository
    @EnvironmentObject private var contributionRepository: ContributionRepository
    
    // Preferences
    @Preference(\.isSavingPlansDisplayedHomeScreen) private var isSavingPlansDisplayedHomeScreen
    @Preference(\.numberOfSavingPlansDisplayedInHomeScreen) private var numberOfSavingPlansDisplayedInHomeScreen

    // Other
    private let layout: [GridItem] = [
        GridItem(.flexible(minimum: 40), spacing: 20),
        GridItem(.flexible(minimum: 40), spacing: 20)
    ]
    
    // MARK: - body
    var body: some View {
        VStack {
            NavigationButton(push: router.pushHomeSavingPlans()) {
                HStack {
                    Text("savingsplans_for_home_title".localized)
                        .foregroundStyle(Color.customGray)
                        .font(.semiBoldCustom(size: 22))
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .foregroundStyle(ThemeManager.theme.color)
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            if !savingsPlanRepository.savingsPlans.isEmpty {
                HStack {
                    LazyVGrid(columns: layout, alignment: .center) {
                        ForEach(savingsPlanRepository.savingsPlans.prefix(numberOfSavingPlansDisplayedInHomeScreen)) { savingsPlan in
                            NavigationButton(push: router.pushSavingPlansDetail(savingsPlan: savingsPlan), action: {
                                Task {
                                    if let savingsPlanID = savingsPlan.id {
                                        await contributionRepository.fetchContributions(savingsplanID: savingsPlanID)
                                    }
                                }
                            }) {
                                SavingsPlanRow(savingsPlan: savingsPlan)
                            }
                            .padding(.bottom)
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("savingsplans_for_home_no_savings_plan".localized)
                            .font(Font.mediumText16())
                        
                        Spacer()
                        
                        Image("NoSavingPlan\(ThemeManager.theme.nameNotLocalized.capitalized)")
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
                    router.presentCreateSavingsPlan()
                }
            }
        }
        .animation(.smooth, value: savingsPlanRepository.savingsPlans.count)
        .isDisplayed(isSavingPlansDisplayedHomeScreen)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    SavingPlansForHomeScreen()
}
