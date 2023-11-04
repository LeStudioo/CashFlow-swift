//
//  Card+CoreDataProperties.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
//

import Foundation
import CoreData

@objc(Card)
public class Card: NSManagedObject, Identifiable {

@nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var id: UUID
    @NSManaged public var holder: String
    @NSManaged public var number: String
    @NSManaged public var date: String
    @NSManaged public var cvv: String
    @NSManaged public var limit: Double
    @NSManaged public var color: String
    @NSManaged public var position: Int64
    @NSManaged public var cardToAccount: Account?
}
