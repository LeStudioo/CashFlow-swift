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
    
    // Custom type
    var router: NavigationManager
    @ObservedObject var account: Account
    
    // Environment
    @Environment(\.colorScheme) private var colorScheme
    
    // Preferences
    @Preference(\.numberOfSavingPlansDisplayedInHomeScreen) private var numberOfSavingPlansDisplayedInHomeScreen

    // Other
    private let layout: [GridItem] = [
        GridItem(.flexible(minimum: 40), spacing: 20),
        GridItem(.flexible(minimum: 40), spacing: 20)
    ]
    
    // MARK: - body
    var body: some View {
        VStack {
            Button(action: {
                router.pushHomeSavingPlans(account: account)
            }, label: {
                HStack {
                    Text("savingsplans_for_home_title".localized)
                        .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                        .font(.semiBoldCustom(size: 22))
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .foregroundColor(HelperManager().getAppTheme().color)
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                }
            })
            .padding(.horizontal)
            .padding(.top)
            
            if account.savingPlans.count != 0 {
                HStack {
                    LazyVGrid(columns: layout, alignment: .center) {
                        ForEach(account.savingPlans.prefix(numberOfSavingPlansDisplayedInHomeScreen)) { savingPlan in
                            Button(action: {
                                router.pushSavingPlansDetail(savingPlan: savingPlan)
                            }, label: {
                                CellSavingPlanView(savingPlan: savingPlan)
                            })
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
                        
                        Image("NoSavingPlan\(themeSelected)")
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
                    router.presentCreateSavingPlans()
                }
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    SavingPlansForHomeScreen(
        router: .init(isPresented: .constant(.homeSavingPlans(account: Account.preview))),
        account: Account.preview
    )
}
