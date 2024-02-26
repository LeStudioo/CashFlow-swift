//
//  Budget+CoreDataProperties.swift
//  CashFlow
//
//  Created by KaayZenn on 03/08/2023.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(Budget)
public class Budget: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var amount: Double
    @NSManaged public var predefCategoryID: String
    @NSManaged public var predefSubcategoryID: String
    
//    public func actualAmountForMonth(month: Date) -> Double {
//        var amount: Double = 0.0
//        
//        let categoryOfBudget = PredefinedCategoryManager().categoryByUniqueID(idUnique: predefCategoryID)
//        
//        if let categoryOfBudget {
//            let subcategoryOfBudget = PredefinedSubcategoryManager().subcategoryByUniqueID(subcategories: categoryOfBudget.subcategories, idUnique: predefSubcategoryID)
//            
//            if let subcategoryOfBudget {
//                for transaction in subcategoryOfBudget.transactions {
//                    
//                    let categoryOfTransaction = PredefinedCategoryManager().categoryByUniqueID(idUnique: transaction.predefCategoryID)
//                    
//                    if let categoryOfTransaction {
//                        let subcategoryOfTransaction = PredefinedSubcategoryManager().subcategoryByUniqueID(subcategories: categoryOfTransaction.subcategories, idUnique: transaction.predefSubcategoryID)
//                        
//                        if let subcategoryOfTransaction {
//                            if transaction.amount < 0 && subcategoryOfTransaction == subcategoryOfBudget && Calendar.current.isDate(transaction.date, equalTo: month, toGranularity: .month) {
//                                amount -= transaction.amount
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        return amount
//    }
    
    public func actualAmountForMonth(month: Date) -> Double {
        var amount: Double = 0.0
        
        let categoryOfBudget = PredefinedCategoryManager().categoryByUniqueID(idUnique: predefCategoryID)
        let subcategoryOfBudget = PredefinedSubcategoryManager().subcategoryByUniqueID(subcategories: categoryOfBudget?.subcategories ?? [], idUnique: predefSubcategoryID)

        if let subcategoryOfBudget {
            for transaction in subcategoryOfBudget.transactions {
                
                let categoryOfTransaction = PredefinedCategoryManager().categoryByUniqueID(idUnique: transaction.predefCategoryID)
                let subcategoryOfTransaction = PredefinedSubcategoryManager().subcategoryByUniqueID(subcategories: categoryOfTransaction?.subcategories ?? [], idUnique: transaction.predefSubcategoryID)
                
                if transaction.amount < 0 && subcategoryOfTransaction == subcategoryOfBudget && Calendar.current.isDate(transaction.date, equalTo: month, toGranularity: .month) {
                    amount -= transaction.amount
                }
            }
        }
        
        return amount
    }
    
    public func isExceeded(month: Date) -> Bool {
        if actualAmountForMonth(month: month) >= amount { return true } else { return false }
    }

}

extension Budget {
    
    static var preview1: Budget {
        let budget = Budget(context: previewViewContext)
        budget.id = UUID()
        budget.title = "Preview Budget 1"
        budget.amount = 500
        budget.predefCategoryID = categoryPredefined1.idUnique
        return budget
    }
    
    static var preview2: Budget {
        let budget = Budget(context: PersistenceController.preview.container.viewContext)
        budget.id = UUID()
        budget.title = "Preview Budget 2"
        budget.amount = 800
        budget.predefCategoryID = categoryPredefined2.idUnique
        budget.predefSubcategoryID = subCategory1Category2.idUnique
        
        return budget
    }
    
}

//MARK: - Color
extension Budget {
    public var color: Color {
        if let category = PredefinedCategoryManager().categoryByUniqueID(idUnique: predefCategoryID) {
            return category.color
        } else {
            return .red
        }
    }
}
