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
    @NSManaged public var date: Date
    @NSManaged public var creationDate: Date
    @NSManaged public var note: String
    @NSManaged public var isAuto: Bool
    @NSManaged public var isArchived: Bool
    @NSManaged public var comeFromAuto: Bool
    @NSManaged public var transactionToAccount: Account?
    @NSManaged public var transactionToCategory: CategoryEntity?
    @NSManaged public var transactionToSubCategory: Subcategory?
    @NSManaged public var transactionToAutomation: Automation?

} //END Class
