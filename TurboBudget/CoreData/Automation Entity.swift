//
//  Automation+CoreDataClass.swift
//  CashFlow
//
//  Created by KaayZenn on 18/07/2023.
//
//

import Foundation
import CoreData

@objc(Automation)
public class Automation: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Automation> {
        return NSFetchRequest<Automation>(entityName: "Automation")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var date: Date
    @NSManaged public var isNotif: Bool
    @NSManaged public var frenquently: Int16
    @NSManaged public var automationToTransaction: Transaction?
    @NSManaged public var automationToAccount: Account?
}
