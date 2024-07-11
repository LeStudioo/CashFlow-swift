//
//  CreateTransactionView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//
// Localizations 30/09/2023

import SwiftUI
import ConfettiSwiftUI

struct CreateTransactionView: View {
    
    // Builder
    let router: NavigationManager = .init(isPresented: .constant(.createTransaction))
    
    // Custom
    @StateObject private var viewModel = AddTransactionViewModel()
    @ObservedObject var predefinedObjectManager = PredefinedObjectManager.shared
    
    // Environment
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
                                                .foregroundStyle(.green)
                                            
                                            Image(systemName: "tray.and.arrow.down")
                                                .font(.system(size: isLittleIphone ? 26 : 32, weight: .bold, design: .rounded))
                                                .foregroundStyle(Color(uiColor: .systemBackground))
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
                            
                            TextField("0.00", text: $viewModel.transactionAmount.max(9).animation())
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
                                    .foregroundStyle(Color.backgroundComponentSheet)
                                
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
                                    .foregroundStyle(Color(uiColor: .label))
                                
                                Text("transaction_successful_desc".localized)
                                    .font(Font.mediumSmall())
                                    .foregroundStyle(.secondary400)
                            }
                            .padding(.bottom, 30)
                            
                            if let theNewTransaction = viewModel.theNewTransaction {
                                VStack {
                                    CellTransactionWithoutAction(transaction: theNewTransaction)
                                    
                                    HStack {
                                        Text("transaction_successful_date".localized)
                                            .font(Font.mediumSmall())
                                            .foregroundStyle(.secondary400)
                                        Spacer()
                                        Text(theNewTransaction.date.formatted(date: .abbreviated, time: .omitted))
                                            .font(.semiBoldSmall())
                                            .foregroundStyle(Color(uiColor: .label))
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
    CreateTransactionView()
}
