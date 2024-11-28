//
//  TransactionEntity+CoreDataProperties.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
//

import Foundation
import CoreData

extension TransactionEntity: Encodable {
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case amount
        case type
        case date
        case creationDate
        case predefCategoryID = "categoryID"
        case predefSubcategoryID = "subcategoryID"
        case note
        
        case comeFromAuto = "isFromSubscription"
        case comeFromApplePay = "isFromApplePay"
        case nameFromApplePay
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(amount, forKey: .amount)
        try container.encode(amount >= 0 ? 1 : 0, forKey: .type)
        try container.encode(date?.ISO8601Format(), forKey: .date)
        try container.encode(predefCategoryID, forKey: .predefCategoryID)
        try container.encode(predefSubcategoryID, forKey: .predefSubcategoryID)
        try container.encode(note, forKey: .note)
        try container.encode(comeFromAuto, forKey: .comeFromAuto)
        try container.encode(comeFromApplePay, forKey: .comeFromApplePay)
        try container.encode(nameFromApplePay, forKey: .nameFromApplePay)
    }
}

@objc(Transaction)
public class TransactionEntity: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        return NSFetchRequest<TransactionEntity>(entityName: "Transaction")
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
