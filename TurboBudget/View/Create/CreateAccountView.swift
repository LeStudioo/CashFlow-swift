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
    
    // Builder
    var type: AccountType
    
    @StateObject private var viewModel: CreateAccountViewModel
    @EnvironmentObject private var accountRepository: AccountRepository
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    
    // init
    init(type: AccountType) {
        self.type = type
        self._viewModel = StateObject(wrappedValue: .init(type: type))
    }
    
    // MARK: -
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                HStack {
                    Text("account_new".localized)
                        .titleAdjustSize()
                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                    Button(action: { dismiss() }, label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color(uiColor: .label))
                            .font(.system(size: 18, weight: .semibold))
                    })
                }
                .padding(.top)
                
                VStack(spacing: 24) {
                    CustomTextField(
                        text: $viewModel.name,
                        config: .init(
                            title: "account_name".localized,
                            placeholder: "account_placeholder_name".localized
                        )
                    )
                    
                    CustomTextField(
                        text: $viewModel.balance,
                        config: .init(
                            title: "account_balance".localized,
                            placeholder: "account_placeholder_balance".localized,
                            style: .amount
                        )
                    )
                    
                    if type == .savings {
                        CustomTextField(
                            text: $viewModel.maxAmount,
                            config: .init(
                                title: Word.Classic.maxAmount,
                                placeholder: "account_placeholder_maxAmount".localized,
                                style: .amount
                            )
                        )
                    }
                }
                
//                if type == .classic {
//                    Text("account_info_credit_card".localized)
//                        .foregroundStyle(Color.customGray)
//                        .multilineTextAlignment(.center)
//                        .font(.semiBoldText16())
//                }
            }
        } // End ScrollView
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.immediately)
        .ignoresSafeArea(.keyboard)
        .overlay(alignment: .bottom) {
            CreateButton(
                action: { viewModel.createAccount(dismiss: dismiss) },
                validate: viewModel.isAccountValid()
            )
            .padding(.bottom)
        }
        .padding(.horizontal, 24)
        .interactiveDismissDisabled(viewModel.isAccountInCreation()) {
            viewModel.presentingConfirmationDialog.toggle()
        }
        .confirmationDialog("", isPresented: $viewModel.presentingConfirmationDialog) {
            Button("word_cancel_changes".localized, role: .destructive, action: { dismiss() })
            Button("word_return".localized, role: .cancel, action: { })
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    CreateAccountView(type: .savings)
        .environmentObject(AccountRepository())
}
