//
//  AddsCardsView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//
// Localizations -> 30/09/2023
// Refactor -> 17/02/2024

import SwiftUI
import CoreModule
import TheoKit
import DesignSystemModule
import NetworkKit

struct AccountAddScreen: View {
    
    // Builder
    var type: AccountType
    var account: AccountModel?
    
    @StateObject private var viewModel: ViewModel
    @EnvironmentObject private var accountStore: AccountStore
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    
    // init
    init(type: AccountType, account: AccountModel? = nil) {
        self.type = type
        self.account = account
        self._viewModel = StateObject(wrappedValue: .init(type: type, account: account))
    }
    
    // MARK: -
    var body: some View {
//        ScrollView {

//        } // End ScrollView
//        .scrollIndicators(.hidden)
//        .scrollDismissesKeyboard(.interactively)
//        .ignoresSafeArea(.keyboard)
//        .overlay(alignment: .bottom) {
//            CreateButton(
//                type: account == nil ? .creation : .edition,
//                isActive: viewModel.isAccountValid()
//            ) {
//                if account != nil {
//                    await viewModel.updateAccount(dismiss: dismiss)
//                } else {
//                    await viewModel.createAccount(dismiss: dismiss)
//                }
//            }
//            .padding(.bottom)
//        }
//        .padding(.horizontal, 24)
//        .interactiveDismissDisabled(viewModel.isAccountInCreation()) {
//            viewModel.presentingConfirmationDialog.toggle()
//        }
//        .confirmationDialog("", isPresented: $viewModel.presentingConfirmationDialog) {
//            Button("word_cancel_changes".localized, role: .destructive, action: { dismiss() })
//            Button("word_return".localized, role: .cancel, action: { })
//        }
//        .navigationBarBackButtonHidden(true)
//        .navigationBarTitleDisplayMode(.inline)
        
        BetterScrollView(maxBlurRadius: Blur.topbar) {
            NavigationBar(
                title: account == nil ? Word.Title.Account.new : Word.Title.Account.update,
                actionButton: .init(
                    title: account == nil ? Word.Classic.create : Word.Classic.edit,
                    action: {
                        NetworkService.cancelAllTasks()
                        VibrationManager.vibration()
                        if account == nil {
                            await viewModel.createAccount(dismiss: dismiss)
                        } else {
                            await viewModel.updateAccount(dismiss: dismiss)
                        }
                    },
                    isDisabled: !viewModel.isAccountValid()
                ),
                dismissAction: {
                    if viewModel.isAccountInCreation() {
                        viewModel.presentingConfirmationDialog.toggle()
                    } else {
                        dismiss()
                    }
                }
            )
        } content: { _ in
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
            .padding(.horizontal, 24)
        }
        .toolbar {
            ToolbarDismissKeyboardButtonView()
        }
        .confirmationDialog("", isPresented: $viewModel.presentingConfirmationDialog) {
            Button("word_cancel_changes".localized, role: .destructive, action: { dismiss() })
            Button("word_return".localized, role: .cancel, action: { })
        }
        .background(TKDesignSystem.Colors.Background.Theme.bg50.ignoresSafeArea(.all))
        .navigationBarBackButtonHidden(true)
    } // body
} // struct

// MARK: - Preview
#Preview {
    AccountAddScreen(type: .savings)
        .environmentObject(AccountStore())
}
