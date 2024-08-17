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
    @StateObject private var viewModel: CreateAccountViewModel = CreateAccountViewModel()
    
    // Environment
    @Environment(\.dismiss) private var dismiss

    // MARK: - body
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        HStack {
                            Text("account_new".localized)
                                .titleAdjustSize()
                            
                            Spacer()
                            
                            Button(action: { dismiss() }, label: {
                                Image(systemName: "xmark")
                                    .foregroundStyle(Color(uiColor: .label))
                                    .font(.system(size: 18, weight: .semibold))
                            })
                        }
                        .padding([.horizontal, .top])
                        
                        CellAddCardView(
                            textHeader: "account_name".localized,
                            placeholder: "account_placeholder_name".localized,
                            text: $viewModel.accountTitle
                        )
                        .padding(8)
                        
                        CellAddCardView(
                            textHeader: "account_balance".localized,
                            placeholder: "account_placeholder_balance".localized,
                            text: $viewModel.accountBalance
                        )
                        .keyboardType(.decimalPad)
                        .padding(8)
                        .padding(.vertical)
                        
                        Text("account_info_credit_card".localized)
                            .foregroundStyle(Color.customGray)
                            .multilineTextAlignment(.center)
                            .font(.semiBoldText16())
                            .padding()
                        
                        Spacer()
                        
                        CreateButton(action: {
                            viewModel.createNewAccount()
                            dismiss()
                        }, validate: viewModel.valideAccount())
                        .padding(.bottom)
                    }
                    .frame(minHeight: geometry.size.height)
                } // End ScrollView
                .scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.immediately)
                .ignoresSafeArea(.keyboard)
                .padding(.horizontal)
            } // End GeometryReader
        } // End NavigationStack
        .interactiveDismissDisabled(viewModel.isAccountInCreation()) {
            viewModel.presentingConfirmationDialog.toggle()
        }
        .confirmationDialog("", isPresented: $viewModel.presentingConfirmationDialog) {
            Button("word_cancel_changes".localized, role: .destructive, action: { dismiss() })
            Button("word_return".localized, role: .cancel, action: { })
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CreateAccountView()
}
