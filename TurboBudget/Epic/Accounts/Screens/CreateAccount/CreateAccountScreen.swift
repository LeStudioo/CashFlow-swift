//
//  AddsCardsView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//
// Localizations -> 30/09/2023
// Refactor -> 17/02/2024

import SwiftUI

struct CreateAccountScreen: View {
    
    // Builder
    var type: AccountType
    var account: AccountModel?
    var onboardingAction: (() async -> Void)?
    
    @StateObject private var viewModel: ViewModel
    @EnvironmentObject private var accountStore: AccountStore
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    
    // init
    init(type: AccountType, account: AccountModel? = nil, onboardingAction: (() async -> Void)? = nil) {
        self.type = type
        self.account = account
        self.onboardingAction = onboardingAction
        self._viewModel = StateObject(wrappedValue: .init(type: type, account: account))
    }
    
    // MARK: -
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                HStack {
                    Text(account == nil ? Word.Title.Account.new : Word.Title.Account.update)
                        .titleAdjustSize()
                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                    if onboardingAction == nil {
                        Button(action: { dismiss() }, label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(Color.text)
                                .font(.system(size: 18, weight: .semibold))
                        })
                    }
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
                    
                    if account == nil {
                        CustomTextField(
                            text: $viewModel.balance,
                            config: .init(
                                title: "account_balance".localized,
                                placeholder: "account_placeholder_balance".localized,
                                style: .amount
                            )
                        )
                    }
                    
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
            }
        } // End ScrollView
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .ignoresSafeArea(.keyboard)
        .overlay(alignment: .bottom) {
            CreateButton(
                type: account == nil ? .creation : .edition,
                isActive: viewModel.isAccountValid()
            ) {
                if account != nil {
                    await viewModel.updateAccount(dismiss: dismiss)
                } else {
                    if let onboardingAction {
                        await viewModel.createAccount()
                        await onboardingAction()
                    } else {
                        await viewModel.createAccount(dismiss: dismiss)
                    }
                }
            }
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
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    } // body
} // struct

// MARK: - Preview
#Preview {
    CreateAccountScreen(type: .savings)
        .environmentObject(AccountStore())
}
