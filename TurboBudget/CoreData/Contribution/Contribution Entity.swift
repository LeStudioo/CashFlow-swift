//
//  Contribution+CoreDataProperties.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
//

import Foundation
import CoreData

@objc(Contribution)
public class Contribution: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contribution> {
        return NSFetchRequest<Contribution>(entityName: "Contribution")
    }

    @NSManaged public var id: UUID
    @NSManaged public var amount: Double
    @NSManaged public var date: Date?
    @NSManaged public var contributionToSavingPlan: SavingPlan?

}

extension Contribution {
    
    static var preview1: Contribution {
        let contribution = Contribution(context: previewViewContext)
        contribution.id = UUID()
        contribution.amount = 1000
        contribution.date = .now

        return contribution
    }
    
    static var preview2: Contribution {
        let contribution = Contribution(context: previewViewContext)
        contribution.id = UUID()
        contribution.amount = -500
        contribution.date = .now

        return contribution
    }
    
}
