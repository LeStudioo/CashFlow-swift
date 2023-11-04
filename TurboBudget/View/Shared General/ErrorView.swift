//
//  ErrorView.swift
//  CashFlow
//
//  Created by KaayZenn on 26/09/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct ErrorView: View {
    
    //Builder
    var searchResultsCount: Int
    var searchText: String
    var image: String
    var text: String

    //Custom type

    //Environnements

    //State or Binding String

    //State or Binding Int, Float and Double

    //State or Binding Bool

	//Enum
	
	//Computed var

    //MARK: - Body
    var body: some View {
        if searchResultsCount == 0 && !searchText.isEmpty {
            VStack(spacing: 20) {
                Image("NoResults\(themeSelected)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 4, y: 4)
                    .frame(width: isIPad ? (orientation.isLandscape ? UIScreen.main.bounds.width / 3 : UIScreen.main.bounds.width / 2) : UIScreen.main.bounds.width / 1.5 )
                
                if !searchText.isEmpty {
                    Text(NSLocalizedString("word_no_results", comment: "") + " '\(searchText)'")
                        .font(Font.mediumText16())
                        .multilineTextAlignment(.center)
                }
            }
            .offset(y: -20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            VStack(spacing: 20) {
                Image(image + themeSelected)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 4, y: 4)
                    .frame(width: isIPad ? (orientation.isLandscape ? UIScreen.main.bounds.width / 3 : UIScreen.main.bounds.width / 2) : UIScreen.main.bounds.width / 1.5 )
                
                Text(text)
                        .font(Font.mediumText16())
                        .multilineTextAlignment(.center)
            }
            .offset(y: -20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }//END body

    //MARK: Fonctions

}//END struct

//MARK: - Preview
struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(
            searchResultsCount: 0,
            searchText: "Test",
            image: "NoAutomation",
            text: "Error"
        )
    }
}
