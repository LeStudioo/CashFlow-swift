//
//  AddSavingPlanViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 05/11/2023.
//

import Foundation
import CoreData
import SwiftUI

class AddSavingPlanViewModel: ObservableObject {
    static let shared = AddSavingPlanViewModel()
    let context = persistenceController.container.viewContext
    @Published var mainAccount: Account? = nil
    
    @Published var theNewSavingPlan: SavingPlan? = nil
    
    @Published var savingPlanTitle: String = ""
    @Published var savingPlanEmoji: String = ""
    @Published var savingPlanAmountOfStart: Double = 0.0
    @Published var savingPlanAmountOfEnd: Double = 0.0
    @Published var savingPlanDateOfEnd: Date = .now
    
    @Published var showSuccessfulSavingPlan: Bool = false
    
    @Published var isCardLimitSoonToBeExceeded: Bool = false
    @Published var isCardLimitExceeded: Bool = false
    
    @Published var isEndDate: Bool = false
    @Published var isEmoji: Bool = false
    
    @Published var presentingConfirmationDialog: Bool = false
    
    // Preferences
    @Preference(\.cardLimitPercentage) private var cardLimitPercentage
    @Preference(\.blockExpensesIfCardLimitExceeds) private var blockExpensesIfCardLimitExceeds
    @Preference(\.accountCanBeNegative) private var accountCanBeNegative
    
    // init
    init() {
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        var allAccount: [Account] = []
        do {
            allAccount = try context.fetch(fetchRequest)
            if allAccount.count != 0 {
                mainAccount = allAccount[0]
            }
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
    
    func createSavingPlan() {
        if let account = mainAccount {
            let newSavingPlan = SavingPlan(context: context)
            newSavingPlan.id = UUID()
            newSavingPlan.title = savingPlanTitle
            newSavingPlan.icon = savingPlanEmoji
            newSavingPlan.amountOfStart = savingPlanAmountOfStart
            newSavingPlan.actualAmount = savingPlanAmountOfStart
            newSavingPlan.amountOfEnd = savingPlanAmountOfEnd
            newSavingPlan.isEndDate = isEndDate
            newSavingPlan.dateOfStart = .now
            newSavingPlan.savingPlansToAccount = account
            
            if isEndDate { newSavingPlan.dateOfEnd = savingPlanDateOfEnd } else { newSavingPlan.dateOfEnd = nil }
            
            if savingPlanAmountOfStart > 0 {
                let firstContribution = Contribution(context: context)
                firstContribution.id = UUID()
                firstContribution.amount = savingPlanAmountOfStart
                firstContribution.date = .now
                firstContribution.contributionToSavingPlan = newSavingPlan
                
                account.balance -= savingPlanAmountOfStart
            }
            
            if account.cardLimit != 0 {
                let percentage = account.amountOfExpensesInActualMonth() / account.cardLimit
                if percentage >= cardLimitPercentage / 100 && percentage <= 1 {
                    isCardLimitSoonToBeExceeded = true
                } else if percentage > 1 { isCardLimitExceeded = true }
            }
            
            do {
                try context.save()
                print("🔥 Saving plans created with success")
                theNewSavingPlan = newSavingPlan
                withAnimation { showSuccessfulSavingPlan.toggle() }
            } catch {
                print("⚠️ Error for : \(error.localizedDescription)")
            }
        }
    }

}

//MARK: Verification
extension AddSavingPlanViewModel {
    
    func isSavingPlansInCreation() -> Bool {
        if !savingPlanEmoji.isEmpty || !savingPlanTitle.isEmpty || savingPlanAmountOfStart != 0 || savingPlanAmountOfEnd != 0 || isEndDate {
            return true
        }
        return false
    }
    
    func validateSavingPlan() -> Bool {
        if isAccountWillBeNegative { return false }
        if blockExpensesIfCardLimitExceeds {
            if !savingPlanTitle.isEmptyWithoutSpace() && !savingPlanEmoji.isEmptyWithoutSpace() && savingPlanAmountOfStart >= 0 && savingPlanAmountOfStart < savingPlanAmountOfEnd && savingPlanAmountOfEnd != 0 && !isCardLimitExceeds {
                return true
            }
        } else if !savingPlanTitle.isEmptyWithoutSpace() && !savingPlanEmoji.isEmptyWithoutSpace() && savingPlanAmountOfStart >= 0 && savingPlanAmountOfStart < savingPlanAmountOfEnd && savingPlanAmountOfEnd != 0 {
            return true
        }
        return false
    }
    
    var isCardLimitExceeds: Bool {
        if let mainAccount, mainAccount.cardLimit != 0, blockExpensesIfCardLimitExceeds {
            let cardLimitAfterTransaction = mainAccount.amountOfExpensesInActualMonth() + savingPlanAmountOfStart
            if cardLimitAfterTransaction <= mainAccount.cardLimit { return false } else { return true }
        } else { return false }
    }
    
    var isAccountWillBeNegative: Bool {
        if let mainAccount, !accountCanBeNegative {
            if mainAccount.balance - savingPlanAmountOfStart < 0 { return true }
        }
        return false
    }
    
    var isStartTallerThanEnd: Bool {
        if savingPlanAmountOfStart > savingPlanAmountOfEnd { return true } else { return false }
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
        return num
    }
}
