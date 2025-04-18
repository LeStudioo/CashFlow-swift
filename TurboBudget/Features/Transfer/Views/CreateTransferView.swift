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
    
    // init
    init(receiverAccount: AccountModel? = nil) {
        self._viewModel = StateObject(wrappedValue: .init(receiverAccount: receiverAccount))
    }
    
    // MARK: -
    var body: some View {
        NavigationStack {
            ScrollView {
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
                .padding(.horizontal, 24)
                .padding(.top)
            } // End ScrollView
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .navigationBarTitleDisplayMode(.inline)
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
        } // NavigationStack
        .interactiveDismissDisabled(viewModel.isTransferInCreation()) {
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
    CreateTransferView()
}
