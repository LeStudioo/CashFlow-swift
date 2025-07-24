//
//  AddAutomationsView.swift
//  CashFlow
//
//  Created by KaayZenn on 18/07/2023.
//
// Localizations 30/09/2023

import SwiftUI
import NavigationKit
import StatsKit
import TheoKit
import DesignSystemModule
import CoreModule

struct SubscriptionAddScreen: View {
    
    // builder
    var subscription: SubscriptionModel?
    
    @StateObject private var viewModel: ViewModel
    
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
        self._viewModel = StateObject(wrappedValue: ViewModel(subscription: subscription))
    }
    
    // MARK: -
    var body: some View {
        BetterScrollView(maxBlurRadius: Blur.topbar) {
            NavigationBar(
                title: subscription == nil ? Word.Title.Subscription.new : Word.Title.Subscription.update,
                actionButton: .init(
                    title: subscription == nil ? Word.Classic.create : Word.Classic.edit,
                    action: {
                        VibrationManager.vibration()
                        if subscription != nil {
                            await viewModel.updateSubscription(dismiss: dismiss)
                        } else {
                            await viewModel.createNewSubscription(dismiss: dismiss)
                        }
                    },
                    isDisabled: !viewModel.validateAutomation()
                ),
                dismissAction: {
                    if viewModel.isAutomationInCreation() {
                        viewModel.presentingConfirmationDialog.toggle()
                    } else {
                        dismissAction()
                    }
                }
            )
        } content: { _ in
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
                                
                VStack(spacing: 6) {
                    SelectCategoryButton(
                        selectedCategory: $viewModel.selectedCategory,
                        selectedSubcategory: $viewModel.selectedSubcategory
                    )
                    
                    if store.isCashFlowPro && viewModel.selectedCategory == nil {
                        RecommendedCategoryButton(
                            transactionName: viewModel.name,
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
        }
        .toolbar {
            ToolbarDismissKeyboardButtonView()
        }
        .confirmationDialog("", isPresented: $viewModel.presentingConfirmationDialog) {
            Button("word_cancel_changes".localized, role: .destructive, action: { dismissAction() })
            Button("word_return".localized, role: .cancel, action: { })
        }
        .background(TKDesignSystem.Colors.Background.Theme.bg50)
        .navigationBarBackButtonHidden(true)
    } // body
    
    func dismissAction() {
        if viewModel.isEditing {
            EventService.sendEvent(key: EventKeys.subscriptionUpdateCanceled)
        } else {
            EventService.sendEvent(key: EventKeys.subscriptionCreationCanceled)
        }
        dismiss()
    }
    
} // struct

// MARK: - Preview
#Preview {
    SubscriptionAddScreen()
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
