//
//  CreateBudgetView.swift
//  CashFlow
//
//  Created by KaayZenn on 03/08/2023.
//
// Localizations 30/09/2023

import SwiftUI
import NavigationKit
import StatsKit

struct CreateBudgetView: View {
    
    // Custom
    @StateObject private var viewModel: CreateBudgetViewModel = .init()
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - body
    var body: some View {
        ScrollView {
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
        } // End ScrollView
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            ToolbarDismissButtonView {
                if viewModel.isBudgetInCreation() {
                    viewModel.presentingConfirmationDialog.toggle()
                } else {
                    dismissAction()
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text(Word.Title.Budget.new)
                    .font(.system(size: UIDevice.isLittleIphone ? 16 : 18, weight: .medium))
            }
            
            ToolbarValidationButtonView(isActive: viewModel.isBudgetValid()) {
                VibrationManager.vibration()
                await viewModel.createBudget(dismiss: dismiss)
            }
            
            ToolbarDismissKeyboardButtonView()
        }
        .interactiveDismissDisabled(viewModel.isBudgetInCreation()) {
            viewModel.presentingConfirmationDialog.toggle()
        }
        .confirmationDialog("", isPresented: $viewModel.presentingConfirmationDialog) {
            Button("word_cancel_changes".localized, role: .destructive, action: { dismissAction() })
            Button("word_return".localized, role: .cancel, action: { })
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .bottom)
    } // End body
    
    func dismissAction() {
        EventService.sendEvent(key: .budgetCreationCanceled)
        dismiss()
    }
    
} // End struct

// MARK: - Preview
#Preview {
    CreateBudgetView()
}
