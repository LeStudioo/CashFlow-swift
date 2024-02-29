//
//  CreateBudgetView.swift
//  CashFlow
//
//  Created by KaayZenn on 03/08/2023.
//
// Localizations 30/09/2023

import SwiftUI
import Combine

struct CreateBudgetView: View {
    
    // Builder
    var router: NavigationManager
    
    // Custom
    @StateObject private var viewModel = AddBudgetViewModel()
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    // Preferences
    @Preference(\.hapticFeedback) private var hapticFeedback
    
    // Other
    var numberFormatter: NumberFormatter {
        let numFor = NumberFormatter()
        numFor.numberStyle = .decimal
        numFor.zeroSymbol = ""
        return numFor
    }
    
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

                TextField(
                    "budget_placeholder_amount".localized,
                    value: $viewModel.amountBudget.animation(),
                    formatter: numberFormatter
                )
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
                .onReceive(Just(viewModel.amountBudget)) { newValue in
                    if viewModel.amountBudget > 1_000_000_000 {
                        let numberWithoutLastDigit = HelperManager().removeLastDigit(from: viewModel.amountBudget)
                        self.viewModel.amountBudget = numberWithoutLastDigit
                    }
                }
                
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
    CreateBudgetView(router: .init(isPresented: .constant(.createBudget)))
}
