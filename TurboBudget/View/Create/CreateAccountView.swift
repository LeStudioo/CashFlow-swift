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
    
    @StateObject private var viewModel: CreateAccountViewModel = .init()
    @EnvironmentObject private var accountRepository: AccountRepository
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - body
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
                }
                
                Text("account_info_credit_card".localized)
                    .foregroundStyle(Color.customGray)
                    .multilineTextAlignment(.center)
                    .font(.semiBoldText16())
            }
        } // End ScrollView
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.immediately)
        .ignoresSafeArea(.keyboard)
        .overlay(alignment: .bottom) {
            CreateButton(
                action: {
                    Task {
                        await accountRepository.createAccount(
                            body: .init(
                                name: viewModel.name,
                                balance: viewModel.balance.toDouble()
                            )
                        )
                        dismiss()
                    }
                },
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
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CreateAccountView()
        .environmentObject(AccountRepository())
}
