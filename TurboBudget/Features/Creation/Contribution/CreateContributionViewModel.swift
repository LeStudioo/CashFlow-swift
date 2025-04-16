//
//  CreateContributionViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/11/2024.
//

import Foundation
import SwiftUI

final class CreateContributionViewModel: ObservableObject {
    
    // builder
    var savingsPlan: SavingsPlanModel
    
    @Published var amount: String = ""
    @Published var type: ContributionType = .addition
    @Published var date: Date = Date()
    
    @Published var presentingConfirmationDialog: Bool = false
    
    init(savingsPlan: SavingsPlanModel) {
        self.savingsPlan = savingsPlan
    }
}

extension CreateContributionViewModel {
    
    func isContributionValid() -> Bool {
        guard amount.toDouble() != 0 else { return false }
        if type == .withdrawal && ((savingsPlan.currentAmount ?? 0) - amount.toDouble() < 0) {
            return false
        }
        return true
    }
    
    func createContribution(dismiss: DismissAction) {
        guard let savingsPlanID = savingsPlan.id else { return }
        let contributionStore: ContributionStore = .shared
        let successfullModalManager: SuccessfullModalManager = .shared
        
        Task {
            if let contribution = await contributionStore.createContribution(
                savingsplanID: savingsPlanID,
                body: .init(
                    amount: amount.toDouble(),
                    typeNum: type.rawValue,
                    dateString: date.toISO())
            ) {
                await dismiss()
                
                await successfullModalManager.showSuccessfulContribution(
                    type: .new,
                    savingsPlan: savingsPlan,
                    contribution: contribution
                )
            }
        }
    }
    
    func isContributionInCreation() -> Bool {
        if amount.toDouble() != 0 {
            return true
        }
        return false
    }
    
}
