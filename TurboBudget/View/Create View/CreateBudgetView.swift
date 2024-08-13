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
    @StateObject private var viewModel = AddBudgetViewModel()
    private let router: NavigationManager = .init(isPresented: .constant(.createBudget))
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    
    // Preferences
    @Preference(\.hapticFeedback) private var hapticFeedback
    
    // MARK: - body
    var body: some View {
        NavStack(router: router) {
            ScrollView {
                
                Text("budget_new".localized)
                    .titleAdjustSize()
                
                HStack {
                    Spacer()
                    SelectCategoryButtonView(
                        router: router,
                        selectedCategory: $viewModel.selectedCategory,
                        selectedSubcategory: $viewModel.selectedSubcategory
                    )
                    Spacer()
                }
                .padding()

                TextField("0.00", text: $viewModel.amountBudget.max(9).animation())
                .font(.boldCustom(size: isLittleIphone ? 24 : 30))
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .if(!isLittleIphone) { view in
                    view
                        .padding()
                }
                .if(isLittleIphone) { view in
                    view
                        .padding(8)
                }
                .background(Color.backgroundComponentSheet.cornerRadius(100))
                .padding()
                
            } // End ScrollView
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .toolbar {
                ToolbarDismissButtonView {
                    if viewModel.isBudgetInCreation() {
                        viewModel.presentingConfirmationDialog.toggle()
                    } else {
                        dismiss()
                    }
                }
                
                ToolbarCreateButtonView(isActive: viewModel.validateBudget()) {
                    viewModel.createNewBudget()
                    if hapticFeedback {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                    dismiss()
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

//MARK: - Preview
#Preview {
    CreateBudgetView()
}
