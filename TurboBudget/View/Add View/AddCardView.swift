//
//  AddCardView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 20/06/2023.
//
// Localizations 30/09/2023

import SwiftUI

struct AddCardView: View {

    //Custom type
    @Binding var account: Account?

    //Environnements
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) private var viewContext

    //State or Binding String
    @State private var textFieldEmptyString: String = ""
    @State private var cardNumber: String = ""
    @State private var cardHolder: String = ""
    @State private var cardDate: String = ""

    //State or Binding Int, Float and Double

    //State or Binding Bool
    @State private var isScannerPresented = false

	//Enum
	
	//Computed var

    //MARK: - Body
    var body: some View {
        VStack {
            DismissButtonInSheet()
            
            CardViewEditable(cardNumber: $cardNumber, cardHolder: $cardHolder, cardDate: $cardDate)
                .padding([.horizontal, .bottom], 8)
            
            Text(NSLocalizedString("card_no_cvv", comment: ""))
                .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                .multilineTextAlignment(.center)
                .font(.semiBoldText16())
                .padding()
            
            Spacer()
            
            Button(action: {
                self.isScannerPresented = true
            }, label: {
                ZStack {
                    Capsule()
                        .frame(height: 60)
                        .foregroundColor(.colorLabel)
                    HStack {
                        Spacer()
                        Image(systemName: "barcode.viewfinder")
                            .font(.system(size: 22, weight: .medium))
                        Text(NSLocalizedString("card_scan_button", comment: ""))
                            .font(.semiBoldCustom(size: 20))
                        Spacer()
                    }
                    .foregroundColor(.colorLabelInverse)
                }
            })
            .padding(.horizontal, 8)
            .sheet(isPresented: $isScannerPresented) {
                ScannerCreditCardView { cardNumber, date, errorMessage in
                    self.cardNumber = cardNumber ?? ""
                    self.cardDate = date ?? ""
                }
            }
            
            CreateButton(action: { createNewCard() }, validate: valideCard())
                .padding(.bottom)
        }
        .ignoresSafeArea(.keyboard)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    EmptyView()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(action: {
                        UIApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }, label: { Image(systemName: "keyboard.chevron.compact.down.fill").foregroundColor(HelperManager().getAppTheme().color) })
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.horizontal, 8)
        .background(Color.color2Apple.edgesIgnoringSafeArea(.all).onTapGesture { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        })
    }//END body

    //MARK: Fonctions
    func valideCard() -> Bool {
        if cardNumber.count == 19 && cardDate.count == 5 && !cardHolder.isEmptyWithoutSpace() {
            return true
        }
        return false
    }
    
    func createNewCard() {
        let newCard = Card(context: viewContext)
        newCard.id = UUID()
        newCard.holder = cardHolder
        newCard.number = cardNumber
        newCard.date = cardDate
        newCard.cardToAccount = account
        
        persistenceController.saveContext()
        
        dismiss()
    }
} //END struct

//MARK: - Preview
struct AddCardView_Previews: PreviewProvider {
    
    @State static var previewAccount: Account? = previewAccount1()
    
    static var previews: some View {
        AddCardView(account: $previewAccount)
    }
}
