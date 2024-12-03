//
//  SavingPlan+CoreDataProperties.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
//

import Foundation
import CoreData

extension SavingPlan: Encodable {
    enum CodingKeys: String, CodingKey {
        case name
        case emoji
        case startDate
        case endDate
        case currentAmount
        case goalAmount
        case note
        case contributions
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .name)
        try container.encode(icon, forKey: .emoji)
        try container.encode(dateOfStart?.ISO8601Format(), forKey: .startDate)
        try container.encode(dateOfEnd?.ISO8601Format(), forKey: .endDate)
        try container.encode(actualAmount, forKey: .currentAmount)
        try container.encode(amountOfEnd, forKey: .goalAmount)
        try container.encode(note, forKey: .note)
        try container.encode(contributions, forKey: .contributions)
    }
}

@objc(SavingPlan)
public class SavingPlan: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavingPlan> {
        return NSFetchRequest<SavingPlan>(entityName: "SavingPlan")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var icon: String
    @NSManaged public var isArchived: Bool
    
    @NSManaged public var dateOfEnd: Date?
    @NSManaged public var dateOfStart: Date?
    
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
            return contributions.sorted { $0.date.withDefault > $1.date.withDefault }
        } else { return [] }
    }
}
