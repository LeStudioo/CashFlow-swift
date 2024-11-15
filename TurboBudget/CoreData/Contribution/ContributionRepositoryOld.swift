//
//  ContributionRepositoryOld.swift
//  CashFlow
//
//  Created by Theo Sementa on 24/08/2024.
//

import Foundation

final class ContributionRepositoryOld: ObservableObject {
    static let shared = ContributionRepositoryOld()
}

extension ContributionRepositoryOld {
    
    /// Create a new contribution
    func createNewContribution(model: ContributionModelOld, withSave: Bool = true) throws -> Contribution {
        guard let account = AccountRepositoryOld.shared.mainAccount else { throw CustomError.noAccount }
        
        let newContribution = Contribution(context: viewContext)
        newContribution.id = UUID()
        newContribution.amount = model.amount
        newContribution.date = model.date
        newContribution.contributionToSavingPlan = model.savingsPlan
        
        if withSave {
            try persistenceController.saveContextWithThrow()
        }
        
        return newContribution
    }
    
}
