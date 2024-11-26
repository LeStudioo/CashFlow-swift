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

extension Budget: Encodable {
    enum CodingKeys: String, CodingKey {
        case name
        case amount
        case categoryID
        case subcategoryID
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .name)
        try container.encode(amount, forKey: .amount)
        try container.encode(predefCategoryID, forKey: .categoryID)
        try container.encode(predefSubcategoryID, forKey: .subcategoryID)
    }
}

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
    
    public var color: Color {
        if let category = PredefinedCategory.findByID(predefCategoryID) {
            return category.color
        } else {
            return .red
        }
    }
    
    // TODO: - voir pour reactiuver
//    public func actualAmountForMonth(month: Date) -> Double {
//        var amount: Double = 0.0
//        
//        guard let categoryOfBudget = PredefinedCategory.findByID(predefCategoryID), let subcategoryOfBudget = categoryOfBudget.subcategories.findByID(predefSubcategoryID) else {
//            return 0
//        }
//        
//        for transaction in subcategoryOfBudget.transactions {
//            if let categoryOfTransaction = transaction.category {
//                let subcategoryOfTransaction = transaction.subcategory
//                
//                if transaction.type == .expense && subcategoryOfTransaction == subcategoryOfBudget && Calendar.current.isDate(transaction.date.withDefault, equalTo: month, toGranularity: .month) {
//                    amount += transaction.amount ?? 0
//                }
//            }
//        }
//        
//        return amount
//    }
    
    public func isExceeded(month: Date) -> Bool {
//        if actualAmountForMonth(month: month) >= amount {
//            return true
//        } else {
            return false
//        }
    }

}

// MARK: - Preview
extension Budget {
    
    static var preview1: Budget {
        let budget = Budget(context: previewViewContext)
        budget.id = UUID()
        budget.title = "Preview Budget 1"
        budget.amount = 500
        budget.predefCategoryID = PredefinedCategory.PREDEFCAT1.id
        return budget
    }
    
    static var preview2: Budget {
        let budget = Budget(context: PersistenceController.preview.container.viewContext)
        budget.id = UUID()
        budget.title = "Preview Budget 2"
        budget.amount = 800
        budget.predefCategoryID = PredefinedCategory.PREDEFCAT2.id
        budget.predefSubcategoryID = PredefinedSubcategory.PREDEFSUBCAT1CAT2.id
        
        return budget
    }
    
}
