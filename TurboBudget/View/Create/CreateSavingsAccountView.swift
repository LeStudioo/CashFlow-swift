//
//  CreateSavingsAccountView.swift
//  CashFlow
//
//  Created by KaayZenn on 15/03/2024.
//

import SwiftUI

struct CreateSavingsAccountView: View {
    
    // Custom
    @StateObject private var viewModel = CreateSavingsAccountViewModel()
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    
    // Preferences
    @Preference(\.hapticFeedback) private var hapticFeedback
    
    // MARK: - body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    CellAddCardView(
                        textHeader: "account_name".localized,
                        placeholder: "savingsAccount_placeholder_name".localized,
                        text: $viewModel.accountTitle
                    )
                    
                    CellAddCardView(
                        textHeader: "account_balance".localized,
                        placeholder: "account_placeholder_balance".localized,
                        text: $viewModel.accountBalance
                    )
                    .keyboardType(.decimalPad)
                    
                    CellAddCardView(
                        textHeader: "savingsAccount_maxAmount".localized,
                        placeholder: "savingsAccount_placeholder_balance".localized,
                        text: $viewModel.accountMaxAmount
                    )
                    .keyboardType(.decimalPad)
                }
                .padding(.top, 32)
            } // End ScrollView
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .padding(.horizontal)
            .navigationTitle("savingsAccount_create_title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarDismissButtonView {
                    if viewModel.isSavingsAccountInCreation() {
                        viewModel.presentingConfirmationDialog.toggle()
                    } else {
                        dismiss()
                    }
                }
                
                ToolbarCreateButtonView(isActive: viewModel.isSavingsAccountValid()) {
                    viewModel.createSavingsAccount()
                    dismiss()
                    if hapticFeedback {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                }
                
                ToolbarDismissKeyboardButtonView()
            }
        } // End NavigationStack
        .interactiveDismissDisabled(viewModel.isSavingsAccountInCreation()) {
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
    CreateSavingsAccountView()
}
