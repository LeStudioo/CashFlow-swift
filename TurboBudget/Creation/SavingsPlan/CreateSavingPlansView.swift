//
//  CreateSavingPlansView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 20/06/2023.
//
// Localizations 30/09/2023

import SwiftUI
import MCEmojiPicker

struct CreateSavingPlansView: View {
    
    // builder
    var savingsPlan: SavingsPlanModel?
    @StateObject private var viewModel: CreateSavingsPlanViewModel
    
    // Custom
    @EnvironmentObject private var accountRepository: AccountStore
    @EnvironmentObject private var savingsPlanRepository: SavingsPlanStore
    @EnvironmentObject private var contributionRepository: ContributionStore
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    
    //Enum
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
        NavigationStack {
            ScrollView {
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
            } // End ScrollView
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarDismissButtonView {
                    if viewModel.isSavingPlansInCreation() {
                        viewModel.presentingConfirmationDialog.toggle()
                    } else {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(savingsPlan == nil ? Word.Title.SavingsPlan.new : Word.Title.SavingsPlan.update)
                        .font(.system(size: isLittleIphone ? 16 : 18, weight: .medium))
                }
                
                ToolbarValidationButtonView(
                    type: savingsPlan == nil ? .creation : .edition,
                    isActive: viewModel.validateSavingPlan()
                ) {
                    VibrationManager.vibration()
                    if savingsPlan == nil {
                        viewModel.createSavingsPlan(dismiss: dismiss)
                    } else {
                        viewModel.updateSavingsPlan(dismiss: dismiss)
                    }
                }
                
                ToolbarDismissKeyboardButtonView()
            }
        } // End NavStack
        .interactiveDismissDisabled(viewModel.isSavingPlansInCreation()) {
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
    CreateSavingPlansView()
}
