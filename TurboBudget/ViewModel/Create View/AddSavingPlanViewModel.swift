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
    let successfullModalManager: SuccessfullModalManager = .shared
        
    @Published var savingPlanTitle: String = ""
    @Published var savingPlanEmoji: String = "💻"
    @Published var savingPlanAmountOfStart: String = ""
    @Published var savingPlanAmountOfEnd: String = ""
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
    
    func createSavingsPlan(withError: @escaping (_ withError: CustomError?) -> Void) {
        guard let account = AccountRepository.shared.mainAccount else { return }
        
        let savingsPlanModel = SavingsPlanModel(
            title: savingPlanTitle,
            icon: savingPlanEmoji,
            dateOfEnd: isEndDate ? savingPlanDateOfEnd : nil,
            dateOfStart: .now,
            amountOfStart: savingPlanAmountOfStart.convertToDouble(),
            actualAmount: savingPlanAmountOfStart.convertToDouble(),
            amountOfEnd: savingPlanAmountOfEnd.convertToDouble()
        )
        
        do {
            let newSavingsPlan = try SavingPlanRepository.shared.createSavingsPlan(model: savingsPlanModel)
            account.balance -= savingsPlanModel.amountOfStart
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.successfullModalManager.isPresenting = true
            }
            successfullModalManager.title = "savingsplan_successful".localized
            successfullModalManager.subtitle = "savingsplan_successful_desc".localized
            successfullModalManager.content = AnyView(SavingsPlanRow(savingPlan: newSavingsPlan))
            
            withError(nil)
        } catch {
            if let error = error as? CustomError {
                withError(error)
            }
        }
    }
        
}

//MARK: Verification
extension AddSavingPlanViewModel {
    
    func isSavingPlansInCreation() -> Bool {
        if !savingPlanEmoji.isEmpty || !savingPlanTitle.isEmpty || savingPlanAmountOfStart.convertToDouble() != 0 || savingPlanAmountOfEnd.convertToDouble() != 0 || isEndDate {
            return true
        }
        return false
    }
    
    func validateSavingPlan() -> Bool {
        if isAccountWillBeNegative { return false }
        if blockExpensesIfCardLimitExceeds {
            if !savingPlanTitle.isEmptyWithoutSpace() && !savingPlanEmoji.isEmptyWithoutSpace() && savingPlanAmountOfStart.convertToDouble() >= 0 && savingPlanAmountOfStart < savingPlanAmountOfEnd && savingPlanAmountOfEnd.convertToDouble() != 0 && !isCardLimitExceeds {
                return true
            }
        } else if !savingPlanTitle.isEmptyWithoutSpace() && !savingPlanEmoji.isEmptyWithoutSpace() && savingPlanAmountOfStart.convertToDouble() >= 0 && savingPlanAmountOfStart < savingPlanAmountOfEnd && savingPlanAmountOfEnd.convertToDouble() != 0 {
            return true
        }
        return false
    }
    
    var isCardLimitExceeds: Bool {
        if let mainAccount = AccountRepository.shared.mainAccount, mainAccount.cardLimit != 0, blockExpensesIfCardLimitExceeds {
            let cardLimitAfterTransaction = mainAccount.amountOfExpensesInActualMonth() + savingPlanAmountOfStart.convertToDouble()
            if cardLimitAfterTransaction <= mainAccount.cardLimit { return false } else { return true }
        } else { return false }
    }
    
    var isAccountWillBeNegative: Bool {
        if let mainAccount = AccountRepository.shared.mainAccount, !accountCanBeNegative {
            if mainAccount.balance - savingPlanAmountOfStart.convertToDouble() < 0 { return true }
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
