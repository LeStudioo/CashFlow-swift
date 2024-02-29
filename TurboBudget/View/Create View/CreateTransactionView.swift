//
//  CreateTransactionView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//
// Localizations 30/09/2023

import SwiftUI
import Combine
import ConfettiSwiftUI

struct CreateTransactionView: View {
    
    // Builder
    var router: NavigationManager
    
    // Custom
    @StateObject private var viewModel = AddTransactionViewModel()
    @ObservedObject var predefinedObjectManager = PredefinedObjectManager.shared
    
    // Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss

    // EnvironmentObject
    @EnvironmentObject var store: Store
    
    // Preferences
    @Preference(\.hapticFeedback) private var hapticFeedback
    
    // Number variables
    @State private var confettiCounter: Int = 0
    @State private var showCheckmark = -60
    
    // Enum
    enum Field: CaseIterable {
        case amount, title
    }
    @FocusState var focusedField: Field?
    
    // Computed var
    var widthCircleCategory: CGFloat {
        return isLittleIphone ? 80 : 100
    }
    
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
            GeometryReader { geometry in
                ScrollView {
                    if !viewModel.showSuccessfulTransaction {
                        VStack { //New Transaction
                            
                            
                            Text("transaction_new".localized)
                                .titleAdjustSize()
                                .padding(.vertical, 24)
                            
                            VStack {
                                if viewModel.transactionType == .expense {
                                    HStack {
                                        Spacer()
                                        SelectCategoryButtonView(
                                            router: router,
                                            selectedCategory: $viewModel.selectedCategory,
                                            selectedSubcategory: $viewModel.selectedSubcategory
                                        )
                                        Spacer()
                                    }
                                } else {
                                    HStack {
                                        Spacer()
                                        ZStack {
                                            Circle()
                                                .frame(width: widthCircleCategory, height: widthCircleCategory)
                                                .foregroundColor(.green)
                                            
                                            Image(systemName: "tray.and.arrow.down")
                                                .font(.system(size: isLittleIphone ? 26 : 32, weight: .bold, design: .rounded))
                                                .foregroundColor(.colorLabelInverse)
                                        }
                                        Spacer()
                                    }
                                }
                                
                                if store.isLifetimeActive && viewModel.selectedCategory == nil {
                                    if let categoryFound = viewModel.automaticCategorySearch().0 {
                                        let subcategoryFound = viewModel.automaticCategorySearch().1
                                        VStack(spacing: 4) {
                                            Text("transaction_recommended_category".localized + " : ")
                                            HStack {
                                                Image(systemName: categoryFound.icon)
                                                Text("\(subcategoryFound != nil ? subcategoryFound!.title : categoryFound.title)")
                                            }
                                            .foregroundStyle(categoryFound.color)
                                        }
                                        .font(.mediumText16())
                                        .onTapGesture {
                                            if categoryFound == categoryPredefined0 {
                                                withAnimation { viewModel.transactionType = .income }
                                            } else {
                                                viewModel.selectedCategory = categoryFound
                                                withAnimation { viewModel.transactionType = .expense }
                                            }
                                            if let subcategoryFound { viewModel.selectedSubcategory = subcategoryFound }
                                        }
                                        .padding(.top, 8)
                                    }
                                }
                            } // End Select Category
                            .padding(.bottom, 24)
                            
                            TextField("transaction_title".localized, text: $viewModel.transactionTitle.animation())
                                .focused($focusedField, equals: .title)
                                .multilineTextAlignment(.center)
                                .font(.semiBoldCustom(size: isLittleIphone ? 24 : 30))
                                .padding(8)
                                .background(Color.backgroundComponentSheet.cornerRadius(100))
                                .padding(.bottom, 24)
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedField = .amount
                                }
                            
                            TextField("transaction_placeholder_amount".localized, value: $viewModel.transactionAmount.animation(), formatter: numberFormatter)
                                .focused($focusedField, equals: .amount)
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
                                .onReceive(Just(viewModel.transactionAmount)) { newValue in
                                    if viewModel.transactionAmount > 1_000_000_000 {
                                        let numberWithoutLastDigit = HelperManager().removeLastDigit(from: viewModel.transactionAmount)
                                        viewModel.transactionAmount = numberWithoutLastDigit
                                    }
                                }
                            
                            CustomSegmentedControl(
                                selection: $viewModel.transactionType,
                                textLeft: "word_expense".localized,
                                textRight: "word_income".localized,
                                height: isLittleIphone ? 40 : 50
                            )
                            .padding(.bottom, 24)
                            
                            ZStack {
                                Capsule()
                                    .frame(height: isLittleIphone ? 40 : 50)
                                    .foregroundColor(Color.backgroundComponentSheet)
                                
                                HStack {
                                    Spacer()
                                    DatePicker("\(viewModel.transactionDate.formatted())", selection: $viewModel.transactionDate.animation(), displayedComponents: [.date])
                                        .labelsHidden()
                                        .clipped()
                                        .padding(.horizontal)
                                }
                            }
                            .padding(.bottom, 24)
                            
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
                                Text("transaction_successful".localized)
                                    .font(.semiBoldCustom(size: 28))
                                    .foregroundColor(colorScheme == .light ? .secondary500 : .primary0)
                                
                                Text("transaction_successful_desc".localized)
                                    .font(Font.mediumSmall())
                                    .foregroundColor(.secondary400)
                            }
                            .padding(.bottom, 30)
                            
                            if let theNewTransaction = viewModel.theNewTransaction {
                                VStack {
                                    CellTransactionWithoutAction(transaction: theNewTransaction)
                                    
                                    HStack {
                                        Text("transaction_successful_date".localized)
                                            .font(Font.mediumSmall())
                                            .foregroundColor(.secondary400)
                                        Spacer()
                                        Text(theNewTransaction.date.formatted(date: .abbreviated, time: .omitted))
                                            .font(.semiBoldSmall())
                                            .foregroundColor(colorScheme == .light ? .secondary500 : .primary0)
                                    }
                                    .padding(.horizontal, 8)
                                }
                            }
                            
                            Spacer()
                            
                            ValidateButton(action: { dismiss() }, validate: true)
                                .padding(.bottom)
                        }
                        .frame(minHeight: geometry.size.height)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { 
                                confettiCounter += 1
                            }
                            showCheckmark = 0
                        }
                    }
                } // End ScrollView
                .scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.immediately)
                .padding(.horizontal)
            } // End GeometryReader
            .toolbar {
                if !viewModel.showSuccessfulTransaction {
                    ToolbarDismissButtonView {
                        if viewModel.isTransactionInCreation() {
                            viewModel.presentingConfirmationDialog.toggle()
                        } else {
                            dismiss()
                        }
                    }
                    
                    ToolbarCreateButtonView(isActive: viewModel.validateTrasaction()) {
                        viewModel.createNewTransaction()
                        if hapticFeedback {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    }
                    
                    ToolbarDismissKeyboardButtonView()
                }
            }
        } // End NavStack
        .interactiveDismissDisabled(viewModel.isTransactionInCreation()) {
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
    CreateTransactionView(router: .init(isPresented: .constant(.createTransaction)))
}
