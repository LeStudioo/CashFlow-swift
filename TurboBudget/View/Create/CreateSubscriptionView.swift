//
//  AddAutomationsView.swift
//  CashFlow
//
//  Created by KaayZenn on 18/07/2023.
//
// Localizations 30/09/2023

import SwiftUI

struct CreateSubscriptionView: View {
    
    // builder
    var subscription: SubscriptionModel? = nil
    
    @StateObject private var router: NavigationManager
    @StateObject private var viewModel: CreateSubscriptionViewModel = .init()
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: PurchasesManager
    
    // Enum
    enum Field: CaseIterable {
        case amount, title
    }
    @FocusState private var focusedField: Field?
    
    // init
    init(subscription: SubscriptionModel? = nil) {
        self.subscription = subscription
        self._router = StateObject(wrappedValue: NavigationManager(isPresented: .constant(.createAutomation)))
    }
    
    //MARK: -
    var body: some View {
        NavStack(router: router) {
            ScrollView {
                VStack(spacing: 24) {
                    CustomTextField(
                        text: $viewModel.name,
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
                        text: $viewModel.amount,
                        config: .init(
                            title: Word.Classic.price,
                            placeholder: "14,99",
                            style: .amount
                        )
                    )
                    .focused($focusedField, equals: .amount)
                    
                    TransactionTypePicker(selected: $viewModel.type)
                    
                    VStack(spacing: 6) {
                        SelectCategoryButton(
                            type: $viewModel.type,
                            selectedCategory: $viewModel.selectedCategory,
                            selectedSubcategory: $viewModel.selectedSubcategory
                        )
                        
                        if store.isCashFlowPro && viewModel.selectedCategory == nil {
                            RecommendedCategoryButton(
                                transactionName: viewModel.name,
                                type: $viewModel.type,
                                selectedCategory: $viewModel.selectedCategory,
                                selectedSubcategory: $viewModel.selectedSubcategory
                            )
                        }
                    }
                    .animation(.smooth, value: viewModel.name)
                    
                    CustomDatePicker(
                        title: Word.Classic.dayOfAutomation, // TODO: Date subscription
                        date: $viewModel.frequencyDate
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
                    Text(Word.Title.Subscription.new)
                        .font(.system(size: isLittleIphone ? 16 : 18, weight: .medium))
                }
                
                ToolbarValidationButtonView(isActive: viewModel.validateAutomation()) {
                    VibrationManager.vibration()
                    viewModel.createNewSubscription(dismiss: dismiss)
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
    CreateSubscriptionView()
}
