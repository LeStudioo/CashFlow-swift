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
    @ObservedObject var savingsPlan: SavingsPlanModel
    
    // Custom
    @StateObject private var viewModel: CreateContributionViewModel

    // Environment
    @Environment(\.dismiss) private var dismiss
    
    // init
    init(savingsPlan: SavingsPlanModel) {
        self._savingsPlan = ObservedObject(wrappedValue: savingsPlan)
        self._viewModel = StateObject(wrappedValue: .init(savingsPlan: savingsPlan))
    }

    //MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("contribution_new".localized)
                    .titleAdjustSize()
                    .padding(.vertical, 24)
                
                TextField("0.00", text: $viewModel.amount.max(9).animation())
                    .font(.boldCustom(size: isLittleIphone ? 24 : 30))
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .padding(isLittleIphone ? 8 : 16)
                    .background(Color.backgroundComponentSheet.cornerRadius(100))
                    .padding(.bottom, 24)
                
                ContributionTypePicker(selected: $viewModel.type)
                    .padding(.bottom, 24)
                
                ZStack {
                    Capsule()
                        .frame(height: isLittleIphone ? 40 : 50)
                        .foregroundStyle(Color.backgroundComponentSheet)
                    
                    HStack {
                        Spacer()
                        DatePicker(
                            "\(viewModel.date.formatted())",
                            selection: $viewModel.date,
                            in: (savingsPlan.startDate)...,
                            displayedComponents: [.date]
                        )
                        .labelsHidden()
                        .clipped()
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 24)
                
                VStack {
                    if (viewModel.amount.toDouble() < savingsPlan.amountToTheGoal || savingsPlan.amountToTheGoal != 0) && viewModel.type == .addition {
                        Text("💰" + savingsPlan.amountToTheGoal.currency + " " + "contribution_alert_for_finish".localized)
                    }
                    if ((savingsPlan.currentAmount ?? 0) - viewModel.amount.toDouble()) < 0 && viewModel.type == .withdrawal {
                        Text("contribution_alert_take_more_amount".localized)
                    }
                }
                .font(Font.mediumText16())
                .multilineTextAlignment(.center)
                .padding(.bottom, 24)
            } // End ScrollView
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .padding(.horizontal)
            .toolbar {
                ToolbarDismissButtonView {
                    if viewModel.isContributionInCreation() {
                        viewModel.presentingConfirmationDialog.toggle()
                    } else {
                        dismiss()
                    }
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
