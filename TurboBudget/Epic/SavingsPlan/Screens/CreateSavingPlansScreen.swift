//
//  CreateSavingPlansScreen.swift
//  TurboBudget
//
//  Created by Théo Sementa on 20/06/2023.
//
// Localizations 30/09/2023

import SwiftUI
import MCEmojiPicker
import StatsKit
import TheoKit

struct CreateSavingPlansScreen: View {
    
    // builder
    var savingsPlan: SavingsPlanModel?
    @StateObject private var viewModel: CreateSavingsPlanViewModel
    
    // Custom
    @EnvironmentObject private var accountStore: AccountStore
    @EnvironmentObject private var savingsPlanStore: SavingsPlanStore
    @EnvironmentObject private var contributionStore: ContributionStore
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    
    // Enum
    enum Field: CaseIterable {
        case title, amountOfStart, amountOfEnd
    }
    @FocusState private var focusedField: Field?
    
    // init
    init(savingsPlan: SavingsPlanModel? = nil) {
        self.savingsPlan = savingsPlan
        self._viewModel = StateObject(wrappedValue: CreateSavingsPlanViewModel(savingsPlan: savingsPlan))
    }
    
    // MARK: -
    var body: some View {
        BetterScrollView(maxBlurRadius: DesignSystem.Blur.topbar) {
            NavigationBar(
                title: savingsPlan == nil ? Word.Title.SavingsPlan.new : Word.Title.SavingsPlan.update,
                actionButton: .init(
                    title: savingsPlan == nil ? Word.Classic.create : Word.Classic.edit,
                    action: {
                        VibrationManager.vibration()
                        if savingsPlan == nil {
                            await viewModel.createSavingsPlan(dismiss: dismiss)
                        } else {
                            await viewModel.updateSavingsPlan(dismiss: dismiss)
                        }
                    },
                    isDisabled: !viewModel.validateSavingPlan()
                ),
                dismissAction: {
                    if viewModel.isSavingPlansInCreation() {
                        viewModel.presentingConfirmationDialog.toggle()
                    } else {
                        dismissAction()
                    }
                }
            )
        } content: { _ in
            VStack(spacing: 24) {
                HStack(alignment: .bottom, spacing: 8) {
                    CustomTextField(
                        text: $viewModel.name,
                        config: .init(
                            title: Word.Classic.name,
                            placeholder: "MacBook Pro"
                        )
                    )
                    .focused($focusedField, equals: .title)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .amountOfStart
                    }
                    
                    Button(action: { viewModel.showEmojiPicker.toggle() }, label: {
                        Text(viewModel.emoji)
                            .font(.system(size: 16))
                            .padding(15)
                            .background {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.background200)
                            }
                    })
                    .emojiPicker(
                        isPresented: $viewModel.showEmojiPicker,
                        selectedEmoji: $viewModel.emoji
                    )
                }
                
                if savingsPlan == nil {
                    CustomTextField(
                        text: $viewModel.savingPlanAmountOfStart,
                        config: .init(
                            title: Word.Classic.initialAmount,
                            placeholder: "0.00",
                            style: .amount
                        )
                    )
                    .focused($focusedField, equals: .amountOfStart)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .amountOfEnd
                    }
                }
                
                CustomTextField(
                    text: $viewModel.goalAmount,
                    config: .init(
                        title: Word.Classic.amountToReach,
                        placeholder: "1 000",
                        style: .amount
                    )
                )
                .focused($focusedField, equals: .amountOfEnd)
                .submitLabel(.done)
                
                CustomDatePickerWithToggle(
                    title: Word.Classic.startTargetDate,
                    date: $viewModel.startDate,
                    isEnabled: .constant(true)
                )
                
                CustomDatePickerWithToggle(
                    title: Word.Classic.finalTargetDate,
                    date: $viewModel.endDate,
                    isEnabled: $viewModel.isEndDate,
                    withRange: true
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
        if viewModel.isEditing {
            EventService.sendEvent(key: .savingsplanUpdateCanceled)
        } else {
            EventService.sendEvent(key: .savingsplanCreationCanceled)
        }
        dismiss()
    }
    
} // End struct

// MARK: - Preview
#Preview {
    CreateSavingPlansScreen()
}
