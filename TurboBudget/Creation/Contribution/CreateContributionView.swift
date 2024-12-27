//
//  CreateContributionView.swift
//  CashFlow
//
//  Created by Théo Sementa on 09/07/2023.
//
// Localizations 30/09/2023

import SwiftUI

struct CreateContributionView: View {

    // Builder
    var savingsPlan: SavingsPlanModel
    
    // Custom
    @StateObject private var viewModel: CreateContributionViewModel

    // Environment
    @Environment(\.dismiss) private var dismiss
    
    // init
    init(savingsPlan: SavingsPlanModel) {
        self.savingsPlan = savingsPlan
        self._viewModel = StateObject(wrappedValue: .init(savingsPlan: savingsPlan))
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    CustomTextField(
                        text: $viewModel.amount.max(9),
                        config: .init(
                            title: Word.Classic.amount,
                            placeholder: "200.00",
                            style: .amount
                        )
                    )
                    
                    ContributionTypePicker(selected: $viewModel.type)
                    
                    CustomDatePicker(
                        title: Word.Classic.date,
                        date: $viewModel.date
                    )
                    
                    Group {
                        if (viewModel.amount.toDouble() < savingsPlan.amountToTheGoal || savingsPlan.amountToTheGoal != 0) && viewModel.type == .addition {
                            Text("💰" + savingsPlan.amountToTheGoal.toCurrency() + " " + "contribution_alert_for_finish".localized)
                        }
                        if ((savingsPlan.currentAmount ?? 0) - viewModel.amount.toDouble()) < 0 && viewModel.type == .withdrawal {
                            Text("contribution_alert_take_more_amount".localized)
                        }
                    }
                    .font(Font.mediumText16())
                    .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top)
            } // ScrollView
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarDismissButtonView {
                    if viewModel.isContributionInCreation() {
                        viewModel.presentingConfirmationDialog.toggle()
                    } else {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("contribution_new".localized)
                        .font(.system(size: isLittleIphone ? 16 : 18, weight: .medium))
                }
                
                ToolbarValidationButtonView(isActive: viewModel.isContributionValid()) {
                    VibrationManager.vibration()
                    viewModel.createContribution(dismiss: dismiss)
                }
                
                ToolbarDismissKeyboardButtonView()
            }
        } // End Navigation Stack
        .interactiveDismissDisabled(viewModel.isContributionInCreation()) {
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
    CreateContributionView(savingsPlan: .mockClassicSavingsPlan)
}
