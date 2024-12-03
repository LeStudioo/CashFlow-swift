//
//  AutomationRepositoryOld.swift
//  CashFlow
//
//  Created by Theo Sementa on 13/08/2024.
//

import Foundation

final class AutomationRepositoryOld: ObservableObject {
    static let shared = AutomationRepositoryOld()
    
    @Published var automations: [Automation] = []
}

// MARK: - C.R.U.D
extension AutomationRepositoryOld {
    
    /// Fetch all automations
    func fetchAutomations() {
        let request = Automation.fetchRequest()
        do {
            let automations = try viewContext.fetch(request)
            self.automations = automations
            
            let automationsData = try JSONEncoder().encode(automations.filter { $0.automationToTransaction?.predefCategoryID != "" })
            let json = "\"subscriptions\":" + (String(data: automationsData, encoding: .utf8) ?? "")
            DataForServer.shared.automationJSON = json
            print(json)
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
    
}
