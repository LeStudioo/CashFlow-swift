//
//  CreateTransferView.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/11/2024.
//

import SwiftUI
import StatsKit
import TheoKit

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
        BetterScrollView(maxBlurRadius: DesignSystem.Blur.topbar) {
            NavigationBar(
                title: Word.Title.Transfer.new,
                actionButton: .init(
                    title: Word.Classic.create,
                    action: {
                        VibrationManager.vibration()
                        await viewModel.createTransfer(dismiss: dismiss)
                    },
                    isDisabled: !viewModel.isTransferValid()
                ),
                dismissAction: {
                    if viewModel.isTransferInCreation() {
                        viewModel.presentingConfirmationDialog.toggle()
                    } else {
                        dismissAction()
                    }
                }
            )
        } content: { _ in
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
        }
        .toolbar {
            ToolbarDismissKeyboardButtonView()
        }
        .confirmationDialog("", isPresented: $viewModel.presentingConfirmationDialog) {
            Button("word_cancel_changes".localized, role: .destructive, action: { dismissAction() })
            Button("word_return".localized, role: .cancel, action: { })
        }
        .background(TKDesignSystem.Colors.Background.Theme.bg50.ignoresSafeArea(.all))
        .navigationBarBackButtonHidden(true)
    } // body
    
    func dismissAction() {
        EventService.sendEvent(key: .transferCreationCanceled)
        dismiss()
    }
    
} // struct

// MARK: - Preview
#Preview {
    CreateTransferView()
}
