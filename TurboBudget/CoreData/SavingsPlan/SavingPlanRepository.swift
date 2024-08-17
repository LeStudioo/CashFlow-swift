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
    
    func deleteSavingsPlan(savingsPlan: SavingPlan) {
        self.savingPlans.removeAll(where: { $0.id == savingsPlan.id })
        viewContext.delete(savingsPlan)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            persistenceController.saveContext()
        }
    }
    
    func deleteSavingsPlans() {
        for savingPlan in self.savingPlans {
            viewContext.delete(savingPlan)
        }
        self.savingPlans = []
    }
    
}
