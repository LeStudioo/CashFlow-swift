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
    let userDefaultsManager = UserDefaultsManager.shared
    @Published var mainAccount: Account? = nil
    @Published var savingPlan: SavingPlan? = nil
    
    @Published var amountContribution: Double = 0.0
    @Published var dateContribution: Date = .now
    @Published var typeContribution: ExpenseOrIncome = .expense // expense = Add / income = withdrawal
    
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
        newContribution.amount = typeContribution == .expense ? amountContribution : -amountContribution
        newContribution.date = dateContribution
        newContribution.contributionToSavingPlan = savingPlan
        
        if let savingPlan {
            if typeContribution == .income {
                savingPlan.actualAmount -= amountContribution
            } else {
                savingPlan.actualAmount += amountContribution
            }
        }
        
        if let account = mainAccount {
            if typeContribution == .expense {
                account.balance -= amountContribution
            } else {
                account.balance += amountContribution
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
    
    func validateContribution() -> Bool {
        if let savingPlan, userDefaultsManager.blockExpensesIfCardLimitExceeds && typeContribution == .expense {
            if amountContribution != 0 && savingPlan.actualAmount < savingPlan.amountOfEnd && !isCardLimitExceeds {
                return true
            }
        } else if let savingPlan, typeContribution == .income {
            if amountContribution != 0 && (savingPlan.actualAmount - amountContribution >= 0) {
                return true
            }
        } else if let savingPlan, typeContribution == .expense {
            if amountContribution != 0 && savingPlan.actualAmount < savingPlan.amountOfEnd {
                return true
            }
        }
        return false
    }
}

//MARK: - Verification
extension AddContributionViewModel {
    var isAccountWillBeNegative: Bool {
        if let account = mainAccount {
            if !userDefaultsManager.accountCanBeNegative && account.balance - amountContribution < 0 && typeContribution == .expense { return true } else { return false }
        } else { return false }
    }
    
    var isCardLimitExceeds: Bool {
        if let account = mainAccount {
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
}
