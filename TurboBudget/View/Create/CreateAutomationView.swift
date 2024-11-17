//
//  AddAutomationsView.swift
//  CashFlow
//
//  Created by KaayZenn on 18/07/2023.
//
// Localizations 30/09/2023

import SwiftUI

struct CreateAutomationView: View {
    
    @StateObject private var router: NavigationManager = .init(isPresented: .constant(.createAutomation))
    @StateObject private var viewModel: AddAutomationViewModel = .init()
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: PurchasesManager
    
    // Enum
    enum Field: CaseIterable {
        case amount, title
    }
    @FocusState private var focusedField: Field?
    
    //MARK: -
    var body: some View {
        NavStack(router: router) {
            ScrollView {
                VStack(spacing: 24) {
                    CustomTextField(
                        text: $viewModel.transactionTitle,
                        config: .init(
                            title: Word.Classic.name,
                            placeholder: "Netflix"
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
                            placeholder: "14,99",
                            style: .amount
                        )
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
                    
                    CustomIntPicker(
                        title: Word.Classic.dayOfAutomation,
                        number: $viewModel.dayAutomation
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
                    if viewModel.isAutomationInCreation() {
                        viewModel.presentingConfirmationDialog.toggle()
                    } else {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(Word.Title.newAutomation)
                        .font(.system(size: isLittleIphone ? 16 : 18, weight: .medium))
                }
                
                ToolbarValidationButtonView(isActive: viewModel.validateAutomation()) {
                    VibrationManager.vibration()
                    viewModel.createNewAutomation { withError in
                        if withError == nil {
                            dismiss()
                        } else {
                            // TODO: Show a error banner
                        }
                    }
                }
                
                ToolbarDismissKeyboardButtonView()
            }
        } // End NavigationStack
        .interactiveDismissDisabled(viewModel.isAutomationInCreation()) {
            viewModel.presentingConfirmationDialog.toggle()
        }
        .confirmationDialog("", isPresented: $viewModel.presentingConfirmationDialog) {
            Button("word_cancel_changes".localized, role: .destructive, action: { dismiss() })
            Button("word_return".localized, role: .cancel, action: { })
        }
    } // End body
} // END struct

//MARK: - Preview
#Preview {
    CreateAutomationView()
}
