//
//  CreateSavingPlansView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 20/06/2023.
//
// Localizations 30/09/2023

import SwiftUI

struct CreateSavingPlansView: View {
    
    // Custom
    @StateObject private var viewModel = AddSavingPlanViewModel()
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    
    //Enum
    enum Field: CaseIterable {
        case emoji, title, amountOfStart, amountOfEnd
    }
    @FocusState var focusedField: Field?
    
    //MARK: - Body
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        
                        Text("savingsplan_new".localized)
                            .titleAdjustSize()
                            .padding(.vertical, 24)
                        
                        VStack {
                            ZStack {
                                Circle()
                                    .foregroundStyle(Color.backgroundComponentSheet)
                                
                                if viewModel.savingPlanEmoji.isEmpty && focusedField != .emoji {
                                    Image(systemName: "plus")
                                        .font(.system(size: isLittleIphone ? 26 : 32, weight: .regular, design: .rounded))
                                        .foregroundStyle(Color(uiColor: .label))
                                } else {
                                    Text(viewModel.savingPlanEmoji)
                                        .font(.system(size: 42))
                                }
                            }
                            .frame(width: 100, height: 100)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.isEmoji.toggle()
                                    focusedField = .emoji
                                }
                            }
                            
                            if viewModel.isEmoji {
                                ZStack {
                                    Capsule()
                                        .foregroundStyle(Color.backgroundComponentSheet)
                                    EmojiTextField(text: $viewModel.savingPlanEmoji.max(1), placeholder: "savingsplan_emoji".localized)
                                        .focused($focusedField, equals: .emoji)
                                        .padding(.horizontal)
                                }
                                .frame(width: 100, height: 40)
                            }
                        }
                        .padding(.bottom, 24)
                        
                        TextField("savingsplan_title".localized, text: $viewModel.savingPlanTitle)
                            .multilineTextAlignment(.center)
                            .font(.semiBoldCustom(size: isLittleIphone ? 24 : 30))
                            .padding(8)
                            .background(Color.backgroundComponentSheet.cornerRadius(100))
                            .padding(.bottom, 24)
                            .focused($focusedField, equals: .title)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .amountOfStart
                            }
                        
                        HStack(spacing: 16) {
                            VStack(alignment: .center, spacing: 4) {
                                Text("savingsplan_start".localized)
                                    .font(Font.mediumText16())
                                TextField("0.00", text: $viewModel.savingPlanAmountOfStart.max(9).animation())
                                    .focused($focusedField, equals: .amountOfStart)
                                    .font(.semiBoldCustom(size: 30))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(1)
                                    .padding(8)
                                    .background(Color.backgroundComponentSheet.cornerRadius(100))
                                    .keyboardType(.decimalPad)
                            }
                            
                            VStack(alignment: .center, spacing: 4) {
                                Text("savingsplan_end".localized)
                                    .font(Font.mediumText16())
                                TextField("0.00", text: $viewModel.savingPlanAmountOfEnd.max(9).animation())
                                    .focused($focusedField, equals: .amountOfEnd)
                                    .font(.semiBoldCustom(size: 30))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(1)
                                    .padding(8)
                                    .background(Color.backgroundComponentSheet.cornerRadius(100))
                                    .keyboardType(.decimalPad)
                            }
                        }
                        .padding(.bottom, 24)
                        
                        VStack {
                            ZStack {
                                Capsule()
                                    .frame(height: 50)
                                    .foregroundStyle(Color.backgroundComponentSheet)
                                
                                HStack {
                                    Spacer()
                                    Toggle("savingsplan_end_date".localized, isOn: $viewModel.isEndDate.animation())
                                        .font(Font.mediumText16())
                                        .padding(.horizontal)
                                }
                            }
                            .padding(.bottom, 24)
                            
                            if viewModel.isEndDate {
                                ZStack {
                                    Capsule()
                                        .frame(height: 50)
                                        .foregroundStyle(Color.backgroundComponentSheet)
                                    
                                    HStack {
                                        Spacer()
                                        DatePicker("savingsplan_end_date_picker".localized, selection: $viewModel.savingPlanDateOfEnd, in: Date()..., displayedComponents: [.date])
                                            .font(Font.mediumText16())
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                } // End ScrollView
                .scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.immediately)
                .padding(.horizontal)
                .onChange(of: focusedField, perform: { newValue in
                    if newValue != .emoji { withAnimation { viewModel.isEmoji = false } }
                })
            } // End GeometryReader
            .toolbar {
                ToolbarDismissButtonView {
                    if viewModel.isSavingPlansInCreation() {
                        viewModel.presentingConfirmationDialog.toggle()
                    } else {
                        dismiss()
                    }
                }
                
                ToolbarCreateButtonView(isActive: viewModel.validateSavingPlan()) {
                    VibrationManager.vibration()
                    viewModel.createSavingsPlan { withError in
                        if withError == nil {
                            dismiss()
                        } else {
                            // TODO: Show a error banner
                        }
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
