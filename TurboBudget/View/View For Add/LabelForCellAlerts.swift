//
//  LabelForCellAlerts.swift
//  CashFlow
//
//  Created by KaayZenn on 06/08/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct LabelForCellAlerts: View {

    //Custom type

    //Environnements

    //State or Binding String

    //State or Binding Int, Float and Double
    var numberOfAlert: Int

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
                Text("⚠️")
                Text(numberOfAlert == 1 ? NSLocalizedString("word_alert", comment: "") : NSLocalizedString("word_alerts", comment: ""))
                Spacer()
                Text(String(numberOfAlert))
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
struct LabelForCellAlerts_Previews: PreviewProvider {
    static var previews: some View {
        LabelForCellAlerts(numberOfAlert: 1)
    }
}
