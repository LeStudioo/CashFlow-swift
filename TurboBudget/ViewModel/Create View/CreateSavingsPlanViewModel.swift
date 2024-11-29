//
//  CreateSavingsPlanViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 05/11/2023.
//

import Foundation
import CoreData
import SwiftUI

class CreateSavingsPlanViewModel: ObservableObject {
    static let shared = CreateSavingsPlanViewModel()
   
    init(savingsPlan: SavingsPlanModel? = nil) {
        if let savingsPlan {
            self.savingsPlan = savingsPlan
            self.name = savingsPlan.name ?? ""
            self.emoji = savingsPlan.emoji ?? "💻"
            self.goalAmount = savingsPlan.goalAmount?.formatted() ?? ""
            self.startDate = savingsPlan.startDate
            self.endDate = savingsPlan.endDate
            self.isEndDate = savingsPlan.endDateString != nil
        }
    }
    
    var savingsPlan: SavingsPlanModel? = nil
        
    @Published var name: String = ""
    @Published var emoji: String = "💻"
    @Published var savingPlanAmountOfStart: String = ""
    @Published var goalAmount: String = ""
    @Published var startDate: Date = .now
    @Published var endDate: Date = .now
    
    @Published var isEndDate: Bool = false
    @Published var showEmojiPicker: Bool = false
    
    @Published var presentingConfirmationDialog: Bool = false
    
}

extension CreateSavingsPlanViewModel {
    
    func bodyForCreation() -> SavingsPlanModel {
        return SavingsPlanModel(
            name: name,
            emoji: emoji,
            startDateString: startDate.toISO(),
            endDateString: isEndDate ? endDate.toISO() : nil,
            goalAmount: goalAmount.toDouble()
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
                if let savingsPlanID = savingsPlan.id, savingPlanAmountOfStart.toDouble() != 0 {
                    await contributionRepository.createContribution(
                        savingsplanID: savingsPlanID,
                        body: .init(
                            amount: savingPlanAmountOfStart.toDouble(),
                            typeNum: ContributionType.addition.rawValue,
                            dateString: startDate.toISO())
                    )
                }
                
                await dismiss()
                
                await successfullModalManager.showSuccessfulSavingsPlan(type: .new, savingsPlan: savingsPlan)
            }
        }
    }
    
    func updateSavingsPlan(dismiss: DismissAction) {
        let savingsPlanRepository: SavingsPlanRepository = .shared
        let successfullModalManager: SuccessfullModalManager = .shared
        
        Task {
            guard let savingsPlan else { return }
            guard let savingsPlanID = savingsPlan.id else { return }
            
            await savingsPlanRepository.updateSavingsPlan(
                savingsPlanID: savingsPlanID,
                body: bodyForCreation()
            )
            
            await dismiss()
            
            await successfullModalManager.showSuccessfulSavingsPlan(type: .update, savingsPlan: savingsPlan)
        }
    }
    
}

// MARK: - Verification
extension CreateSavingsPlanViewModel {
    
    func isSavingPlansInCreation() -> Bool {
        if !name.isBlank || savingPlanAmountOfStart.toDouble() != 0 || goalAmount.toDouble() != 0 || isEndDate {
            return true
        }
        return false
    }
    
    func validateSavingPlan() -> Bool {
        if !goalAmount.isEmpty && !name.isBlank && !emoji.isBlank {
            return true
        }
        return false
    }
    
}
