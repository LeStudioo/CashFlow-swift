//
//  CreateCreditCardView.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/12/2024.
//

import SwiftUI

struct CreateCreditCardView: View {
    
    @StateObject private var viewModel: CreateCreditCardViewModel = .init()
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: -
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    CreditCardTextField(
                        text: $viewModel.cardNumbers,
                        config: .init(
                            title: Word.CreditCard.numbers,
                            placeholder: "1234 5678 9012 3456"
                        )
                    )
                    
                    CustomTextField(
                        text: $viewModel.cardHolder,
                        config: .init(
                            title: Word.CreditCard.holder,
                            placeholder: "Theo Sementa"
                        )
                    )
                    
                    CustomDatePicker(
                        title: Word.CreditCard.date,
                        date: $viewModel.expirationDate
                    )
                    
                    IntTextField(
                        text: $viewModel.cvv.max(3),
                        config: .init(
                            title: Word.CreditCard.cvv,
                            placeholder: "123"
                        )
                    )
                    
                    CustomTextField(
                        text: $viewModel.limitByMonth,
                        config: .init(
                            title: Word.CreditCard.limit,
                            placeholder: "1500",
                            style: .amount
                        )
                    )
                    
                    Text(Word.CreditCard.security)
                        .font(.footnote)
                }
                .padding(.horizontal, 24)
                .padding(.top)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarDismissButtonView {
                    if viewModel.isCreditCardInCreation() {
                        viewModel.presentingConfirmationDialog.toggle()
                    } else {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(Word.Title.CreditCard.new)
                        .font(.system(size: UIDevice.isLittleIphone ? 16 : 18, weight: .medium))
                }
                
                ToolbarValidationButtonView(
                    type: .creation,
                    isActive: viewModel.isCreditCardValid()
                ) {
                    VibrationManager.vibration()
                    viewModel.createCreditCard(dismiss: dismiss)
                }
                
                ToolbarDismissKeyboardButtonView()
            }
        } // NavigationStack
        .interactiveDismissDisabled(viewModel.isCreditCardInCreation()) {
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
    CreateCreditCardView()
}
