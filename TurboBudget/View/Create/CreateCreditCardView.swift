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
                            title: "Card numbers",
                            placeholder: "1234 5678 9012 3456"
                        )
                    )
                    
                    CustomTextField(
                        text: $viewModel.cardHolder,
                        config: .init(
                            title: "Card holder",
                            placeholder: "Theo Sementa"
                        )
                    )
                    
                    CustomDatePicker(
                        title: "Expire date",
                        date: $viewModel.expirationDate
                    )
                    
                    CustomTextField(
                        text: $viewModel.cvv.max(3),
                        config: .init(
                            title: "CVV",
                            placeholder: "123"
                        )
                    )
                    
                    CustomTextField(
                        text: $viewModel.limitByMonth,
                        config: .init(
                            title: "Montant max par mois",
                            placeholder: "1500",
                            style: .amount
                        )
                    )
                    
                    Text("Les cartes de crédit de sont pas stockées sur nos serveurs. Elles sont stockées dans le Keychain de votre iPhone.")
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
                    Text("Nouvelle carte de crédit")
                        .font(.system(size: isLittleIphone ? 16 : 18, weight: .medium))
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
