//
//  AddAutomationsView.swift
//  CashFlow
//
//  Created by KaayZenn on 18/07/2023.
//
// Localizations 30/09/2023

import SwiftUI
import ConfettiSwiftUI

struct CreateAutomationView: View {
    
    // Builder
    let router: NavigationManager = .init(isPresented: .constant(.createAutomation))
    
    // Custom
    @StateObject private var viewModel = AddAutomationViewModel()
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    // Preferences
    @Preference(\.hapticFeedback) private var hapticFeedback
    
    // Number variables
    @State private var confettiCounter: Int = 0
    
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
                    if !viewModel.showSuccessfulAutomation {
                        VStack { //New Transaction
                            
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
                                selection: $viewModel.typeTransaction,
                                textLeft: "word_expense".localized,
                                textRight: "word_income".localized,
                                height: isLittleIphone ? 40 : 50
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
                        } // End New Transaction
                    } else {
                        VStack { // Successful Transaction
                            CircleWithCheckmark()
                                .padding(.vertical, 50)
                                .confettiCannon(
                                    counter: $confettiCounter,
                                    num: 50,
                                    openingAngle: Angle(degrees: 0),
                                    closingAngle: Angle(degrees: 360),
                                    radius: 200
                                )
                            
                            VStack(spacing: 20) {
                                Text("automation_successful".localized)
                                    .font(.semiBoldCustom(size: 28))
                                    .foregroundStyle(Color(uiColor: .label))
                                
                                Text("automation_successful_desc".localized)
                                    .font(Font.mediumSmall())
                                    .foregroundStyle(.secondary400)
                            }
                            .padding(.bottom, 30)
                            
                            if let theNewTransaction = viewModel.theNewTransaction {
                                VStack {
                                    CellTransactionWithoutAction(transaction: theNewTransaction)
                                    
                                    HStack {
                                        Text("automation_successful_date".localized)
                                            .font(Font.mediumSmall())
                                            .foregroundStyle(.secondary400)
                                        Spacer()
                                        if let theNewAutomation = viewModel.theNewAutomation {
                                            Text(theNewAutomation.date.formatted(date: .abbreviated, time: .omitted))
                                                .font(.semiBoldSmall())
                                                .foregroundStyle(Color(uiColor: .label))
                                        }
                                    }
                                    .padding(.horizontal, 8)
                                }
                                .padding(.vertical)
                            }
                            
                            Spacer()
                            
                            ValidateButton(action: { dismiss() }, validate: true)
                                .padding(.horizontal, 8)
                                .padding(.bottom)
                        }
                        .frame(minHeight: geometry.size.height)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { confettiCounter += 1 }
                        }
                    }
                } // End ScrollView
                .scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.immediately)
                .padding(.horizontal)
            } // End GeometryReader
            .toolbar {
                if !viewModel.showSuccessfulAutomation {
                    ToolbarDismissButtonView {
                        if viewModel.isAutomationInCreation() {
                            viewModel.presentingConfirmationDialog.toggle()
                        } else {
                            dismiss()
                        }
                    }
                    
                    ToolbarCreateButtonView(isActive: viewModel.validateAutomation()) {
                        viewModel.createNewAutomation()
                        if hapticFeedback {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    }
                    
                    ToolbarDismissKeyboardButtonView()
                }
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
