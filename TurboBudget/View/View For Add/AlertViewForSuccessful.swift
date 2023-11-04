//
//  AlertViewForSuccessful.swift
//  CashFlow
//
//  Created by KaayZenn on 16/08/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct AlertViewForSuccessful: View {

    //Custom type
    var account: Account
    var subcategory: PredefinedSubcategory?
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared

    //Environnements
    @Environment(\.dismiss) private var dismiss

    //State or Binding String

    //State or Binding Int, Float and Double

    //State or Binding Bool
    var isCardLimitSoonExceed: Bool
    var isCardLimitExceeded: Bool
    var isBudgetSoonExceed: Bool?
    var isBudgetExceeded: Bool?

	//Enum
    enum AlertForSuccessfulEnum: Int, CaseIterable {
        case cardLimitSoonExceed, cardLimitExceeded, budgetSoonExceed, budgetExceeded
    }
    
	//Computed var

    //MARK: - Body
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                if isCardLimitSoonExceed {
                    cardAlert(id: .cardLimitSoonExceed, text: NSLocalizedString("alerts_successful_card_limit_almost_exceeded", comment: ""))
                }
                if isCardLimitExceeded {
                    cardAlert(id: .cardLimitExceeded, text: NSLocalizedString("alerts_successful_card_limit_exceeded", comment: ""))
                }
                if let isBudgetSoonExceed, isBudgetSoonExceed {
                    cardAlert(id: .budgetSoonExceed, text: NSLocalizedString("alerts_successful_budget_almost_exceeded", comment: ""))
                }
                if let isBudgetExceeded, isBudgetExceeded {
                    cardAlert(id: .budgetExceeded, text: NSLocalizedString("alerts_successful_budget_exceeded", comment: ""))
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
    func cardAlert(id: AlertForSuccessfulEnum, text: String) -> some View {
        
        let percentage: Double = (account.amountOfExpensesInActualMonth() / account.cardLimit) * 100
        let stringPercentage = String(format: "%.0f", percentage)
        
        var percentageBudget: Double {
            var num: Double = 0.0
            if let subcategory, let budget = subcategory.budget {
                num = budget.actualAmountForMonth(month: .now) / budget.amount
                return num * 100
            } else { return 0 }
        }
        
        let stringPercentageBudget = String(format: "%.0f", percentageBudget)
        
        VStack(alignment: .leading, spacing: 6) {
            Text("⚠️ " + text)
                .font(Font.mediumText16())
                .multilineTextAlignment(.leading)
                .lineSpacing(4)
            
            if id == .cardLimitSoonExceed || id == .cardLimitExceeded {
                HStack {
                    Text(account.amountOfExpensesInActualMonth().currency + " / " + account.cardLimit.currency + " (\(stringPercentage)%)" )
                        .font(Font.mediumText16())
                        .foregroundColor(id == .cardLimitSoonExceed ? .yellow : .red)
                    Spacer()
                }
            }
            
            if id == .budgetSoonExceed || id == .budgetExceeded {
                if let subcategory, let budget = subcategory.budget {
                    HStack {
                        Text(budget.actualAmountForMonth(month: .now).currency + " / " + budget.amount.currency + " (\(stringPercentageBudget)%)" )
                            .font(Font.mediumText16())
                            .foregroundColor(id == .budgetSoonExceed ? .yellow : .red)
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(8)
        .background(Color.colorCell)
        .cornerRadius(15)
        .padding(8)
        .padding(.horizontal, 2)
    }

    //MARK: Fonctions

}//END struct

//MARK: - Preview
struct AlertViewForSuccessful_Previews: PreviewProvider {
    static var previews: some View {
        AlertViewForSuccessful(account: previewAccount1(), isCardLimitSoonExceed: true, isCardLimitExceeded: false)
    }
}
