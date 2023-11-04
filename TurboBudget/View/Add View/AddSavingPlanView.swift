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
    
    //Custom type
    @Binding var account: Account?
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    @State private var theNewSavingPlan: SavingPlan? = nil
    
    //Environnements
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    //State or Binding String
    @State private var title: String = ""
    @State private var emoji: String = ""
    
    //State or Binding Int, Float and Double
    @State private var amountOfStart: Double = 0.0
    @State private var amountOfEnd: Double = 0.0
    @State private var confettiCounter: Int = 0
    
    //State or Binding Bool
    @State private var update: Bool = false
    @State private var showSettings: Bool = false
    @State private var showSuccessfulSavingPlan: Bool = false
    
    //State or Binding Bool - Successful
    @State private var isCardLimitSoonToBeExceeded: Bool = false
    @State private var isCardLimitExceeded: Bool = false
    
    //State or Binding Date
    @State private var dateOfEnd: Date = .now
    @State private var isEndDate: Bool = false
    @State private var isEmoji: Bool = false
    
    //Enum
    enum Field: CaseIterable {
        case emoji, title, amountOfStart, amountOfEnd
    }
    @FocusState var focusedField: Field?
    
    //Computed var
    var isCardLimitExceeds: Bool {
        if let account, account.cardLimit != 0, userDefaultsManager.blockExpensesIfCardLimitExceeds {
            let cardLimitAfterTransaction = account.amountOfExpensesInActualMonth() + amountOfStart
            if cardLimitAfterTransaction <= account.cardLimit { return false } else { return true }
        } else { return false }
    }
    
    var isAccountWillBeNegative: Bool {
        if let account, !userDefaultsManager.accountCanBeNegative {
            if account.balance - amountOfStart < 0 { return true }
        }
        return false
    }
    
    var isStartTallerThanEnd: Bool {
        if amountOfStart > amountOfEnd { return true } else { return false }
    }
    
    var numberOfAlerts: Int {
        var num: Int = 0
        if isCardLimitExceeds { num += 1 }
        if isAccountWillBeNegative { num += 1 }
        if isStartTallerThanEnd { num += 1 }
        return num
    }
    
    var numberOfAlertsForSuccessful: Int {
        var num: Int = 0
        if isCardLimitSoonToBeExceeded { num += 1 }
        if isCardLimitExceeded { num += 1 }
//        if let account {
//            if account.amountOfExpensesInActualMonth() > account.cardLimit { num += 1 }
//        }
        return num
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
                if !showSuccessfulSavingPlan {
                    VStack {
                        DismissButtonInSheet()
                        
                        Text(NSLocalizedString("savingsplan_new", comment: ""))
                            .titleAdjustSize()
                        
                        ZStack {
                            Circle()
                                .foregroundColor(.color3Apple)
                            
                            if emoji.isEmpty && focusedField != .emoji {
                                Image(systemName: "plus")
                                    .font(.system(size: isLittleIphone ? 26 : 32, weight: .regular, design: .rounded))
                                    .foregroundColor(.colorLabel)
                            } else {
                                Text(emoji)
                                    .font(.system(size: 42))
                            }
                        }
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            withAnimation {
                                isEmoji.toggle()
                                focusedField = .emoji
                            }
                        }
                        
                        if isEmoji {
                            ZStack {
                                Capsule()
                                    .foregroundColor(Color.color3Apple)
                                TextField(NSLocalizedString("savingsplan_emoji", comment: ""), text: $emoji.max(1))
                                    .focused($focusedField, equals: .emoji)
                                    .padding(.horizontal)
                            }
                            .frame(width: 100, height: 40)
                        }
                        
                        TextField(NSLocalizedString("savingsplan_title", comment: ""), text: $title)
                            .focused($focusedField, equals: .title)
                            .multilineTextAlignment(.center)
                            .font(.semiBoldCustom(size: isLittleIphone ? 24 : 30))
                        
                        HStack {
                            VStack(alignment: .center, spacing: 2) {
                                Text(NSLocalizedString("savingsplan_start", comment: ""))
                                    .font(Font.mediumText16())
                                TextField(NSLocalizedString("savingsplan_placeholder_amount", comment: ""), value: $amountOfStart.animation(), formatter: numberFormatter)
                                    .focused($focusedField, equals: .amountOfStart)
                                    .font(.semiBoldCustom(size: 30))
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.decimalPad)
                                    .onReceive(Just(amountOfStart)) { newValue in
                                        if amountOfStart > 1_000_000_000 {
                                            let numberWithoutLastDigit = HelperManager().removeLastDigit(from: amountOfStart)
                                            self.amountOfStart = numberWithoutLastDigit
                                        }
                                    }
                            }
                            
                            VStack(alignment: .center, spacing: 2) {
                                Text(NSLocalizedString("savingsplan_end", comment: ""))
                                    .font(Font.mediumText16())
                                TextField(NSLocalizedString("savingsplan_placeholder_amount", comment: ""), value: $amountOfEnd.animation(), formatter: numberFormatter)
                                    .focused($focusedField, equals: .amountOfEnd)
                                    .font(.semiBoldCustom(size: 30))
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.decimalPad)
                                    .onReceive(Just(amountOfEnd)) { newValue in
                                        if amountOfEnd > 1_000_000_000 {
                                            let numberWithoutLastDigit = HelperManager().removeLastDigit(from: amountOfEnd)
                                            self.amountOfEnd = numberWithoutLastDigit
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
                                    Toggle(NSLocalizedString("savingsplan_end_date", comment: ""), isOn: $isEndDate.animation())
                                        .font(Font.mediumText16())
                                        .padding(.horizontal)
                                }
                            }
                            .padding()
                            
                            if isEndDate {
                                ZStack {
                                    Capsule()
                                        .frame(height: 50)
                                        .foregroundColor(Color.color3Apple)
                                    
                                    HStack {
                                        Spacer()
                                        DatePicker(NSLocalizedString("savingsplan_end_date_picker", comment: ""), selection: $dateOfEnd, in: Date()..., displayedComponents: [.date])
                                            .font(Font.mediumText16())
                                            .padding(.horizontal)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        cellForAlerts()
                        
                        Spacer()
                        
                        CreateButton(action: {
                            createSavingPlan()
                            if userDefaultsManager.hapticFeedback { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                        }, validate: validateSavingPlan())
                            .padding(.horizontal, 8)
                            .padding(.bottom)
                    }
                } else {
                    VStack { // Successful Saving Plan
                        CircleWithCheckmark()
                            .padding(.vertical, 50)
                            .confettiCannon(counter: $confettiCounter, num: 50, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
                        
                        VStack(spacing: 20) {
                            Text(NSLocalizedString("savingsplan_successful", comment: ""))
                                .font(.semiBoldCustom(size: 28))
                                .foregroundColor(colorScheme == .light ? .secondary500 : .primary0)
                            
                            Text(NSLocalizedString("savingsplan_successful_desc", comment: ""))
                                .font(Font.mediumSmall())
                                .foregroundColor(.secondary400)
                        }
                        .padding(.bottom, 30)
                        
                        if let theNewSavingPlan {
                            VStack {
                                CellSavingPlanView(savingPlan: theNewSavingPlan, update: $update)
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                        
                        if let account, numberOfAlertsForSuccessful != 0 {
                            NavigationLink(destination: {
                                AlertViewForSuccessful(account: account, isCardLimitSoonExceed: isCardLimitSoonToBeExceeded, isCardLimitExceeded: isCardLimitExceeded)
                            }, label: { LabelForCellAlerts(numberOfAlert: numberOfAlertsForSuccessful, colorCell: true) })
                        }
                        
                        ValidateButton(action: { dismiss() }, validate: true)
                            .padding(.horizontal, 8)
                            .padding(.bottom)
                    }
                    .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { confettiCounter += 1 } }
                }
            }
            .ignoresSafeArea(.keyboard)
            .onChange(of: focusedField, perform: { newValue in
                if newValue != .emoji { withAnimation { isEmoji = false } }
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
            .sheet(isPresented: $showSettings, content: {
                SettingsHomeView(account: account, update: $update)
            })
            
        } // End NavigationStack
    }//END body
    
    //MARK: Fonctions
    
    func validateSavingPlan() -> Bool {
        if isAccountWillBeNegative { return false }
        if userDefaultsManager.blockExpensesIfCardLimitExceeds {
            if !title.isEmptyWithoutSpace() && !emoji.isEmptyWithoutSpace() && amountOfStart >= 0 && amountOfStart < amountOfEnd && amountOfEnd != 0 && !isCardLimitExceeds {
                return true
            }
        } else if !title.isEmptyWithoutSpace() && !emoji.isEmptyWithoutSpace() && amountOfStart >= 0 && amountOfStart < amountOfEnd && amountOfEnd != 0 {
            return true
        }
        return false
    }
    
    func createSavingPlan() {
        if let account {
            let newSavingPlan = SavingPlan(context: viewContext)
            newSavingPlan.id = UUID()
            newSavingPlan.title = title
            newSavingPlan.icon = emoji
            newSavingPlan.amountOfStart = amountOfStart
            newSavingPlan.actualAmount = amountOfStart
            newSavingPlan.amountOfEnd = amountOfEnd
            newSavingPlan.isEndDate = isEndDate
            newSavingPlan.dateOfStart = .now
            newSavingPlan.savingPlansToAccount = account
            
            if isEndDate { newSavingPlan.dateOfEnd = dateOfEnd } else { newSavingPlan.dateOfEnd = nil }
            
            if amountOfStart > 0 {
                let firstContribution = Contribution(context: viewContext)
                firstContribution.id = UUID()
                firstContribution.amount = amountOfStart
                firstContribution.date = .now
                firstContribution.contributionToSavingPlan = newSavingPlan
                
                account.balance -= amountOfStart
            }
            
            if account.cardLimit != 0 {
                let percentage = account.amountOfExpensesInActualMonth() / account.cardLimit
                if percentage >= userDefaultsManager.cardLimitPercentage / 100 && percentage <= 1 {
                    isCardLimitSoonToBeExceeded = true
                } else if percentage > 1 { isCardLimitExceeded = true }
            }
            
            do {
                try viewContext.save()
                print("🔥 Saving plans created with success")
                theNewSavingPlan = newSavingPlan
                withAnimation { showSuccessfulSavingPlan.toggle() }
            } catch {
                print("⚠️ Error for : \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - ViewBuilder
    @ViewBuilder
    func cellForAlerts() -> some View {
        if numberOfAlerts != 0 {
            NavigationLink(destination: {
                AlertsView(
                    isAccountWillBeNegative: isAccountWillBeNegative,
                    isCardLimitExceeds: isCardLimitExceeds,
                    isStartTallerThanEnd: isStartTallerThanEnd
                )
            }, label: { LabelForCellAlerts(numberOfAlert: numberOfAlerts) })
        }
    }
}//END struct

//MARK: - Preview
struct AddSavingPlanView_Previews: PreviewProvider {
    
    @State static var previewAccount: Account? = previewAccount1()
    
    static var previews: some View {
        AddSavingPlanView(account: $previewAccount)
    }
}
