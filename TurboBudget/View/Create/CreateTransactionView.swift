//
//  CreateTransactionView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//
// Localizations 30/09/2023

import SwiftUI

struct CreateTransactionView: View {
    
    // Builder
    let router: NavigationManager = .init(isPresented: .constant(.createTransaction))
    
    // Custom
    @StateObject private var viewModel = CreateTransactionViewModel()
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var successfullModalManager: SuccessfullModalManager

    // EnvironmentObject
    @EnvironmentObject var store: SubscriptionManager
    
    // Number variables
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
                        VStack { //New TransactionEntity
                            
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
                                
                                if store.isCashFlowPro && viewModel.selectedCategory == nil {
                                    let bestCategory = TransactionEntity.findBestCategory(for: viewModel.transactionTitle)
                                    
                                    if let categoryFound = bestCategory.0 {
                                        let subcategoryFound = bestCategory.1
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
                                            if categoryFound == PredefinedCategory.PREDEFCAT0 {
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
                                .padding(isLittleIphone ? 8 : 16)
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
                            
                        } // End New TransactionEntity
                } // End ScrollView
                .scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.immediately)
                .padding(.horizontal)
            } // End GeometryReader
            .toolbar {
                ToolbarDismissButtonView {
                    if viewModel.isTransactionInCreation() {
                        viewModel.presentingConfirmationDialog.toggle()
                    } else {
                        dismiss()
                    }
                }
                
                ToolbarCreateButtonView(isActive: viewModel.validateTrasaction()) {
                    VibrationManager.vibration()
                    viewModel.createNewTransaction { withError in
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
