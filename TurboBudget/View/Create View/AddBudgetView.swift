//
//  AddBudgetView.swift
//  CashFlow
//
//  Created by KaayZenn on 03/08/2023.
//
// Localizations 30/09/2023

import SwiftUI
import Combine

struct AddBudgetView: View {
    
    // Custom type
    @StateObject private var viewModel = AddBudgetViewModel()
    
    // Environement
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    // Preferences
    @Preference(\.hapticFeedback) private var hapticFeedback
    
    //State or Binding Bool
    @State private var update: Bool = false
    @State private var showCategories: Bool = false
    
    //Enum
    enum Field: CaseIterable {
        case amount, title
    }
    @FocusState var focusedField: Field?
    
    //Computed var
    var widthCircleCategory: CGFloat {
        return isLittleIphone ? 80 : 100
    }
    
    //Other
    var numberFormatter: NumberFormatter {
        let numFor = NumberFormatter()
        numFor.numberStyle = .decimal
        numFor.zeroSymbol = ""
        return numFor
    }
    
    //MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                DismissButtonInSheet()
                
                Text("budget_new".localized)
                    .titleAdjustSize()
                
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
                        } else if let selectedCategory = viewModel.selectedCategory,viewModel.selectedSubcategory == nil {
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
                .padding()
                .sheet(isPresented: $showCategories) {
                    WhatCategoryView(selectedCategory: $viewModel.selectedCategory, selectedSubcategory: $viewModel.selectedSubcategory)
                }
                .onChange(of: viewModel.selectedCategory) { _ in
                    update.toggle()
                }
                .onChange(of: viewModel.selectedSubcategory) { _ in
                    update.toggle()
                }
                
                TextField(
                    "budget_placeholder_amount".localized,
                    value: $viewModel.amountBudget.animation(),
                    formatter: numberFormatter
                )
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
                .onReceive(Just(viewModel.amountBudget)) { newValue in
                    if viewModel.amountBudget > 1_000_000_000 {
                        let numberWithoutLastDigit = HelperManager().removeLastDigit(from: viewModel.amountBudget)
                        self.viewModel.amountBudget = numberWithoutLastDigit
                    }
                }
                
                Spacer()
                
                CreateButton(action: {
                    viewModel.createNewBudget()
                    if hapticFeedback { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                    dismiss()
                }, validate: viewModel.validateBudget())
                .ignoresSafeArea(.keyboard)
                .padding(.horizontal, 8)
                .padding(.bottom)
            }
            .padding(update ? 0 : 0)
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
        }
    } // END body
} // END struct

//MARK: - Preview
#Preview {
    AddBudgetView()
}
