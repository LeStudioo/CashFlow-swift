//
//  AlertsView.swift
//  CashFlow
//
//  Created by KaayZenn on 06/08/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct AlertsView: View {

    //Custom type
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared

    //Environnements
    @Environment(\.dismiss) private var dismiss

    //State or Binding String

    //State or Binding Int, Float and Double

    //State or Binding Bool
    var isAccountWillBeNegative: Bool
    var isCardLimitExceeds: Bool
    var isBudgetIsExceeded: Bool?
    var isStartTallerThanEnd: Bool?
    
    var isDuplicateTransactions: Bool?

	//Enum
    enum AlertEnum: Int, CaseIterable {
        case accountNegative, cardLimitExceed, budgetExceed, startTallerThanEnd, isDuplicate
    }
	
	//Computed var

    //MARK: - Body
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                if isAccountWillBeNegative {
                    cardAlert(id: .accountNegative, text: NSLocalizedString("alerts_no_negative_balance", comment: ""))
                }
                if isCardLimitExceeds {
                    cardAlert(id: .cardLimitExceed, text: NSLocalizedString("alerts_no_card_limit_exceeded", comment: ""))
                }
                if let isBudgetIsExceeded, isBudgetIsExceeded {
                    cardAlert(id: .budgetExceed, text: NSLocalizedString("alerts_no_bugets_exceeded", comment: ""))
                }
                if let isStartTallerThanEnd, isStartTallerThanEnd {
                    cardAlert(id: .startTallerThanEnd, text: NSLocalizedString("alerts_amount_savingsplan", comment: ""))
                }
                if let isDuplicateTransactions, isDuplicateTransactions {
                    cardAlert(id: .isDuplicate, text: NSLocalizedString("alerts_duplicate_found", comment: ""))
                }
            }
        }
        .background(Color.color2Apple.edgesIgnoringSafeArea(.all))
        .navigationTitle(NSLocalizedString("alerts_title", comment: ""))
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.colorLabel)
                        .font(.system(size: 18, weight: .semibold))
                })
            }
        }
    }//END body
    
    //MARK: ViewBuilder
    @ViewBuilder
    func cardAlert(id: AlertEnum, text: String) -> some View {
        VStack(alignment: .leading) {
            Text("⚠️ " + text)
                .font(Font.mediumText16())
                .multilineTextAlignment(.leading)
                .lineSpacing(4)
                .padding(.horizontal, 8)
            HStack {
                Group {
                    if id == .accountNegative {
                        Toggle(isOn: $userDefaultsManager.accountCanBeNegative, label: {
                            Text(NSLocalizedString("alerts_no_negative_balance_title", comment: ""))
                        })
                    } else if id == .cardLimitExceed {
                        Toggle(isOn: $userDefaultsManager.blockExpensesIfCardLimitExceeds, label: {
                            Text(NSLocalizedString("alerts_no_card_limit_exceeded_title", comment: ""))
                        })
                    } else if id == .budgetExceed {
                        Toggle(isOn: $userDefaultsManager.blockExpensesIfBudgetAmountExceeds, label: {
                            Text(NSLocalizedString("alerts_no_bugets_exceeded_title", comment: ""))
                        })
                    } else if id == .startTallerThanEnd {
                        EmptyView().frame(height: 0)
                    } else if id == .isDuplicate {
                        Toggle(isOn: $userDefaultsManager.isSearchDuplicateEnable, label: {
                            Text(NSLocalizedString("alerts_duplicate_found", comment: ""))
                        })
                    }
                }
                .font(Font.mediumText16())
                .padding(8)
                .padding(.trailing, 4)
                .background(Color.color2Apple)
                .cornerRadius(12)
                .padding(8)
                Spacer(minLength: 0)
            }
        }
        .padding(8)
        .background(Color.colorCell)
        .cornerRadius(15)
        .padding(8)
        .padding(.horizontal, 2)
    }

    //MARK: Fonctions

}//END struct

//MARK: - Preview
struct AlertsView_Previews: PreviewProvider {
    static var previews: some View {
        AlertsView(isAccountWillBeNegative: true, isCardLimitExceeds: true, isBudgetIsExceeded: true)
    }
}
