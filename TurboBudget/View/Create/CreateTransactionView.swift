//
//  CreateTransactionView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//

import SwiftUI

struct CreateTransactionView: View {
    
    @StateObject private var router: NavigationManager = .init(isPresented: .constant(.createTransaction))
    @StateObject private var viewModel: CreateTransactionViewModel = .init()
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: PurchasesManager
    
    // Enum
    enum Field: CaseIterable {
        case amount, title
    }
    @FocusState var focusedField: Field?
    
    // MARK: -
    var body: some View {
        NavStack(router: router) {
            ScrollView {
                VStack(spacing: 24) {
                    CustomTextField(
                        title: Word.Classic.name,
                        placeholder: "category11_subcategory3_name".localized,
                        text: $viewModel.transactionTitle
                    )
                    .focused($focusedField, equals: .title)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .amount
                    }
                    
                    CustomTextField(
                        title: Word.Classic.price,
                        placeholder: "64,87",
                        text: $viewModel.transactionAmount,
                        style: .amount
                    )
                    .focused($focusedField, equals: .amount)
                    
                    CustomSegmentedControl(
                        title: Word.Classic.typeOfTransaction,
                        selection: $viewModel.transactionType,
                        textLeft: Word.Classic.expense,
                        textRight: Word.Classic.income
                    )
                    
                    VStack(spacing: 6) {
                        SelectCategoryButton(
                            router: router,
                            transactionType: $viewModel.transactionType,
                            selectedCategory: $viewModel.selectedCategory,
                            selectedSubcategory: $viewModel.selectedSubcategory
                        )
                        
                        if store.isCashFlowPro && viewModel.selectedCategory == nil {
                            RecommendedCategoryButton(
                                transactionTitle: viewModel.transactionTitle,
                                transactionType: $viewModel.transactionType,
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
                    Text(Word.Title.newTransaction)
                        .font(.system(size: isLittleIphone ? 16 : 18, weight: .medium))
                }
                
                ToolbarCreateButtonView(isActive: viewModel.validateTrasaction()) {
                    VibrationManager.vibration()
                    viewModel.createNewTransaction { withError in
                        if withError == nil {
                            dismiss()
                        } else {
                            // TODO: Show a error banner
                        }
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
