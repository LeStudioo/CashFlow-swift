//
//  CreateBudgetView.swift
//  CashFlow
//
//  Created by KaayZenn on 03/08/2023.
//
// Localizations 30/09/2023

import SwiftUI

struct CreateBudgetView: View {
    
    // Custom
    @StateObject private var viewModel: CreateBudgetViewModel = .init()
    @StateObject private var router: NavigationManager = .init(isPresented: .constant(.createBudget))
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - body
    var body: some View {
        NavStack(router: router) {
            ScrollView {
                VStack(spacing: 24) {
                    SelectCategoryButton(
                        selectedCategory: $viewModel.selectedCategory,
                        selectedSubcategory: $viewModel.selectedSubcategory
                    )
                    .environmentObject(router)
                    
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
            } // End ScrollView
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarDismissButtonView {
                    if viewModel.isBudgetInCreation() {
                        viewModel.presentingConfirmationDialog.toggle()
                    } else {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(Word.Title.Budget.new)
                        .font(.system(size: UIDevice.isLittleIphone ? 16 : 18, weight: .medium))
                }
                
                ToolbarValidationButtonView(isActive: viewModel.isBudgetValid()) {
                    VibrationManager.vibration()
                    viewModel.createBudget(dismiss: dismiss)
                }
                
                ToolbarDismissKeyboardButtonView()
            }
        } // End NavStack
        .interactiveDismissDisabled(viewModel.isBudgetInCreation()) {
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
    CreateBudgetView()
}
