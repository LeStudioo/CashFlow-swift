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
    
    func fetchSavingPlans() {
        let request = SavingPlan.fetchRequest()
        do {
            let results = try viewContext.fetch(request)
            self.savingPlans = results
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
    
    func deleteSavingPlans() {
        for savingPlan in self.savingPlans {
            viewContext.delete(savingPlan)
        }
        self.savingPlans = []
    }
    
}
