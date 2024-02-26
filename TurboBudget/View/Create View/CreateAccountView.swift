//
//  AddsCardsView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//
// Localizations -> 30/09/2023
// Refactor -> 17/02/2024

import SwiftUI

struct CreateAccountView: View {

    // Custom type
    @Binding var account: Account?
    @StateObject private var viewModel: CreateAccountViewModel = CreateAccountViewModel()
    
    // Environement
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - body
    var body: some View {
        VStack {
            HStack {
                Text("account_new".localized)
                    .titleAdjustSize()
                
                Spacer()
                
                Button(action: { dismiss() }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.colorLabel)
                        .font(.system(size: 18, weight: .semibold))
                })
            }
            .padding([.horizontal, .top])
            
            CellAddCardView(textHeader: "account_name".localized,
                            placeholder: "account_placeholder_name".localized,
                            text: $viewModel.accountTitle,
                            value: $viewModel.textFieldEmptyDouble,
                            isNumberTextField: false
            )
            .padding(8)
            
            CellAddCardView(textHeader: "account_balance".localized,
                            placeholder: "account_placeholder_balance".localized,
                            text: $viewModel.textFieldEmptyString,
                            value: $viewModel.accountBalance,
                            isNumberTextField: true
            )
            .padding(8)
            .padding(.vertical)
            
            CellAddCardView(textHeader: "account_card_limit".localized,
                            placeholder: "account_placeholder_card_limit".localized,
                            text: $viewModel.textFieldEmptyString,
                            value: $viewModel.cardLimit,
                            isNumberTextField: true
            )
            .padding(8)
            
            Text("account_info_credit_card".localized)
                .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                .multilineTextAlignment(.center)
                .font(.semiBoldText16())
                .padding()
            
            Spacer()
            
            CreateButton(action: {
                viewModel.createNewAccount(account: $account)
                dismiss()
            }, validate: viewModel.valideAccount())
                .padding(.bottom)
        }
        .ignoresSafeArea(.keyboard)
        .padding(.horizontal, 8)
        .background(
            (colorScheme == .light
             ? Color.primary0.edgesIgnoringSafeArea(.all)
             : Color.secondary500.edgesIgnoringSafeArea(.all)
            )
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        )
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CreateAccountView(account: .constant(Account.preview))
}
