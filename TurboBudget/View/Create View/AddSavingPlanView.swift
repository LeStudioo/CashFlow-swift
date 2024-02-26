//
//  AddSavingPlanView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 20/06/2023.
//
// Localizations 30/09/2023

import SwiftUI
import Combine
import ConfettiSwiftUI

struct AddSavingPlanView: View {
    
    // Custom type
    @StateObject private var viewModel = AddSavingPlanViewModel()
    
    // Environement
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    // EnvironmentObject
    @EnvironmentObject var account: Account
    
    // Preferences
    @Preference(\.hapticFeedback) private var hapticFeedback
    
    //State or Binding Int, Float and Double
    @State private var confettiCounter: Int = 0
    
    //State or Binding Bool
    @State private var showSettings: Bool = false
    
    //State or Binding Bool - Successful
    
    //State or Binding Date
    
    //Enum
    enum Field: CaseIterable {
        case emoji, title, amountOfStart, amountOfEnd
    }
    @FocusState var focusedField: Field?
    
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
                if !viewModel.showSuccessfulSavingPlan {
                    VStack {
                        DismissButtonInSheet()
                        
                        Text("savingsplan_new".localized)
                            .titleAdjustSize()
                        
                        ZStack {
                            Circle()
                                .foregroundColor(.color3Apple)
                            
                            if viewModel.savingPlanEmoji.isEmpty && focusedField != .emoji {
                                Image(systemName: "plus")
                                    .font(.system(size: isLittleIphone ? 26 : 32, weight: .regular, design: .rounded))
                                    .foregroundColor(.colorLabel)
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
                                    .foregroundColor(Color.color3Apple)
                                TextField("savingsplan_emoji".localized, text: $viewModel.savingPlanEmoji.max(1))
                                    .focused($focusedField, equals: .emoji)
                                    .padding(.horizontal)
                            }
                            .frame(width: 100, height: 40)
                        }
                        
                        TextField("savingsplan_title".localized, text: $viewModel.savingPlanTitle)
                            .focused($focusedField, equals: .title)
                            .multilineTextAlignment(.center)
                            .font(.semiBoldCustom(size: isLittleIphone ? 24 : 30))
                        
                        HStack {
                            VStack(alignment: .center, spacing: 2) {
                                Text("savingsplan_start".localized)
                                    .font(Font.mediumText16())
                                TextField("savingsplan_placeholder_amount".localized, value: $viewModel.savingPlanAmountOfStart.animation(), formatter: numberFormatter)
                                    .focused($focusedField, equals: .amountOfStart)
                                    .font(.semiBoldCustom(size: 30))
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.decimalPad)
                                    .onReceive(Just(viewModel.savingPlanAmountOfStart)) { newValue in
                                        if viewModel.savingPlanAmountOfStart > 1_000_000_000 {
                                            let numberWithoutLastDigit = HelperManager().removeLastDigit(from: viewModel.savingPlanAmountOfStart)
                                            viewModel.savingPlanAmountOfStart = numberWithoutLastDigit
                                        }
                                    }
                            }
                            
                            VStack(alignment: .center, spacing: 2) {
                                Text("savingsplan_end".localized)
                                    .font(Font.mediumText16())
                                TextField("savingsplan_placeholder_amount".localized, value: $viewModel.savingPlanAmountOfEnd.animation(), formatter: numberFormatter)
                                    .focused($focusedField, equals: .amountOfEnd)
                                    .font(.semiBoldCustom(size: 30))
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.decimalPad)
                                    .onReceive(Just(viewModel.savingPlanAmountOfEnd)) { newValue in
                                        if viewModel.savingPlanAmountOfEnd > 1_000_000_000 {
                                            let numberWithoutLastDigit = HelperManager().removeLastDigit(from: viewModel.savingPlanAmountOfEnd)
                                            viewModel.savingPlanAmountOfEnd = numberWithoutLastDigit
                                        }
                                    }
                            }
                        }
                        .padding(8)
                        
                        VStack {
                            ZStack {
                                Capsule()
                                    .frame(height: 50)
                                    .foregroundColor(Color.color3Apple)
                                
                                HStack {
                                    Spacer()
                                    Toggle("savingsplan_end_date".localized, isOn: $viewModel.isEndDate.animation())
                                        .font(Font.mediumText16())
                                        .padding(.horizontal)
                                }
                            }
                            .padding()
                            
                            if viewModel.isEndDate {
                                ZStack {
                                    Capsule()
                                        .frame(height: 50)
                                        .foregroundColor(Color.color3Apple)
                                    
                                    HStack {
                                        Spacer()
                                        DatePicker("savingsplan_end_date_picker".localized, selection: $viewModel.savingPlanDateOfEnd, in: Date()..., displayedComponents: [.date])
                                            .font(Font.mediumText16())
                                            .padding(.horizontal)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        Spacer()
                        
                        CreateButton(action: {
                            viewModel.createSavingPlan()
                            if hapticFeedback { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                        }, validate: viewModel.validateSavingPlan())
                            .padding(.horizontal, 8)
                            .padding(.bottom)
                    }
                } else {
                    VStack { // Successful Saving Plan
                        CircleWithCheckmark()
                            .padding(.vertical, 50)
                            .confettiCannon(counter: $confettiCounter, num: 50, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
                        
                        VStack(spacing: 20) {
                            Text("savingsplan_successful".localized)
                                .font(.semiBoldCustom(size: 28))
                                .foregroundColor(colorScheme == .light ? .secondary500 : .primary0)
                            
                            Text("savingsplan_successful_desc".localized)
                                .font(Font.mediumSmall())
                                .foregroundColor(.secondary400)
                        }
                        .padding(.bottom, 30)
                        
                        if let theNewSavingPlan = viewModel.theNewSavingPlan {
                            VStack {
                                CellSavingPlanView(savingPlan: theNewSavingPlan)
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                        
                        ValidateButton(action: { dismiss() }, validate: true)
                            .padding(.horizontal, 8)
                            .padding(.bottom)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            confettiCounter += 1
                        }
                    }
                }
            }
            .ignoresSafeArea(.keyboard)
            .onChange(of: focusedField, perform: { newValue in
                if newValue != .emoji { withAnimation { viewModel.isEmoji = false } }
            })
            .background(Color.color2Apple.edgesIgnoringSafeArea(.all).onTapGesture { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) } )
            .toolbar {
                if focusedField != .title {
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
//            .sheet(isPresented: $showSettings, content: {
//                SettingsHomeView()
//            })
        } // End NavigationStack
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    AddSavingPlanView()
}
