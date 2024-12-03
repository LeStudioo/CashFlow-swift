//
//  SavingPlanRepositoryOld.swift
//  CashFlow
//
//  Created by Theo Sementa on 13/08/2024.
//

import Foundation

final class SavingPlanRepositoryOld: ObservableObject {
    static let shared = SavingPlanRepositoryOld()
    
    @Published var savingPlans: [SavingPlan] = []
}

extension SavingPlanRepositoryOld {
    
    func fetchSavingsPlans() {
        let request = SavingPlan.fetchRequest()
        do {
            let results = try viewContext.fetch(request)
            self.savingPlans = results
            
            let savingsPlanData = try JSONEncoder().encode(savingPlans.filter { $0.dateOfStart != nil })
            let json = "\"savingsplan\":" + (String(data: savingsPlanData, encoding: .utf8) ?? "")
            DataForServer.shared.savingsPlanJSON = json
            print(json)
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
    
}

extension SavingPlanRepositoryOld {
    
    func deleteSavingsPlans() {
        for savingPlan in self.savingPlans {
            viewContext.delete(savingPlan)
        }
        self.savingPlans = []
    }
    
}
