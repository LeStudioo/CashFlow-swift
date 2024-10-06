//
//  AddAutomationsView.swift
//  CashFlow
//
//  Created by KaayZenn on 18/07/2023.
//
// Localizations 30/09/2023

import SwiftUI

struct CreateAutomationView: View {
    
    // Builder
    let router: NavigationManager = .init(isPresented: .constant(.createAutomation))
    
    // Custom
    @StateObject private var viewModel = AddAutomationViewModel()
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    
    // Enum
    enum Field: CaseIterable {
        case amount, title
    }
    @FocusState var focusedField: Field?
    
    //MARK: - Body
    var body: some View {
        NavStack(router: router) {
            GeometryReader { geometry in
                ScrollView {
                    VStack { //New TransactionEntity
                        Text("automation_new".localized)
                            .titleAdjustSize()
                            .padding(.vertical, 24)
                        
                        HStack {
                            Spacer()
                            SelectCategoryButtonView(
                                router: router,
                                selectedCategory: $viewModel.selectedCategory,
                                selectedSubcategory: $viewModel.selectedSubcategory
                            )
                            Spacer()
                        }
                        .padding(.bottom, 24)
                        
                        TextField("automation_title".localized, text: $viewModel.titleTransaction)
                            .font(.semiBoldCustom(size: isLittleIphone ? 24 : 30))
                            .multilineTextAlignment(.center)
                            .padding(8)
                            .background(Color.backgroundComponentSheet.cornerRadius(100))
                            .padding(.bottom, 24)
                            .focused($focusedField, equals: .title)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .amount
                            }
                        
                        TextField("automation_placeholder_amount".localized, text: $viewModel.amountTransaction.max(9).animation())
                            .focused($focusedField, equals: .amount)
                            .font(.boldCustom(size: isLittleIphone ? 24 : 30))
                            .multilineTextAlignment(.center)
                            .keyboardType(.decimalPad)
                            .padding(isLittleIphone ? 8 : 16)
                            .background(Color.backgroundComponentSheet.cornerRadius(100))
                            .padding(.bottom, 24)
                        
                        CustomSegmentedControl(
                            title: "notext".localized,
                            selection: $viewModel.typeTransaction,
                            textLeft: "word_expense".localized,
                            textRight: "word_income".localized
                        )
                        .padding(.bottom, 24)
                        
                        // Sélection d'une date
                        ZStack {
                            Capsule()
                                .frame(height: isLittleIphone ? 40 : 50)
                                .foregroundStyle(Color.backgroundComponentSheet)
                            
                            HStack {
                                Text(viewModel.automationFrenquently == .monthly ? "word_day".localized : "word_date".localized)
                                    .font(Font.mediumText16())
                                Spacer()
                                
                                if viewModel.automationFrenquently == .monthly {
                                    Picker("", selection: $viewModel.dayAutomation, content: {
                                        ForEach(1..<32) { i in
                                            Text("\(i)").tag(i)
                                        }
                                    })
                                    .labelsHidden()
                                } else {
                                    DatePicker("\(viewModel.dateAutomation.formatted())", selection: $viewModel.dateAutomation, displayedComponents: [.date])
                                        .labelsHidden()
                                        .clipped()
                                        .padding(.horizontal)
                                }
                            }
                            .padding(.leading)
                        }
                    } // End New TransactionEntity
                } // End ScrollView
                .scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.immediately)
                .padding(.horizontal)
            } // End GeometryReader
            .toolbar {
                ToolbarDismissButtonView {
                    if viewModel.isAutomationInCreation() {
                        viewModel.presentingConfirmationDialog.toggle()
                    } else {
                        dismiss()
                    }
                }
                
                ToolbarCreateButtonView(isActive: viewModel.validateAutomation()) {
                    VibrationManager.vibration()
                    viewModel.createNewAutomation { withError in
                        if withError == nil {
                            dismiss()
                            dismiss()
                        } else {
                            // TODO: Show a error banner
                        }
                    }
                }
                
                ToolbarDismissKeyboardButtonView()
            }
            .onChange(of: viewModel.typeTransaction, perform: { newValue in
                if newValue == .income {
                    viewModel.selectedCategory = .PREDEFCAT0
                    viewModel.selectedSubcategory = nil
                } else {
                    viewModel.selectedCategory = nil
                    viewModel.selectedSubcategory = nil
                }
            })
            .onAppear {
                let comps = Calendar.current.dateComponents([.day], from: Date())
                if let day = comps.day { viewModel.dayAutomation = day }
            }
        } // End NavigationStack
        .interactiveDismissDisabled(viewModel.isAutomationInCreation()) {
            viewModel.presentingConfirmationDialog.toggle()
        }
        .confirmationDialog("", isPresented: $viewModel.presentingConfirmationDialog) {
            Button("word_cancel_changes".localized, role: .destructive, action: { dismiss() })
            Button("word_return".localized, role: .cancel, action: { })
        }
    } // End body
} // END struct

//MARK: - Preview
#Preview {
    CreateAutomationView()
}
