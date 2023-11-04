//
//  SavingPlansForHomeScreen.swift
//  CashFlow
//
//  Created by KaayZenn on 21/07/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct SavingPlansForHomeScreen: View {
    
    //Custom type
    @Binding var account: Account?
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    
    //Environnements
    @Environment(\.colorScheme) private var colorScheme
    
    //State or Binding String
    
    //State or Binding Int, Float and Double
    
    //State or Binding Bool
    @Binding var update: Bool
    @State private var showAddSavingPlan: Bool = false
    
    //Enum
    
    //Computed var
    
    //Other
    private let layout: [GridItem] = [GridItem(.flexible(minimum: 40), spacing: 20), GridItem(.flexible(minimum: 40), spacing: 20)]
    
    //MARK: - Body
    var body: some View {
        if let account {
            VStack {
                NavigationLink(destination: {
                    SavingPlansHomeView(account: $account, update: $update)
                }, label: {
                    HStack {
                        Text(NSLocalizedString("savingsplans_for_home_title", comment: ""))
                            .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                            .font(.semiBoldCustom(size: 22))
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(HelperManager().getAppTheme().color)
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                    }
                    .padding(.horizontal)
                    .padding(.top)
                })
                
                if account.savingPlans.count != 0 {
                    HStack {
                        LazyVGrid(columns: layout, alignment: .center) {
                            ForEach(account.savingPlans.prefix(userDefaultsManager.numberOfSavingPlansDisplayedInHomeScreen)) { savingPlan in
                                NavigationLink(destination: {
                                    SavingPlanDetailView(savingPlan: savingPlan, update: $update)
                                }, label: {
                                    CellSavingPlanView(savingPlan: savingPlan, update: $update)
                                })
                                .padding(.bottom)
                            }
                        }
                        .padding(.horizontal)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(NSLocalizedString("savingsplans_for_home_no_savings_plan", comment: ""))
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
                    .onTapGesture { showAddSavingPlan.toggle() }
                }
            }
            .padding(update ? 0 : 0)
            .sheet(isPresented: $showAddSavingPlan, onDismiss: { update.toggle() }, content: { AddSavingPlanView(account: $account) })
        }
    }//END body
    
    //MARK: Fonctions
    
}//END struct

//MARK: - Preview
struct SavingPlansForHomeScreen_Previews: PreviewProvider {
    
    @State static var previewUpdate: Bool = false
    @State static var previewAccount: Account? = previewAccount1()
    
    static var previews: some View {
        SavingPlansForHomeScreen(account: $previewAccount, update: $previewUpdate)
    }
}
