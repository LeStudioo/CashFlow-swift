//
//  Automation+CoreDataClass.swift
//  CashFlow
//
//  Created by KaayZenn on 18/07/2023.
//
//

import Foundation
import CoreData

extension Automation: Encodable {
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case amount
        case type
        case frequency
        case frequencyDate
        case creationDate
        case predefCategoryID = "categoryID"
        case predefSubcategoryID = "subcategoryID"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(automationToTransaction?.amount, forKey: .amount)
        try container.encode((automationToTransaction?.amount ?? 0) >= 0 ? 1 : 0, forKey: .type)
        try container.encode(0, forKey: .frequency)
        try container.encode(date?.toISO(), forKey: .frequencyDate)
        try container.encode(automationToTransaction?.predefCategoryID, forKey: .predefCategoryID)
        try container.encode(automationToTransaction?.predefSubcategoryID, forKey: .predefSubcategoryID)
    }
}

@objc(Automation)
public class Automation: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Automation> {
        return NSFetchRequest<Automation>(entityName: "Automation")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var date: Date?
    @NSManaged public var isNotif: Bool
    @NSManaged public var frenquently: Int16
    @NSManaged public var automationToTransaction: TransactionEntity?
    @NSManaged public var automationToAccount: Account?
}
