//
//  SavingPlan+CoreDataProperties.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
//

import Foundation
import CoreData

@objc(SavingPlan)
public class SavingPlan: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavingPlan> {
        return NSFetchRequest<SavingPlan>(entityName: "SavingPlan")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var icon: String
    @NSManaged public var isArchived: Bool
    
    @NSManaged public var isEndDate: Bool
    @NSManaged public var dateOfEnd: Date?
    @NSManaged public var dateOfStart: Date
    
    @NSManaged public var amountOfStart: Double
    @NSManaged public var actualAmount: Double
    @NSManaged public var amountOfEnd: Double
    @NSManaged public var isStepEnable: Bool
    
    @NSManaged public var note: String
    
    @NSManaged public var position: Int64
    @NSManaged public var savingPlansToAccount: Account?
    @NSManaged public var savingPlansToContribution: Set<Contribution>?
    
    public var contributions: [Contribution] {
        if let contributions = savingPlansToContribution {
            return contributions.sorted { $0.date > $1.date }
        } else { return [] }
    }

}

// MARK: Generated accessors for savingPlansToContribution
extension SavingPlan {

    @objc(addSavingPlansToContributionObject:)
    @NSManaged public func addToSavingPlansToContribution(_ value: Contribution)

    @objc(removeSavingPlansToContributionObject:)
    @NSManaged public func removeFromSavingPlansToContribution(_ value: Contribution)

    @objc(addSavingPlansToContribution:)
    @NSManaged public func addToSavingPlansToContribution(_ values: NSSet)

    @objc(removeSavingPlansToContribution:)
    @NSManaged public func removeFromSavingPlansToContribution(_ values: NSSet)

}
