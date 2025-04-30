//
//  CreateTransferView.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/11/2024.
//

import SwiftUI

struct CreateTransferView: View {
    
    // Builder
    @StateObject private var viewModel: CreateTransferViewModel
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    
    // init
    init(receiverAccount: AccountModel? = nil) {
        self._viewModel = StateObject(wrappedValue: .init(receiverAccount: receiverAccount))
    }
    
    // MARK: -
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                VStack(spacing: 24) {
                    CustomTextField(
                        text: $viewModel.amount,
                        config: .init(
                            title: Word.Classic.amount,
                            placeholder: "500.00",
                            style: .amount
                        )
                    )
                    
                    CustomDatePicker(
                        title: Word.Classic.date,
                        date: $viewModel.date
                    )
                    
                    AccountPicker(
                        title: Word.Classic.senderAccount,
                        selected: $viewModel.senderAccount
                    )
                    
                    AccountPicker(
                        title: Word.Classic.receiverAccount,
                        selected: $viewModel.receiverAccount
                    )
                }
                
                if !viewModel.amount.isBlank {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Montant après transaction") // TODO: TBL
                            .font(.mediumH3())
                            .fullWidth(.leading)
                        
                        let amount = viewModel.amount.toDouble()
                        if let senderAccount = viewModel.senderAccount {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(senderAccount.name)
                                    .font(.mediumText16())
                                    .foregroundStyle(themeManager.theme.color)
                                Text((senderAccount.balance - amount).toCurrency())
                                    .font(.boldText18())
                                    .contentTransition(.numericText())
                            }
                        }
                        
                        if let receiverAccount = viewModel.receiverAccount {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(receiverAccount.name)
                                    .font(.mediumText16())
                                    .foregroundStyle(themeManager.theme.color)
                                Text((receiverAccount.balance + amount).toCurrency())
                                    .font(.boldText18())
                                    .contentTransition(.numericText())
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top)
        } // End ScrollView
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            ToolbarDismissButtonView {
                if viewModel.isTransferInCreation() {
                    viewModel.presentingConfirmationDialog.toggle()
                } else {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text(Word.Title.Transfer.new)
                    .font(.system(size: UIDevice.isLittleIphone ? 16 : 18, weight: .medium))
            }
            
            ToolbarValidationButtonView(
                type: .creation,
                isActive: viewModel.isTransferValid()
            ) {
                VibrationManager.vibration()
                await viewModel.createTransfer(dismiss: dismiss)
            }
            
            ToolbarDismissKeyboardButtonView()
        }
        .interactiveDismissDisabled(viewModel.isTransferInCreation()) {
            viewModel.presentingConfirmationDialog.toggle()
        }
        .confirmationDialog("", isPresented: $viewModel.presentingConfirmationDialog) {
            Button("word_cancel_changes".localized, role: .destructive, action: { dismiss() })
            Button("word_return".localized, role: .cancel, action: { })
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .bottom)
    } // body
} // struct

// MARK: - Preview
#Preview {
    CreateTransferView()
}
