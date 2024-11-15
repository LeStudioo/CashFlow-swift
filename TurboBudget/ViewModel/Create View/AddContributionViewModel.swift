//
//  AddContributionViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 05/11/2023.
//

import Foundation
import CoreData

class AddContributionViewModel: ObservableObject {
    let context = persistenceController.container.viewContext
    @Published var mainAccount: Account? = nil
    @Published var savingPlan: SavingPlan? = nil
    
    @Published var amountContribution: String = ""
    @Published var dateContribution: Date = .now
    @Published var typeContribution: ExpenseOrIncome = .expense // expense = Add / income = withdrawal
    
    @Published var presentingConfirmationDialog: Bool = false
    
    // Preferences
    @Preference(\.accountCanBeNegative) private var accountCanBeNegative
    @Preference(\.blockExpensesIfCardLimitExceeds) private var blockExpensesIfCardLimitExceeds
    
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
    
    func createContribution() {
        let newContribution = Contribution(context: context)
        newContribution.id = UUID()
        newContribution.amount = typeContribution == .expense ? amountContribution.toDouble() : -amountContribution.toDouble()
        newContribution.date = dateContribution
        newContribution.contributionToSavingPlan = savingPlan
        
        if let savingPlan {
            if typeContribution == .income {
                savingPlan.actualAmount -= amountContribution.toDouble()
            } else {
                savingPlan.actualAmount += amountContribution.toDouble()
            }
        }
        
        if let account = mainAccount {
            if typeContribution == .expense {
                account.balance -= amountContribution.toDouble()
            } else {
                account.balance += amountContribution.toDouble()
            }
        }
        
        persistenceController.saveContext()
    }
}

//MARK: - Utils
extension AddContributionViewModel {
    var moneyForFinish: Double {
        if let savingPlan {
            return savingPlan.amountOfEnd - savingPlan.actualAmount
        } else { return 0 }
    }
    
    func isContributionValid() -> Bool {
        if let savingPlan, blockExpensesIfCardLimitExceeds && typeContribution == .expense {
            if amountContribution.toDouble() != 0 && savingPlan.actualAmount < savingPlan.amountOfEnd && !isCardLimitExceeds && amountContribution.toDouble() <= moneyForFinish {
                return true
            }
        } else if let savingPlan, typeContribution == .income {
            if amountContribution.toDouble() != 0 && (savingPlan.actualAmount - amountContribution.toDouble() >= 0) {
                return true
            }
        } else if let savingPlan, typeContribution == .expense {
            if amountContribution.toDouble() != 0 && savingPlan.actualAmount < savingPlan.amountOfEnd && amountContribution.toDouble() <= moneyForFinish {
                return true
            }
        }
        return false
    }
}

//MARK: - Verification
extension AddContributionViewModel {
    
    func isContributionInCreation() -> Bool {
        if amountContribution.toDouble() != 0 {
            return true
        }
        return false
    }
    
    var isAccountWillBeNegative: Bool {
        if let account = mainAccount {
            if !accountCanBeNegative && account.balance - amountContribution.toDouble() < 0 && typeContribution == .expense { return true } else { return false }
        } else { return false }
    }
    
    var isCardLimitExceeds: Bool {
        if let account = mainAccount {
            if account.cardLimit != 0 {
                let cardLimitAfterTransaction = account.amountOfExpensesInActualMonth() + amountContribution.toDouble()
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
}
