//
//  AdviceView.swift
//  CashFlow
//
//  Created by KaayZenn on 29/08/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct AdviceView: View {

    //Custom type
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared

    //Environnements
    @Environment(\.dismiss) private var dismiss

    //State or Binding String

    //State or Binding Int, Float and Double

    //State or Binding Bool

	//Enum
    enum AdviceEnum: Int, CaseIterable {
        case payingYourselfFirst
    }
	
	//Computed var

    //MARK: - Body
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                if userDefaultsManager.isPayingYourselfFirstEnable {
                    cardAlert(id: .payingYourselfFirst, text: NSLocalizedString("advice_yourself_desc", comment: ""))
                }
            }
        }
        .background(Color.color2Apple.edgesIgnoringSafeArea(.all))
        .navigationTitle("word_financial_advice")
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
    func cardAlert(id: AdviceEnum, text: String) -> some View {
        VStack(alignment: .leading) {
            Text("💰 " + text)
                .font(Font.mediumText16())
                .multilineTextAlignment(.leading)
                .lineSpacing(4)
                .padding(.horizontal, 8)
            HStack {
                Group {
                    if id == .payingYourselfFirst {
                        Toggle(isOn: $userDefaultsManager.isPayingYourselfFirstEnable, label: {
                            Text(NSLocalizedString("advice_yourself", comment: ""))
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
struct AdviceView_Previews: PreviewProvider {
    static var previews: some View {
        AdviceView()
    }
}
