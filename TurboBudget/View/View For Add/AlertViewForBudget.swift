//
//  AlertViewForBudget.swift
//  CashFlow
//
//  Created by KaayZenn on 17/08/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct AlertViewForBudget: View {

    //Custom type
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared

    //Environnements
    @Environment(\.dismiss) private var dismiss

    //State or Binding String

    //State or Binding Int, Float and Double

    //State or Binding Bool
    var isBudgetAlredayExist: Bool

    //Enum
    enum AlertForBudgetEnum: Int, CaseIterable {
        case alreadyExist
    }
    
    //Computed var

    //MARK: - Body
    var body: some View {
        VStack {
            HStack {
                Spacer(minLength: 0)
                ScrollView(showsIndicators: false) {
                    if isBudgetAlredayExist {
                        cardAlert(id: .alreadyExist, text: NSLocalizedString("alerts_budget_already_exist", comment: ""))
                    }
                }
                Spacer(minLength: 0)
            }
        }
        .background(Color.color2Apple.edgesIgnoringSafeArea(.all))
        .navigationTitle("alerts_title")
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
    func cardAlert(id: AlertForBudgetEnum, text: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("⚠️ " + text)
                .font(Font.mediumText16())
                .multilineTextAlignment(.leading)
                .lineSpacing(4)
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
struct AlertViewForBudget_Previews: PreviewProvider {
    static var previews: some View {
        AlertViewForBudget(isBudgetAlredayExist: true)
    }
}
