//
//  AddsCardsView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//
// Localizations 30/09/2023

import SwiftUI

struct AddAccountView: View {

    //Custom type
    @Binding var account: Account?
    
    //Environnements
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    //State or Binding String
    @State private var accountTitle: String = ""
    @State private var textFieldEmptyString: String = ""
    @State private var cardNumber: String = ""
    @State private var cardHolder: String = ""
    @State private var cardDate: String = ""
    @State private var cardCVV: String = ""

    //State or Binding Int, Float and Double
    @State private var textFieldEmptyDouble: Double = 0.0
    @State private var accountBalance: Double = 0.0
    @State private var cardLimit: Double = 0.0

    //State or Binding Bool

    //Enum
    
    //Computed var

    //MARK: - Body
    var body: some View {
        VStack {
            HStack {
                Text(NSLocalizedString("account_new", comment: ""))
                    .titleAdjustSize()
                
                Spacer()
                
                Button(action: { dismiss() }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.colorLabel)
                        .font(.system(size: 18, weight: .semibold))
                })
            }
            .padding([.horizontal, .top])
            
            CellAddCardView(textHeader: NSLocalizedString("account_name", comment: ""),
                            placeholder: NSLocalizedString("account_placeholder_name", comment: ""),
                            text: $accountTitle,
                            value: $textFieldEmptyDouble,
                            isNumberTextField: false)
            .padding(8)
            
            CellAddCardView(textHeader: NSLocalizedString("account_balance", comment: ""),
                            placeholder: NSLocalizedString("account_placeholder_balance", comment: ""),
                            text: $textFieldEmptyString,
                            value: $accountBalance,
                            isNumberTextField: true)
            .padding(8)
            .padding(.vertical)
            
            CellAddCardView(textHeader: NSLocalizedString("account_card_limit", comment: ""),
                            placeholder: NSLocalizedString("account_placeholder_card_limit", comment: ""),
                            text: $textFieldEmptyString,
                            value: $cardLimit,
                            isNumberTextField: true)
            .padding(8)
            
            Text(NSLocalizedString("account_info_credit_card", comment: ""))
                .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                .multilineTextAlignment(.center)
                .font(.semiBoldText16())
                .padding()
            
            Spacer()
            
            CreateButton(action: { createNewAccount() }, validate: valideAccount())
                .padding(.bottom)
        }
        .ignoresSafeArea(.keyboard)
        .padding(.horizontal, 8)
        .background((colorScheme == .light ? Color.primary0.edgesIgnoringSafeArea(.all) : Color.secondary500.edgesIgnoringSafeArea(.all)).onTapGesture { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) } )
    }//END body

    //MARK: Fonctions
    func valideAccount() -> Bool {
        if !accountTitle.isEmptyWithoutSpace() {
            return true
        }
        return false
    }
    
    func createNewAccount() {
        let newAccount = Account(context: viewContext)
        newAccount.id = UUID()
        newAccount.title = accountTitle
        newAccount.balance = accountBalance
        newAccount.cardLimit = cardLimit
        
        account = newAccount
        
        persistenceController.saveContext()
        
        dismiss()
    }
}//END struct

//MARK: - Preview
struct AddAccountView_Previews: PreviewProvider {
    
    @State static var account: Account? = previewAccount1()
    
    static var previews: some View {
        AddAccountView(account: $account)
    }
}
