//
//  Budget+CoreDataProperties.swift
//  CashFlow
//
//  Created by KaayZenn on 03/08/2023.
//
//

import Foundation
import CoreData

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

}
