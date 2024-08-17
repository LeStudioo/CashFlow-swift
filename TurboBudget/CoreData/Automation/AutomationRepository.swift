//
//  AutomationRepository.swift
//  CashFlow
//
//  Created by Theo Sementa on 13/08/2024.
//

import Foundation

final class AutomationRepository: ObservableObject {
    static let shared = AutomationRepository()
    
    @Published var automations: [Automation] = []
}

// MARK: - C.R.U.D
extension AutomationRepository {
    
    func fetchAutomations() {
        let request = Automation.fetchRequest()
        do {
            let automations = try viewContext.fetch(request)
            self.automations = automations
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
    
    func deleteAutomation(_ automation: Automation) {
        self.automations.removeAll(where: { $0.id == automation.id })
        
        viewContext.delete(automation)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            persistenceController.saveContext()
        }
    }
    
}
