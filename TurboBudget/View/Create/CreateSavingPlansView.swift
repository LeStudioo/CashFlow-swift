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
    
    // Custom
    @StateObject private var viewModel: AddSavingPlanViewModel = .init()
    @EnvironmentObject private var accountRepository: AccountRepository
    @EnvironmentObject private var savingsPlanRepository: SavingsPlanRepository
    @EnvironmentObject private var contributionRepository: ContributionRepository
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    
    //Enum
    enum Field: CaseIterable {
        case title, amountOfStart, amountOfEnd
    }
    @FocusState private var focusedField: Field?
    
    //MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    HStack(alignment: .bottom, spacing: 8) {
                        CustomTextField(
                            text: $viewModel.savingPlanTitle,
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
                            Text(viewModel.savingPlanEmoji)
                                .font(.system(size: 16))
                                .padding(15)
                                .background {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color.backgroundComponentSheet)
                                }
                        })
                        .emojiPicker(
                            isPresented: $viewModel.showEmojiPicker,
                            selectedEmoji: $viewModel.savingPlanEmoji
                        )
                    }
                    
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
                    
                    CustomTextField(
                        text: $viewModel.savingPlanAmountOfEnd,
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
                        date: $viewModel.savingPlanStartDate,
                        isEnabled: .constant(true)
                    )
                    
                    CustomDatePickerWithToggle(
                        title: Word.Classic.finalTargetDate,
                        date: $viewModel.savingPlanDateOfEnd,
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
                    Text(Word.Title.newSavingsPlan)
                        .font(.system(size: isLittleIphone ? 16 : 18, weight: .medium))
                }
                
                ToolbarCreateButtonView(isActive: viewModel.validateSavingPlan()) {
                    VibrationManager.vibration()
                    viewModel.createSavingsPlan(dismiss: dismiss)
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
