//
//  CreateTransactionView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//

import SwiftUI

struct CreateTransactionView: View {
    
    // builder
    var transaction: TransactionModel? = nil
    
    @StateObject private var viewModel: CreateTransactionViewModel
    @StateObject private var router: NavigationManager
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: PurchasesManager
    
    @EnvironmentObject private var accountRepository: AccountStore
    @EnvironmentObject private var transactionRepository: TransactionStore
    
    // Enum
    enum Field: CaseIterable {
        case amount, title
    }
    @FocusState var focusedField: Field?
    
    // init
    init(transaction: TransactionModel? = nil) {
        self.transaction = transaction
        self._viewModel = StateObject(wrappedValue: CreateTransactionViewModel(transaction: transaction))
        self._router = StateObject(wrappedValue: NavigationManager(isPresented: .constant(.createTransaction(transaction: transaction))))
    }
    
    // MARK: -
    var body: some View {
        NavStack(router: router) {
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
                    
                    TransactionTypePicker(selected: $viewModel.transactionType)
                    
                    VStack(spacing: 6) {
                        SelectCategoryButton(
                            selectedCategory: $viewModel.selectedCategory,
                            selectedSubcategory: $viewModel.selectedSubcategory
                        )
                        .environmentObject(router)
                        .onChange(of: viewModel.transactionType) { newValue in
                            viewModel.onChangeType(newValue: newValue)
                        }
                        .onChange(of: viewModel.selectedCategory) { newValue in
                            if newValue != CategoryModel.revenue && newValue != CategoryModel.toCategorized {
                                viewModel.transactionType = .expense
                            }
                        }
                        
                        if store.isCashFlowPro && viewModel.selectedCategory == nil {
                            RecommendedCategoryButton(
                                transactionName: viewModel.transactionTitle,
                                type: $viewModel.transactionType,
                                selectedCategory: $viewModel.selectedCategory,
                                selectedSubcategory: $viewModel.selectedSubcategory
                            )
                        }
                    }
                    .animation(.smooth, value: viewModel.transactionTitle)
                    
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
                    Text(transaction == nil ? Word.Title.Transaction.new : Word.Title.Transaction.update)
                        .font(.system(size: isLittleIphone ? 16 : 18, weight: .medium))
                }
                
                ToolbarValidationButtonView(
                    type: transaction == nil ? .creation : .edition,
                    isActive: viewModel.validateTrasaction()
                ) {
                    VibrationManager.vibration()
                    if transaction == nil {
                        viewModel.createTransaction(dismiss: dismiss)
                    } else {
                        viewModel.updateTransaction(dismiss: dismiss)
                    }
                }
                
                ToolbarDismissKeyboardButtonView()
            }
        } // End NavStack
        .interactiveDismissDisabled(viewModel.isTransactionInCreation()) {
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
    CreateTransactionView()
}
