//
//  LabelForCellAdvice.swift
//  CashFlow
//
//  Created by KaayZenn on 29/08/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct LabelForCellAdvice: View {

    //Custom type

    //Environnements

    //State or Binding String

    //State or Binding Int, Float and Double

    //State or Binding Bool
    var colorCell: Bool?

	//Enum
	
	//Computed var

    //MARK: - Body
    var body: some View {
        ZStack {
            Capsule()
                .frame(height: isLittleIphone ? 40 : 50)
                .foregroundColor(colorCell ?? false ? Color.colorCell : Color.color3Apple)
            
            HStack {
                Text("💰")
                Text(NSLocalizedString("word_financial_advice", comment: ""))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
            }
            .padding(.horizontal)
        }
        .foregroundColor(.colorLabel)
        .font(Font.mediumText16())
        .padding(.horizontal)
    }//END body

    //MARK: Fonctions

}//END struct

//MARK: - Preview
struct LabelForCellAdvice_Previews: PreviewProvider {
    static var previews: some View {
        LabelForCellAdvice()
    }
}
