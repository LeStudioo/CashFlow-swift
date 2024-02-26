//
//  AddAutomationsView.swift
//  CashFlow
//
//  Created by KaayZenn on 18/07/2023.
//
// Localizations 30/09/2023

import SwiftUI
import Combine
import ConfettiSwiftUI

struct AddAutomationsView: View {

    // Custom type
    @StateObject private var viewModel = AddAutomationViewModel()

    // Environement
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) private var viewContext

    // Preferences
    @Preference(\.hapticFeedback) private var hapticFeedback

    //State or Binding Int, Float and Double
    @State private var confettiCounter: Int = 0

    //State or Binding Bool
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
                if !viewModel.showSuccessfulAutomation {
                    VStack { //New Transaction
                        DismissButtonInSheet()
                        
                        Text("automation_new".localized)
                            .titleAdjustSize()
                         
                        if viewModel.typeTransaction == .expense {
                            HStack {
                                Spacer()
                                categoryButton()
                                Spacer()
                            }
                            .padding()
                        }
                        
                        TextField("automation_title".localized, text: $viewModel.titleTransaction)
                            .focused($focusedField, equals: .title)
                            .multilineTextAlignment(.center)
                            .font(.semiBoldCustom(size: isLittleIphone ? 24 : 30))
                        
                        TextField("automation_placeholder_amount".localized, value: $viewModel.amountTransaction.animation(), formatter: numberFormatter)
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
                            .onReceive(Just(viewModel.amountTransaction)) { newValue in
                                if viewModel.amountTransaction > 1_000_000_000 {
                                    let numberWithoutLastDigit = HelperManager().removeLastDigit(from: viewModel.amountTransaction)
                                    self.viewModel.amountTransaction = numberWithoutLastDigit
                                }
                            }
                        
                        CustomSegmentedControl(selection: $viewModel.typeTransaction,
                                               textLeft: "word_expense".localized,
                                               textRight: "word_income".localized,
                                               height: isLittleIphone ? 40 : 50)
                        .padding(.horizontal)
                        .padding(.bottom)
                        
                        // Sélection d'une date
                        ZStack {
                            Capsule()
                                .frame(height: isLittleIphone ? 40 : 50)
                                .foregroundColor(Color.color3Apple)
                            
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
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        CreateButton(action: {
                            viewModel.createNewAutomation()
                            if hapticFeedback { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                        }, validate: viewModel.validateAutomation())
                        .ignoresSafeArea(.keyboard)
                        .padding(.horizontal, 8)
                        .padding(.bottom)
                    } // End New Transaction
                } else {
                    VStack { // Successful Transaction
                        CircleWithCheckmark()
                            .padding(.vertical, 50)
                            .confettiCannon(counter: $confettiCounter, num: 50, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
                        
                        VStack(spacing: 20) {
                            Text("automation_successful".localized)
                                .font(.semiBoldCustom(size: 28))
                                .foregroundColor(colorScheme == .light ? .secondary500 : .primary0)
                            
                            Text("automation_successful_desc".localized)
                                .font(Font.mediumSmall())
                                .foregroundColor(.secondary400)
                        }
                        .padding(.bottom, 30)
                        
                        if let theNewTransaction = viewModel.theNewTransaction {
                            VStack {
                                CellTransactionWithoutAction(transaction: theNewTransaction)
                                
                                HStack {
                                    Text("automation_successful_date".localized)
                                        .font(Font.mediumSmall())
                                        .foregroundColor(.secondary400)
                                    Spacer()
                                    if let theNewAutomation = viewModel.theNewAutomation {
                                        Text(theNewAutomation.date.formatted(date: .abbreviated, time: .omitted))
                                            .font(.semiBoldSmall())
                                            .foregroundColor(colorScheme == .light ? .secondary500 : .primary0)
                                    }
                                }
                                .padding(.horizontal, 8)
                            }
                            .padding()
                        }
                        
                        Spacer()
                        
                        ValidateButton(action: { dismiss() }, validate: true)
                            .padding(.horizontal, 8)
                            .padding(.bottom)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { confettiCounter += 1 }
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
            .onChange(of: viewModel.typeTransaction, perform: { newValue in
                if newValue == .income {
                    viewModel.selectedCategory = categoryPredefined0
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
            .background(Color.color2Apple.edgesIgnoringSafeArea(.all).onTapGesture { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) } )
            .sheet(isPresented: $showCategories) {
                WhatCategoryView(selectedCategory: $viewModel.selectedCategory, selectedSubcategory: $viewModel.selectedSubcategory)
            }
            .alert(item: $viewModel.info, content: { info in
                Alert(title: Text(info.title),
                      message: Text(info.message),
                      dismissButton: .cancel(Text("word_ok".localized)) { return })
            })
        } // End NavigationStack
    }//END body
    
    //MARK: ViewBuilder
    func categoryButton() -> some View {
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
            } else if let selectedCategory = viewModel.selectedCategory, viewModel.selectedSubcategory == nil {
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
    }
} // END struct

//MARK: - Preview
#Preview {
    AddAutomationsView()
}
