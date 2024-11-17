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
            self.startDate = savingsPlan.startDate?.toDate() ?? .now
            self.endDate = savingsPlan.endDate?.toDate() ?? .now
            self.isEndDate = savingsPlan.endDate != nil
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
            startDate: startDate.toISO(),
            endDate: isEndDate ? endDate.toISO() : nil,
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
                            date: startDate.toISO())
                    )
                }
                
                await dismiss()
                
                await successfullModalManager.showSuccessfullSavingsPlan(savingsPlan: savingsPlan)
            }
        }
    }
    
    func updateSavingsPlan(dismiss: DismissAction) {
        let accountRepository: AccountRepository = .shared
        let savingsPlanRepository: SavingsPlanRepository = .shared
        
        Task {
            guard let account = accountRepository.selectedAccount else { return }
            guard let accountID = account.id else { return }
            
            if let savingsPlan = savingsPlan, let savingsPlanID = savingsPlan.id {
                await savingsPlanRepository.updateSavingsPlan(
                    savingsPlanID: savingsPlanID,
                    body: bodyForCreation()
                )
                
                await dismiss()
            }
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
