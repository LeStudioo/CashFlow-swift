//
//  CreateContributionViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/11/2024.
//

import Foundation
import SwiftUI

extension CreateContributionScreen {
    
    final class ViewModel: ObservableObject {
        
        // MARK: Dependencies
        var savingsPlan: SavingsPlanModel
        
        @Published var name: String = ""
        @Published var amount: String = ""
        @Published var type: ContributionType = .addition
        @Published var date: Date = Date()
        
        @Published var presentingConfirmationDialog: Bool = false
        
        init(savingsPlan: SavingsPlanModel) {
            self.savingsPlan = savingsPlan
        }
    }
    
}

extension CreateContributionScreen.ViewModel {
    
    func isContributionValid() -> Bool {
        guard amount.toDouble() != 0 else { return false }
        if type == .withdrawal && ((savingsPlan.currentAmount ?? 0) - amount.toDouble() < 0) {
            return false
        }
        return true
    }
    
    func createContribution(dismiss: DismissAction) async {
        guard let savingsPlanID = savingsPlan.id else { return }
        let contributionStore: ContributionStore = .shared
        let successfullModalManager: SuccessfullModalManager = .shared
        
        if let contribution = await contributionStore.createContribution(
            savingsplanID: savingsPlanID,
            body: .init(
                name: name.isEmpty ? nil : name,
                amount: amount.toDouble(),
                typeNum: type.rawValue,
                dateString: date.toISO()
            )
        ) {
            await dismiss()
            await successfullModalManager.showSuccessfulContribution(
                type: .new,
                savingsPlan: savingsPlan,
                contribution: contribution
            )
        }
    }
    
    func isContributionInCreation() -> Bool {
        if amount.toDouble() != 0 {
            return true
        }
        return false
    }
    
}
