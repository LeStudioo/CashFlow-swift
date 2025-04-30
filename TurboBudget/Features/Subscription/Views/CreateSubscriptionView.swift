//
//  AddAutomationsView.swift
//  CashFlow
//
//  Created by KaayZenn on 18/07/2023.
//
// Localizations 30/09/2023

import SwiftUI
import NavigationKit

struct CreateSubscriptionView: View {
    
    // builder
    var subscription: SubscriptionModel?
    
    @StateObject private var viewModel: CreateSubscriptionViewModel
    
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
        self._viewModel = StateObject(wrappedValue: CreateSubscriptionViewModel(subscription: subscription))
    }
    
    // MARK: -
    var body: some View {
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
                        selectedCategory: $viewModel.selectedCategory,
                        selectedSubcategory: $viewModel.selectedSubcategory
                    )
                    .onChange(of: viewModel.type) { newValue in
                        viewModel.onChangeType(newValue: newValue)
                    }
                    .onChange(of: viewModel.selectedCategory) { newValue in
                        if newValue != CategoryModel.revenue && newValue != CategoryModel.toCategorized {
                            viewModel.type = .expense
                        } else if newValue == CategoryModel.revenue {
                            viewModel.type = .income
                            viewModel.selectedSubcategory = nil
                        }
                    }
                    
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
                    title: Word.Classic.subscriptionFuturDate,
                    date: $viewModel.frequencyDate,
                    onlyFutureDates: true
                )
                
                FrequencyPicker(selected: $viewModel.frequency)
            }
            .padding(.horizontal, 24)
            .padding(.top)
        } // End ScrollView
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            ToolbarDismissButtonView {
                if viewModel.isAutomationInCreation() {
                    viewModel.presentingConfirmationDialog.toggle()
                } else {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text(subscription == nil ? Word.Title.Subscription.new : Word.Title.Subscription.update)
                    .font(.system(size: UIDevice.isLittleIphone ? 16 : 18, weight: .medium))
            }
            
            ToolbarValidationButtonView(
                type: subscription == nil ? .creation : .edition,
                isActive: viewModel.validateAutomation()
            ) {
                VibrationManager.vibration()
                if subscription != nil {
                    await viewModel.updateSubscription(dismiss: dismiss)
                } else {
                    await viewModel.createNewSubscription(dismiss: dismiss)
                }
            }
            
            ToolbarDismissKeyboardButtonView()
        }
        .interactiveDismissDisabled(viewModel.isAutomationInCreation()) {
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
    CreateSubscriptionView()
}

struct OnTapDismissKeyboardModifier2: ViewModifier {
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle()) // Define the tappable area
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
            )
    }
}

extension View {
    public func onTapDismissKeyboard2() -> some View {
        return modifier(OnTapDismissKeyboardModifier2())
    }
}
