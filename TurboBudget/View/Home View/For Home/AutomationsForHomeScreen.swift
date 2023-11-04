//
//  AutomationsForHomeScreen.swift
//  CashFlow
//
//  Created by KaayZenn on 21/07/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct AutomationsForHomeScreen: View {

    //Custom type
    @Binding var account: Account?
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    
    //Environnements
    @Environment(\.colorScheme) private var colorScheme

    //State or Binding String

    //State or Binding Int, Float and Double

    //State or Binding Bool
    @State private var showAddAutomation: Bool = false
    
	//Enum
	
	//Computed var
    var nbrAutoDisplayed: Int {
        return userDefaultsManager.numberOfAutomationsDisplayedInHomeScreen
    }
    
    //Binding update
    @Binding var update: Bool
    
    //MARK: - Body
    var body: some View {
        if let account {
            VStack {
                NavigationLink(destination: { AutomationsHomeView(account: $account, update: $update) }, label: {
                    HStack {
                        Text(NSLocalizedString("automations_for_home_title", comment: ""))
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
                
                if account.automations.count != 0 {
                    VStack {
                        ForEach(account.automations.prefix(nbrAutoDisplayed)) { automation in
                            if let transaction = automation.automationToTransaction {
                                NavigationLink(destination: {
                                    TransactionDetailView(transaction: transaction, update: $update)
                                }, label: {
                                    CellTransactionForAutomationView(transaction: transaction, update: $update)
                                })
                            }
                        }
                    }
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(NSLocalizedString("automations_for_home_no_auto", comment: ""))
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
                    .onTapGesture { showAddAutomation.toggle() }
                }
            }
            .sheet(isPresented: $showAddAutomation, onDismiss: { withAnimation { update.toggle() } }, content: { AddAutomationsView(account: $account) })
        }
    }//END body
}//END struct

//MARK: - Preview
struct AutomationsForHomeScreen_Previews: PreviewProvider {
    
    @State static var previewBool: Bool = false
    @State static var previewAccount: Account? = previewAccount1()
    
    static var previews: some View {
        AutomationsForHomeScreen(account: $previewAccount, update: $previewBool)
    }
}
