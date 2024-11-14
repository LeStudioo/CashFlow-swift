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
    
    /// Fetch all automations
    func fetchAutomations() {
        let request = Automation.fetchRequest()
        do {
            let automations = try viewContext.fetch(request)
            self.automations = automations
            
            let automationsData = try JSONEncoder().encode(automations.filter { $0.category != nil })
            let json = "\"subscriptions\":" + (String(data: automationsData, encoding: .utf8) ?? "")
            DataForServer.shared.automationJSON = json
            print(json)
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
    
    /// Create a new automation
    func createAutomation(model: AutomationModel, withSave: Bool = true) throws -> Automation {
        guard let account = AccountRepositoryOld.shared.mainAccount else { throw CustomError.noAccount }
        
        let newAutomation = Automation(context: viewContext)
        newAutomation.id = UUID()
        newAutomation.title = model.title
        newAutomation.date = model.date
        newAutomation.frenquently = Int16(model.frenquently)
        newAutomation.automationToTransaction = model.transaction
        newAutomation.automationToAccount = account
        
        if withSave {
            self.automations.append(newAutomation)
            try persistenceController.saveContextWithThrow()
        }
        
        return newAutomation
    }
    
    /// Delete automation
    func deleteAutomation(_ automation: Automation) {
        self.automations.removeAll(where: { $0.id == automation.id })
        
        viewContext.delete(automation)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            persistenceController.saveContext()
        }
    }
    
}
