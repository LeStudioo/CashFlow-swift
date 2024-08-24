//
//  Transaction+CoreDataProperties.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
//

import Foundation
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var id: UUID
    
    @NSManaged public var predefCategoryID: String
    @NSManaged public var predefSubcategoryID: String
    
    @NSManaged public var title: String
    @NSManaged public var amount: Double
    @NSManaged public var date: Date?
    @NSManaged public var creationDate: Date
    @NSManaged public var note: String
    @NSManaged public var isAuto: Bool
    @NSManaged public var isArchived: Bool
    @NSManaged public var comeFromAuto: Bool
    @NSManaged public var comeFromApplePay: Bool
    @NSManaged public var nameFromApplePay: String
    @NSManaged public var transactionToAccount: Account?
    @NSManaged public var transactionToAutomation: Automation?

} // End class

extension Transaction {
    
    var category: PredefinedCategory? {
        return PredefinedCategory.findByID(self.predefCategoryID)
    }
    
    var subcategory: PredefinedSubcategory? {
        if let category {
            return category.subcategories.findByID(self.predefSubcategoryID)
        } else { return nil }
    }
    
}

extension Transaction {
    
    static var preview1: Transaction {
        let transaction = Transaction(context: previewViewContext)
        transaction.id = UUID()
        transaction.predefCategoryID = PredefinedCategory.PREDEFCAT1.id
        transaction.predefSubcategoryID = PredefinedCategory.PREDEFCAT1.subcategories[1].id
        transaction.title = "Preview Transaction"
        transaction.amount = -40.51
        transaction.date = Date()
        transaction.creationDate = Date()
        
        return transaction
    }
    
}
