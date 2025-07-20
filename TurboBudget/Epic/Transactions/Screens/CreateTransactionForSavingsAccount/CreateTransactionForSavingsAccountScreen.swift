//
//  CreateTransactionForSavingsAccountScreen.swift
//  CashFlow
//
//  Created by Theo Sementa on 22/12/2024.
//

import SwiftUI
import CoreModule

struct CreateTransactionForSavingsAccountScreen: View {
    
    @StateObject private var viewModel: ViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    // Enum
    enum Field: CaseIterable {
        case amount, title
    }
    @FocusState var focusedField: Field?
    
    init(savingsAccount: AccountModel, transaction: TransactionModel? = nil) {
        self._viewModel = StateObject(wrappedValue: .init(savingsAccount: savingsAccount, transaction: transaction))
    }
    
    // MARK: -
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    CustomTextField(
                        text: $viewModel.transactionTitle,
                        config: .init(
                            title: Word.Classic.name,
                            placeholder: "category11_subcategory3_name".localized
                        )
                    )
                    .focused($focusedField, equals: .title)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .amount
                    }
                    
                    CustomTextField(
                        text: $viewModel.transactionAmount,
                        config: .init(
                            title: Word.Classic.price,
                            placeholder: "64,87",
                            style: .amount
                        )
                    )
                    .focused($focusedField, equals: .amount)
                    
                    TransactionTypePickerView(selected: .constant(.income))
                    
                    CustomDatePicker(
                        title: Word.Classic.date,
                        date: $viewModel.transactionDate
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
                    if viewModel.isTransactionInCreation() {
                        viewModel.presentingConfirmationDialog.toggle()
                    } else {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(viewModel.transaction == nil ? Word.Title.Transaction.new : Word.Title.Transaction.update)
                        .font(.system(size: UIDevice.isLittleIphone ? 16 : 18, weight: .medium))
                }
                
                ToolbarValidationButtonView(
                    type: viewModel.transaction == nil ? .creation : .edition,
                    isActive: viewModel.validateTrasaction()
                ) {
                    VibrationManager.vibration()
                    if viewModel.transaction == nil {
                        await viewModel.createTransaction(dismiss: dismiss)
                    } else {
                        await viewModel.updateTransaction(dismiss: dismiss)
                    }
                }
                
                ToolbarDismissKeyboardButtonView()
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    CreateTransactionForSavingsAccountScreen(savingsAccount: .mockSavingsAccount)
}
