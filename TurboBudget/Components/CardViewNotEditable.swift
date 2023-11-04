//
//  CardViewNotEditable.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct CardViewNotEditable: View {
    
    //Custom type
    
    //Environnements
    
    //State or Binding String
    var cardNumber: String
    var cardHolder: String
    var cardDate: String
    
    //State or Binding Int, Float and Double
    
    //State or Binding Bool
    
    //Enum
    
    //Computed var
    
    //MARK: - Body
    var body: some View {
        CardViewNotEditable()
    }//END body
    
    //MARK: Fonctions
    
    //MARK: ViewBuilder
    @ViewBuilder
    func CardViewNotEditable() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill (
                    LinearGradient(colors: [HelperManager().getAppTheme().color, HelperManager().getAppTheme().color.darker(by: 30)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
            
            // Card Details
            VStack(spacing: 10) {
                HStack {
                    Text(cardNumber)
                        .font(.semiBoldText18())
                    
                    Spacer(minLength: 0)
                    
                    Image("Visa")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                }
                
                Spacer(minLength: 0)
                
                HStack(spacing: 12) {
                    Text(cardDate)
                        .font(Font.mediumText16())
                    
                    Spacer(minLength: 0)
                }
                
                Spacer(minLength: 0)
                
                HStack {
                    Text(cardHolder)
                        .font(Font.mediumText16())
                        .textCase(.uppercase)
                    Spacer()
                }
            }
            .padding(20)
            .foregroundColor(.white)
            .tint(.white)
        }
        .frame(height: 200)
    }
    
}//END struct

//MARK: - Preview
struct CardViewNotEditable_Previews: PreviewProvider {
    static var previews: some View {
        CardViewNotEditable(cardNumber: "1234 1234 1234 1234", cardHolder: "Theo's Account", cardDate: "01/24")
    }
}
