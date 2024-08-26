//
//  SavingPlanRepository.swift
//  CashFlow
//
//  Created by Theo Sementa on 13/08/2024.
//

import Foundation

final class SavingPlanRepository: ObservableObject {
    static let shared = SavingPlanRepository()
    
    @Published var savingPlans: [SavingPlan] = []
}

extension SavingPlanRepository {
    
    func fetchSavingsPlans() {
        let request = SavingPlan.fetchRequest()
        do {
            let results = try viewContext.fetch(request)
            self.savingPlans = results
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
    
    /// Create a new Savings Plan
    func createSavingsPlan(model: SavingsPlanModel, withSave: Bool = true) throws -> SavingPlan {
        guard let account = AccountRepository.shared.mainAccount else { throw CustomError.noAccount }
        
        let newSavingPlan = SavingPlan(context: viewContext)
        newSavingPlan.id = UUID()
        newSavingPlan.title = model.title
        newSavingPlan.icon = model.icon
        newSavingPlan.amountOfStart = model.amountOfStart
        newSavingPlan.actualAmount = model.actualAmount
        newSavingPlan.amountOfEnd = model.amountOfEnd
        newSavingPlan.dateOfEnd = model.dateOfEnd
        newSavingPlan.dateOfStart = model.dateOfStart
        newSavingPlan.savingPlansToAccount = account
        
        if model.amountOfStart > 0 {
            let contributionModel = ContributionModel(
                amount: model.amountOfStart,
                date: .now,
                savingsPlan: newSavingPlan
            )
            
            let newContribution = try ContributionRepository.shared.createNewContribution(model: contributionModel)
        }
        
        if withSave {
            self.savingPlans.append(newSavingPlan)
            try persistenceController.saveContextWithThrow()
        }
        
        return newSavingPlan
    }
    
    func deleteSavingsPlan(savingsPlan: SavingPlan) {
        self.savingPlans.removeAll(where: { $0.id == savingsPlan.id })
        viewContext.delete(savingsPlan)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            persistenceController.saveContext()
        }
    }
    
}

extension SavingPlanRepository {
    
    func deleteSavingsPlans() {
        for savingPlan in self.savingPlans {
            viewContext.delete(savingPlan)
        }
        self.savingPlans = []
    }
    
}
