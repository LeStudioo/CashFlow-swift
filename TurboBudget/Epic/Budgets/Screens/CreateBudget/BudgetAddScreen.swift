//
//  BudgetAddScreen.swift
//  CashFlow
//
//  Created by KaayZenn on 03/08/2023.
//
// Localizations 30/09/2023

import SwiftUI
import NavigationKit
import StatsKit
import TheoKit
import DesignSystemModule
import CoreModule

struct BudgetAddScreen: View {
    
    // Custom
    @StateObject private var viewModel: ViewModel = .init()
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - body
    var body: some View {
        BetterScrollView(maxBlurRadius: Blur.topbar) {
            NavigationBar(
                title: Word.Title.Budget.new,
                actionButton: .init(
                    title: Word.Classic.create,
                    action: {
                        VibrationManager.vibration()
                        await viewModel.createBudget(dismiss: dismiss)
                    },
                    isDisabled: !viewModel.isBudgetValid()
                ),
                dismissAction: {
                    if viewModel.isBudgetInCreation() {
                        viewModel.presentingConfirmationDialog.toggle()
                    } else {
                        dismissAction()
                    }
                }
            )
        } content: { _ in
            VStack(spacing: 24) {
                SelectCategoryButton(
                    selectedCategory: $viewModel.selectedCategory,
                    selectedSubcategory: $viewModel.selectedSubcategory
                )
                
                CustomTextField(
                    text: $viewModel.amountBudget,
                    config: .init(
                        title: Word.Classic.maxAmount,
                        placeholder: "300",
                        style: .amount
                    )
                )
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
    } // End body
    
    func dismissAction() {
        EventService.sendEvent(key: EventKeys.budgetCreationCanceled)
        dismiss()
    }
    
} // End struct

// MARK: - Preview
#Preview {
    BudgetAddScreen()
}
