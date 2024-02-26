//
//  QRCodeForTransactionSheetView.swift
//  CashFlow
//
//  Created by KaayZenn on 02/08/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct QRCodeForTransactionSheetView: View {

    //Custom type

    //Environnements

    //State or Binding String

    //State or Binding Int, Float and Double

    //State or Binding Bool
    
    //State or Binding Data
    var qrcode: Data

	//Enum
	
	//Computed var

    //MARK: - Body
    var body: some View {
        VStack {
            DismissButtonInSheet()
            
            Text("qrcode_transactions_share".localized)
                .titleAdjustSize()
            
            Image(uiImage: UIImage(data: qrcode)!)
                            .resizable()
                            .frame(width: 200, height: 200)
            
            Text("qrcode_transactions_how".localized)
                .titleAdjustSize()
                .multilineTextAlignment(.center)
            
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("qrcode_recover_transactions".localized)
                }
                .font(Font.mediumText16())
                .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(8)
            
            Spacer()
        }
        .foregroundColor(.colorLabel)
    }//END body

    //MARK: Fonctions

}//END struct

//MARK: - Preview
struct QRCodeForTransactionSheetView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeForTransactionSheetView(qrcode: Data())
    }
}
