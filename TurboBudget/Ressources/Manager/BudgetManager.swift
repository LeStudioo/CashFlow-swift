//
//  BudgetManager.swift
//  CashFlow
//
//  Created by KaayZenn on 08/10/2023.
//

import Foundation
import CoreData

class BudgetManager {
    
    func findBudgetForSubcategory(subcategoryUniqueID: String) -> Budget? {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        var allBudgets: [Budget] = []
        do {
            allBudgets = try context.fetch(fetchRequest)
        } catch {
            print("⚠️ Error for : \(error.localizedDescription)")
        }
        
        
        for budget in allBudgets {
            if budget.predefSubcategoryID == subcategoryUniqueID {
                return budget
            }
        }

        return nil
    }
    
}
