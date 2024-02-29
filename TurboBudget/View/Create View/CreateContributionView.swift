//
//  CreateContributionView.swift
//  CashFlow
//
//  Created by Théo Sementa on 09/07/2023.
//
// Localizations 30/09/2023

import SwiftUI
import Combine

struct CreateContributionView: View {

    // Builder
    @ObservedObject var savingPlan: SavingPlan
    
    // Custom
    @StateObject private var viewModel = AddContributionViewModel()

    // Environment
    @Environment(\.dismiss) private var dismiss

    // Preferences
    @Preference(\.hapticFeedback) private var hapticFeedback

    // Other
    var numberFormatter: NumberFormatter {
        let numFor = NumberFormatter()
        numFor.numberStyle = .decimal
        numFor.zeroSymbol = ""
        return numFor
    }

    //MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                
                Text("contribution_new".localized)
                    .titleAdjustSize()
                    .padding(.vertical, 24)
                
                TextField("contribution_placeholder_amount".localized, value: $viewModel.amountContribution.animation(), formatter: numberFormatter)
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
                    .padding(.bottom, 24)
                    .onReceive(Just(viewModel.amountContribution)) { newValue in
                        if viewModel.amountContribution > 1_000_000_000 {
                            let numberWithoutLastDigit = HelperManager().removeLastDigit(from: viewModel.amountContribution)
                            viewModel.amountContribution = numberWithoutLastDigit
                        }
                    }
                
                CustomSegmentedControl(
                    selection: $viewModel.typeContribution,
                    textLeft: "contribution_add".localized,
                    textRight: "contribution_withdraw".localized,
                    height: isLittleIphone ? 40 : 50
                )
                .padding(.bottom, 24)
                
                ZStack {
                    Capsule()
                        .frame(height: isLittleIphone ? 40 : 50)
                        .foregroundColor(Color.backgroundComponentSheet)
                    
                    HStack {
                        Spacer()
                        DatePicker("\(viewModel.dateContribution.formatted())", selection: $viewModel.dateContribution, in: savingPlan.dateOfStart..., displayedComponents: [.date])
                            .labelsHidden()
                            .clipped()
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom, 24)
                
                VStack {
                    if (viewModel.amountContribution > viewModel.moneyForFinish || viewModel.moneyForFinish == 0) && viewModel.typeContribution == .expense {
                        Text("contribution_alert_more_final_amount".localized)
                    } else if (viewModel.amountContribution < viewModel.moneyForFinish || viewModel.moneyForFinish != 0) && viewModel.typeContribution == .expense {
                        Text("💰" + viewModel.moneyForFinish.currency + " " + "contribution_alert_for_finish".localized)
                    }
                    if (savingPlan.actualAmount - viewModel.amountContribution < 0) && viewModel.typeContribution == .income {
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
                
                ToolbarCreateButtonView(isActive: viewModel.isContributionValid()) {
                    viewModel.createContribution()
                    if hapticFeedback {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                    dismiss()
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
        .onAppear {
            viewModel.savingPlan = savingPlan
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CreateContributionView(savingPlan: SavingPlan.preview1)
}
