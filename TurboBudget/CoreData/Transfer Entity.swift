//
//  Transfer+CoreDataProperties.swift
//  CashFlow
//
//  Created by KaayZenn on 23/11/2023.
//
//

import Foundation
import CoreData


@objc(Transfer)
public class Transfer: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transfer> {
        return NSFetchRequest<Transfer>(entityName: "Transfer")
    }

    @NSManaged public var id: UUID
    @NSManaged public var amount: Double
    @NSManaged public var date: Date
    @NSManaged public var note: String
    @NSManaged public var transferToSavingsAccount: SavingsAccount?

} 
