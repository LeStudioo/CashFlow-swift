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
   
        
    @Published var savingPlanTitle: String = ""
    @Published var savingPlanEmoji: String = "💻"
    @Published var savingPlanAmountOfStart: String = ""
    @Published var savingPlanAmountOfEnd: String = ""
    @Published var savingPlanStartDate: Date = .now
    @Published var savingPlanDateOfEnd: Date = .now
    @Published var textFieldHeight: CGFloat = 0
        
    @Published var isCardLimitSoonToBeExceeded: Bool = false
    @Published var isCardLimitExceeded: Bool = false
    
    @Published var isEndDate: Bool = false
    @Published var isEmoji: Bool = false
    @Published var showEmojiPicker: Bool = false
    
    @Published var presentingConfirmationDialog: Bool = false
    
    // Preferences
    @Preference(\.cardLimitPercentage) private var cardLimitPercentage
    @Preference(\.blockExpensesIfCardLimitExceeds) private var blockExpensesIfCardLimitExceeds
    @Preference(\.accountCanBeNegative) private var accountCanBeNegative

}

extension AddSavingPlanViewModel {
    
    func bodyForCreation() -> SavingsPlanModel {
        return SavingsPlanModel(
            name: savingPlanTitle,
            emoji: savingPlanEmoji,
            startDate: savingPlanStartDate.toISO(),
            endDate: isEndDate ? savingPlanDateOfEnd.toISO() : nil,
            currentAmount: savingPlanAmountOfStart.toDouble(),
            goalAmount: savingPlanAmountOfEnd.toDouble()
        )
    }
    
    func createSavingsPlan(dismiss: DismissAction) {
        let accountRepository: AccountRepository = .shared
        let savingsPlanRepository: SavingsPlanRepository = .shared
        let contributionRepository: ContributionRepository = .shared
        let successfullModalManager: SuccessfullModalManager = .shared
        
        Task {
            guard let account = accountRepository.selectedAccount else { return }
            guard let accountID = account.id else { return }
            
            if let savingsPlan = await savingsPlanRepository.createSavingsPlan(accountID: accountID, body: bodyForCreation()) {
                if let savingsPlanID = savingsPlan.id {
                    if savingPlanAmountOfStart.toDouble() != 0 {
                        await contributionRepository.createContribution(
                            savingsplanID: savingsPlanID,
                            body: .init(
                                amount: savingPlanAmountOfStart.toDouble(),
                                date: savingPlanStartDate.toISO())
                        )
                    }
                }
                
                dismiss()
                
                successfullModalManager.title = "savingsplan_successful".localized
                successfullModalManager.subtitle = "savingsplan_successful_desc".localized
                successfullModalManager.content = AnyView(SavingsPlanRow(savingsPlan: savingsPlan))
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    successfullModalManager.isPresenting = true
                }
            }
        }
    }
    
//    func createSavingsPlan(withError: @escaping (_ withError: CustomError?) -> Void) {
//        guard let account = AccountRepositoryOld.shared.mainAccount else { return }
//        
//        let savingsPlanModel = SavingsPlanModelOld(
//            title: savingPlanTitle,
//            icon: savingPlanEmoji,
//            dateOfEnd: isEndDate ? savingPlanDateOfEnd : nil,
//            dateOfStart: .now,
//            amountOfStart: savingPlanAmountOfStart.toDouble(),
//            actualAmount: savingPlanAmountOfStart.toDouble(),
//            amountOfEnd: savingPlanAmountOfEnd.toDouble()
//        )
//        
//        do {
//            let newSavingsPlan = try SavingPlanRepositoryOld.shared.createSavingsPlan(model: savingsPlanModel)
//            account.balance -= savingsPlanModel.amountOfStart
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.successfullModalManager.isPresenting = true
//            }
//            successfullModalManager.title = "savingsplan_successful".localized
//            successfullModalManager.subtitle = "savingsplan_successful_desc".localized
//            successfullModalManager.content = AnyView(SavingsPlanRow(savingsPlan: newSavingsPlan))
//            
//            withError(nil)
//        } catch {
//            if let error = error as? CustomError {
//                withError(error)
//            }
//        }
//    }
        
}

//MARK: Verification
extension AddSavingPlanViewModel {
    
    func isSavingPlansInCreation() -> Bool {
        if !savingPlanTitle.isEmpty || savingPlanAmountOfStart.toDouble() != 0 || savingPlanAmountOfEnd.toDouble() != 0 || isEndDate {
            return true
        }
        return false
    }
    
    func validateSavingPlan() -> Bool {
        if !savingPlanAmountOfEnd.isEmpty && !savingPlanTitle.isBlank && !savingPlanEmoji.isBlank {
            return true
        }
//        if isAccountWillBeNegative { return false }
//        if blockExpensesIfCardLimitExceeds {
//            if !savingPlanTitle.isBlank && !savingPlanEmoji.isBlank && savingPlanAmountOfStart.toDouble() >= 0 && savingPlanAmountOfStart < savingPlanAmountOfEnd && savingPlanAmountOfEnd.toDouble() != 0 && !isCardLimitExceeds {
//                return true
//            }
//        } else if !savingPlanTitle.isBlank && !savingPlanEmoji.isBlank && savingPlanAmountOfStart.toDouble() >= 0 && savingPlanAmountOfStart < savingPlanAmountOfEnd && savingPlanAmountOfEnd.toDouble() != 0 {
//            return true
//        }
        return false
    }
    
    var isCardLimitExceeds: Bool {
        if let mainAccount = AccountRepositoryOld.shared.mainAccount, mainAccount.cardLimit != 0, blockExpensesIfCardLimitExceeds {
            let cardLimitAfterTransaction = mainAccount.amountOfExpensesInActualMonth() + savingPlanAmountOfStart.toDouble()
            if cardLimitAfterTransaction <= mainAccount.cardLimit { return false } else { return true }
        } else { return false }
    }
    
    var isAccountWillBeNegative: Bool {
        if let mainAccount = AccountRepositoryOld.shared.mainAccount, !accountCanBeNegative {
            if mainAccount.balance - savingPlanAmountOfStart.toDouble() < 0 { return true }
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
