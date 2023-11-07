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
    
    //Custom type
    @Binding var account: Account?
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    @ObservedObject var predefinedObjectManager = PredefinedObjectManager.shared
    @StateObject private var viewModel = AddTransactionViewModel()
    
    //Environnements
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: Store
    
    //State or Binding String
    
    //State or Binding Int, Float and Double
    @State private var confettiCounter: Int = 0
    @State private var showCheckmark = -60
    
    //State or Binding Bool
    @State private var update: Bool = false
    @State private var showCategories: Bool = false
    @State private var showAlertNoSpendChallenge: Bool = false
    
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
                if !viewModel.showSuccessfulTransaction {
                    VStack { //New Transaction
                        DismissButtonInSheet()
                        
                        VStack {
                            HStack {
                                Spacer()
                                Text(NSLocalizedString("transaction_new", comment: ""))
                                    .titleAdjustSize()
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            
                            if userDefaultsManager.isBuyingQualityEnable && viewModel.transactionType == .expense {
                                Text(NSLocalizedString("transaction_alert_quality_purchase", comment: ""))
                                    .font(Font.mediumText16())
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 8)
                            }
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
                                            Text(NSLocalizedString("transaction_recommended_category", comment: "") + " : ")
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
                            
                            TextField(NSLocalizedString("transaction_title", comment: ""), text: $viewModel.transactionTitle.animation())
                                .focused($focusedField, equals: .title)
                                .multilineTextAlignment(.center)
                                .font(.semiBoldCustom(size: isLittleIphone ? 24 : 30))
                                .padding(.horizontal, 8)
                        }
                        
                        TextField(NSLocalizedString("transaction_placeholder_amount", comment: ""), value: $viewModel.transactionAmount.animation(), formatter: numberFormatter)
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
                                               textLeft: NSLocalizedString("word_expense", comment: ""),
                                               textRight: NSLocalizedString("word_income", comment: ""),
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
                        
                        cellForAlerts()
                        
                        Spacer()
                        
                        // Validate Button
                        CreateButton(action: {
                            if userDefaultsManager.isNoSpendChallengeEnbale {
                                showAlertNoSpendChallenge.toggle()
                            } else { viewModel.createNewTransaction() }
                            if userDefaultsManager.hapticFeedback { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                        }, validate: viewModel.validateTrasaction())
                        .padding(.horizontal, 8)
                        .padding(.bottom)
                    } // End New Transaction
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .alert(NSLocalizedString("transaction_alert_no_spend_challenge_title", comment: ""), isPresented: $showAlertNoSpendChallenge, actions: {
                        Button(role: .destructive, action: { viewModel.createNewTransaction() }, label: { Text(NSLocalizedString("word_yes", comment: "")) })
                    }, message: {
                        Text(NSLocalizedString("transaction_alert_no_spend_challenge_desc", comment: ""))
                    })
                } else {
                    VStack { // Successful Transaction
                        CircleWithCheckmark()
                            .padding(.vertical, 50)
                            .confettiCannon(counter: $confettiCounter, num: 50, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
                        
                        VStack(spacing: 20) {
                            Text(NSLocalizedString("transaction_successful", comment: ""))
                                .font(.semiBoldCustom(size: 28))
                                .foregroundColor(colorScheme == .light ? .secondary500 : .primary0)
                            
                            Text(NSLocalizedString("transaction_successful_desc", comment: ""))
                                .font(Font.mediumSmall())
                                .foregroundColor(.secondary400)
                        }
                        .padding(.bottom, 30)
                        
                        if let theNewTransaction = viewModel.theNewTransaction {
                            VStack {
                                CellTransactionWithoutAction(transaction: theNewTransaction, update: $update)
                                
                                HStack {
                                    Text(NSLocalizedString("transaction_successful_date", comment: ""))
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
                        
                        if let theNewTransaction = viewModel.theNewTransaction {
                            if userDefaultsManager.isPayingYourselfFirstEnable && theNewTransaction.amount > 0 {
                                NavigationLink(destination: {
                                    AdviceView()
                                }, label: { LabelForCellAdvice(colorCell: true) })
                            }
                        }
                        
                        if let account, viewModel.numberOfAlertsForSuccessful != 0 {
                            NavigationLink(destination: {
                                AlertViewForSuccessful(account: account, subcategory: viewModel.selectedSubcategory, isCardLimitSoonExceed: viewModel.isCardLimitSoonToBeExceeded, isCardLimitExceeded: viewModel.isCardLimitExceeded, isBudgetSoonExceed: viewModel.isBudgetSoonToBeExceeded, isBudgetExceeded: viewModel.isBudgetExceed)
                            }, label: { LabelForCellAlerts(numberOfAlert: viewModel.numberOfAlertsForSuccessful, colorCell: true) })
                            .padding(.top)
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
    } // END body
    
    //MARK: - ViewBuilder
    @ViewBuilder
    func cellForAlerts() -> some View {
        if viewModel.numberOfAlerts != 0 {
            NavigationLink(destination: {
                AlertsView(
                    isAccountWillBeNegative: viewModel.isAccountWillBeNegative,
                    isCardLimitExceeds: viewModel.isCardLimitExceeds,
                    isBudgetIsExceeded: viewModel.isBudgetIsExceededAfterThisTransaction,
                    isDuplicateTransactions: viewModel.isDuplicateTransactions
                )
            }, label: { LabelForCellAlerts(numberOfAlert:viewModel.numberOfAlerts) })
        }
    }
    
}//END struct

//MARK: - Preview
struct AddTransactionView_Previews: PreviewProvider {
    
    @State static var previewBool: Bool = false
    @State static var previewAccount: Account? = previewAccount1()
    
    static var previews: some View {
        AddTransactionView(account: $previewAccount)
    }
}
