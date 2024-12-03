//
//  Contribution+CoreDataProperties.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
//

import Foundation
import CoreData

extension Contribution: Encodable {
    enum CodingKeys: String, CodingKey {
        case amount
        case date
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(amount, forKey: .amount)
        try container.encode(date?.ISO8601Format(), forKey: .date)
    }
}

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
