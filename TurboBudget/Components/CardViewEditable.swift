//
//  CardViewEditable.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct CardViewEditable: View {
    
    //Custom type
    
    //Environnements
    
    //State or Binding String
    @Binding var cardNumber: String
    @Binding var cardHolder: String
    @Binding var cardDate: String
    
    //State or Binding Int, Float and Double
    
    //State or Binding Bool
    
    //Enum
    enum ActiveKeyboardField {
        case cardNumber, cardHolder, expirationDate
    }
    @FocusState private var activeKeyboardField: ActiveKeyboardField?
    
    //Computed var
    
    //MARK: - Body
    var body: some View {
        CardView()
    }//END body
    
    //MARK: Fonctions
    
    //MARK: ViewBuilder
    @ViewBuilder
    func CardView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill (
                    LinearGradient(colors: [HelperManager().getAppTheme().color, HelperManager().getAppTheme().color.darker(by: 30)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
            
            // Card Details Face
            VStack(spacing: 10) {
                HStack {
                    TextField("XXXX XXXX XXXX XXXX", text: .init(get: {
                        cardNumber
                    }, set: { value in
                        cardNumber = ""
                        
                        let startIndex = value.startIndex
                        for index in 0..<value.count {
                            let stringIndex = value.index(startIndex, offsetBy: index)
                            cardNumber += String(value[stringIndex])
                            
                            if (index + 1) % 5 == 0 && value[stringIndex] != " " {
                                cardNumber.insert(contentsOf: " ", at: stringIndex)
                            }
                        }
                        
                        cardNumber = String(cardNumber.prefix(19))
                    }))
                    .font(.semiBoldText18())
                    .keyboardType(.numberPad)
                    .focused($activeKeyboardField, equals: .cardNumber)
                    
                    Spacer(minLength: 0)
                    
                    Image("Visa")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                }
                
                Spacer(minLength: 0)
                
                HStack(spacing: 12) {
                    TextField("MM/YY", text: .init(get: {
                        cardDate
                    }, set: { value in
                        cardDate = value
                        
                        if value.count == 3 && !value.contains("/") {
                            let startIndex = value.startIndex
                            let thirdPosition = value.index(startIndex, offsetBy: 2)
                            cardDate.insert("/", at: thirdPosition)
                        }
                        
                        if value.last == "/" { cardDate.removeLast() }
                        
                        cardDate = String(cardDate.prefix(5))
                    }))
                    .font(Font.mediumText16())
                    .keyboardType(.numberPad)
                    .focused($activeKeyboardField, equals: .expirationDate)
                    
                    Spacer(minLength: 0)
                }
                
                Spacer(minLength: 0)
                
                TextField("card_editable_holder".localized, text: $cardHolder)
                    .font(Font.mediumText16())
                    .focused($activeKeyboardField, equals: .cardHolder)
                    .textCase(.uppercase)
            }
            .padding(20)
            .foregroundColor(.white)
        }
        .frame(height: 200)
    }
}//END struct

//MARK: - Preview
struct CardViewEditable_Previews: PreviewProvider {
    
    @State static private var cardNumber: String = ""
    @State static private var cardHolder: String = ""
    @State static private var cardDate: String = ""
    
    static var previews: some View {
        CardViewEditable(cardNumber: $cardNumber, cardHolder: $cardHolder, cardDate: $cardDate)
    }
}


