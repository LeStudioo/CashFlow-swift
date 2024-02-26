//
//  AddTransactionView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//
// Localizations 30/09/2023

import SwiftUI
import Combine
import ConfettiSwiftUI

struct AddTransactionView: View {
    
    // Custom type
    @StateObject private var viewModel = AddTransactionViewModel()
    @ObservedObject var predefinedObjectManager = PredefinedObjectManager.shared
    
    // Environement
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss

    // EnvironmentObject
    @EnvironmentObject var account: Account
    @EnvironmentObject var store: Store
    
    // Preferences
    @Preference(\.hapticFeedback) private var hapticFeedback
    
    // Number variables
    @State private var confettiCounter: Int = 0
    @State private var showCheckmark = -60
    
    // Bool variables
    @State private var showCategories: Bool = false
    
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
        NavigationStack {
            VStack {
                if !viewModel.showSuccessfulTransaction {
                    VStack { //New Transaction
                        DismissButtonInSheet()
                        
                        VStack {
                            HStack {
                                Spacer()
                                Text("transaction_new".localized)
                                    .titleAdjustSize()
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            
                            VStack {
                                if viewModel.transactionType == .expense {
                                    HStack {
                                        Spacer()
                                        Button(action: { showCategories.toggle() }, label: {
                                            if let selectedCategory = viewModel.selectedCategory, let selectedSubcategory = viewModel.selectedSubcategory {
                                                ZStack {
                                                    Circle()
                                                        .frame(width: widthCircleCategory, height: widthCircleCategory)
                                                        .foregroundColor(selectedCategory.color)
                                                    
                                                    Image(systemName: selectedSubcategory.icon)
                                                        .font(.system(size: isLittleIphone ? 26 : 32, weight: .bold, design: .rounded))
                                                        .foregroundColor(.colorLabelInverse)
                                                }
                                            } else if let selectedCategory = viewModel.selectedCategory, viewModel.selectedSubcategory == nil { //Ne peut pas arriver
                                                ZStack {
                                                    Circle()
                                                        .frame(width: widthCircleCategory, height: widthCircleCategory)
                                                        .foregroundColor(selectedCategory.color)
                                                    
                                                    Image(systemName: selectedCategory.icon)
                                                        .font(.system(size: isLittleIphone ? 26 : 32, weight: .bold, design: .rounded))
                                                        .foregroundColor(.colorLabelInverse)
                                                }
                                            } else {
                                                ZStack {
                                                    Circle()
                                                        .frame(width: widthCircleCategory, height: widthCircleCategory)
                                                        .foregroundColor(.color3Apple)
                                                    
                                                    Image(systemName: "plus")
                                                        .font(.system(size: isLittleIphone ? 26 : 32, weight: .regular, design: .rounded))
                                                        .foregroundColor(.colorLabel)
                                                }
                                            }
                                        })
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
                                        VStack(spacing: 0) {
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
                            .padding(.top)
                            .padding(.bottom, 8)
                            
                            TextField("transaction_title".localized, text: $viewModel.transactionTitle.animation())
                                .focused($focusedField, equals: .title)
                                .multilineTextAlignment(.center)
                                .font(.semiBoldCustom(size: isLittleIphone ? 24 : 30))
                                .padding(.horizontal, 8)
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
                            .background(Color.color3Apple.cornerRadius(100))
                            .padding()
                            .onReceive(Just(viewModel.transactionAmount)) { newValue in
                                if viewModel.transactionAmount > 1_000_000_000 {
                                    let numberWithoutLastDigit = HelperManager().removeLastDigit(from: viewModel.transactionAmount)
                                    viewModel.transactionAmount = numberWithoutLastDigit
                                }
                            }
                        
                        CustomSegmentedControl(selection: $viewModel.transactionType,
                                               textLeft: "word_expense".localized,
                                               textRight: "word_income".localized,
                                               height: isLittleIphone ? 40 : 50)
                        .padding(.horizontal)
                        
                        ZStack {
                            Capsule()
                                .frame(height: isLittleIphone ? 40 : 50)
                                .foregroundColor(Color.color3Apple)
                            
                            HStack {
                                Spacer()
                                DatePicker("\(viewModel.transactionDate.formatted())", selection: $viewModel.transactionDate.animation(), displayedComponents: [.date])
                                    .labelsHidden()
                                    .clipped()
                                    .padding(.horizontal)
                            }
                        }
                        .padding()

                        Spacer()
                        
                        // Validate Button
                        CreateButton(action: {
                            viewModel.createNewTransaction()
                            if hapticFeedback { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                        }, validate: viewModel.validateTrasaction())
                        .padding(.horizontal, 8)
                        .padding(.bottom)
                    } // End New Transaction
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                } else {
                    VStack { // Successful Transaction
                        CircleWithCheckmark()
                            .padding(.vertical, 50)
                            .confettiCannon(counter: $confettiCounter, num: 50, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
                        
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
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                        
                        ValidateButton(action: { dismiss() }, validate: true)
                            .padding(.horizontal, 8)
                            .padding(.bottom)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { confettiCounter += 1 }
                        showCheckmark = 0
                    }
                }
            }
            .ignoresSafeArea(.keyboard)
            .toolbar {
                if focusedField == .amount {
                    ToolbarItem(placement: .keyboard) {
                        HStack {
                            EmptyView()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Button(action: { focusedField = nil }, label: { Image(systemName: "keyboard.chevron.compact.down.fill").foregroundColor(HelperManager().getAppTheme().color) })
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
            .background(Color.color2Apple.edgesIgnoringSafeArea(.all).onTapGesture { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) } )
            .sheet(isPresented: $showCategories) {
                WhatCategoryView(selectedCategory: $viewModel.selectedCategory, selectedSubcategory: $viewModel.selectedSubcategory)
            }
        } // End NavigationStack
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    AddTransactionView()
}
