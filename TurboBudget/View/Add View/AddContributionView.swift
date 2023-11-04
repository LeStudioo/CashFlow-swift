//
//  AddContributionView.swift
//  CashFlow
//
//  Created by Théo Sementa on 09/07/2023.
//
// Localizations 30/09/2023

import SwiftUI
import Combine

struct AddContributionView: View {

    //Custom type
    var savingPlan: SavingPlan
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared

    //Environnements
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    //State or Binding String

    //State or Binding Int, Float and Double
    @State private var amountContribution: Double = 0.0

    //State or Binding Bool
    @State private var update: Bool = false
    
    //State or Binding Date
    @State private var dateContribution: Date = .now

	//Enum
    enum Field: CaseIterable {
        case amount
    }
    @FocusState var focusedField: Field?
    @State private var typeContribution: ExpenseOrIncome = .expense // expense = Add / income = withdrawal

	//Computed var
    var moneyForFinish: Double {
        return savingPlan.amountOfEnd - savingPlan.actualAmount
    }
    
    var isAccountWillBeNegative: Bool {
        if let account = savingPlan.savingPlansToAccount {
            if !userDefaultsManager.accountCanBeNegative && account.balance - amountContribution < 0 && typeContribution == .expense { return true } else { return false }
        } else { return false }
    }
    
    var isCardLimitExceeds: Bool {
        if let account = savingPlan.savingPlansToAccount {
            if account.cardLimit != 0 {
                let cardLimitAfterTransaction = account.amountOfExpensesInActualMonth() + amountContribution
                if cardLimitAfterTransaction <= account.cardLimit { return false } else { return true }
            } else { return false }
        } else { return false }
    }
    
    var numberOfAlerts: Int {
        var num: Int = 0
        if isCardLimitExceeds { num += 1 }
        if isAccountWillBeNegative { num += 1 }
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
                DismissButtonInSheet()
                
                Text(NSLocalizedString("contribution_new", comment: ""))
                    .titleAdjustSize()
                
                TextField(NSLocalizedString("contribution_placeholder_amount", comment: ""), value: $amountContribution.animation(), formatter: numberFormatter)
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
                    .onReceive(Just(amountContribution)) { newValue in
                        if amountContribution > 1_000_000_000 {
                            let numberWithoutLastDigit = HelperManager().removeLastDigit(from: amountContribution)
                            self.amountContribution = numberWithoutLastDigit
                        }
                    }
                
                CustomSegmentedControl(selection: $typeContribution,
                                       textLeft: NSLocalizedString("contribution_add", comment: ""),
                                       textRight: NSLocalizedString("contribution_withdraw", comment: ""),
                                       height: isLittleIphone ? 40 : 50)
                .padding(.horizontal)

                
                ZStack {
                    Capsule()
                        .frame(height: isLittleIphone ? 40 : 50)
                        .foregroundColor(Color.color3Apple)
                    
                    HStack {
                        Spacer()
                        DatePicker("\(dateContribution.formatted())", selection: $dateContribution, in: savingPlan.dateOfStart..., displayedComponents: [.date])
                            .labelsHidden()
                            .clipped()
                            .padding(.horizontal)
                    }
                }
                .padding()
                
                cellForAlerts()
                
                VStack {
                    if (amountContribution > moneyForFinish || moneyForFinish == 0) && typeContribution == .expense {
                        Text(NSLocalizedString("contribution_alert_more_final_amount", comment: ""))
                    } else if (amountContribution < moneyForFinish || moneyForFinish != 0) && typeContribution == .expense {
                        Text("💰" + moneyForFinish.currency + " " + NSLocalizedString("contribution_alert_for_finish", comment: ""))
                    }
                    if (savingPlan.actualAmount - amountContribution < 0) && typeContribution == .income {
                        Text(NSLocalizedString("contribution_alert_take_more_amount", comment: ""))
                    }
                }
                .font(Font.mediumText16())
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                
                Spacer()
                
                CreateButton(action: {
                    createContribution()
                    if userDefaultsManager.hapticFeedback { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                }, validate: validateContribution())
                    .padding(.horizontal, 8)
                    .padding(.bottom)
            }
            .ignoresSafeArea(.keyboard)
            .background(Color.color2Apple.edgesIgnoringSafeArea(.all).onTapGesture { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) } )
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        EmptyView()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Button(action: { focusedField = nil }, label: { Image(systemName: "keyboard.chevron.compact.down.fill").foregroundColor(HelperManager().getAppTheme().color) })
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        } //End Navigation Stack
    }//END body

    //MARK: Fonctions
    func validateContribution() -> Bool {
        if userDefaultsManager.blockExpensesIfCardLimitExceeds && typeContribution == .expense {
            if amountContribution != 0 && savingPlan.actualAmount < savingPlan.amountOfEnd && !isCardLimitExceeds {
                return true
            }
        } else if typeContribution == .income {
            if amountContribution != 0 && (savingPlan.actualAmount - amountContribution >= 0) {
                return true
            }
        } else if typeContribution == .expense {
            if amountContribution != 0 && savingPlan.actualAmount < savingPlan.amountOfEnd {
                return true
            }
        }
        return false
    }
    
    func createContribution() {
        let newContribution = Contribution(context: viewContext)
        newContribution.id = UUID()
        newContribution.amount = typeContribution == .expense ? amountContribution : -amountContribution
        newContribution.date = dateContribution
        newContribution.contributionToSavingPlan = savingPlan
        
        if typeContribution == .income {
            savingPlan.actualAmount -= amountContribution
        } else {
            savingPlan.actualAmount += amountContribution
        }
        
        if let account = savingPlan.savingPlansToAccount {
            if typeContribution == .expense {
                account.balance -= amountContribution
            } else {
                account.balance += amountContribution
            }
        }
        
        persistenceController.saveContext()
        
        dismiss()
    }
    
    //MARK: - ViewBuilder
    @ViewBuilder
    func cellForAlerts() -> some View {
        if numberOfAlerts != 0 {
            NavigationLink(destination: {
                AlertsView(
                    isAccountWillBeNegative: isAccountWillBeNegative,
                    isCardLimitExceeds: isCardLimitExceeds
                )
            }, label: { LabelForCellAlerts(numberOfAlert: numberOfAlerts) })
        }
    }

}//END struct

//MARK: - Preview
struct AddContributionView_Previews: PreviewProvider {
    static var previews: some View {
        AddContributionView(savingPlan: previewSavingPlan1())
    }
}
