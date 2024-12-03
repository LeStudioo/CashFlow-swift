//
//  Account+CoreDataProperties.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
//

import Foundation
import CoreData
import CloudKit

extension Account: Encodable {
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case balance
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(balance, forKey: .balance)
    }
}

@objc(Account)
public class Account: NSManagedObject, Identifiable {
    private let persistenceController = PersistenceController.shared
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var balance: Double
    @NSManaged public var cardLimit: Double
    @NSManaged public var position: Int64
    @NSManaged public var accountToTransaction: Set<TransactionEntity>?
    @NSManaged public var accountToSavingPlan: Set<SavingPlan>?
    @NSManaged public var accountToAutomation: Set<Automation>?
    
    public var allTransactions: [TransactionEntity] {
        if let transactions = accountToTransaction {
            return transactions
                .sorted { $0.date.withDefault > $1.date.withDefault }
                .filter({ !$0.isAuto && $0.predefCategoryID != "" })
        } else { return [] }
    }

    public var transactions: [TransactionEntity] {
        if let transactions = accountToTransaction {
            return transactions
                .filter({ !$0.isAuto && $0.predefCategoryID != "" })
                .sorted {
                    if $0.date == $1.date {
                        return $0.title < $1.title
                    } else {
                        return $0.date.withDefault > $1.date.withDefault
                    }
                }
        } else { return [] }
    }
    
    public var savingPlans: [SavingPlan] {
        if let savingPlans = accountToSavingPlan {
            return savingPlans.sorted { $0.actualAmount > $1.actualAmount }.filter({ !$0.isArchived })
        } else { return [] }
    }
    
    public var savingPlansArchived: [SavingPlan] {
        if let savingPlans = accountToSavingPlan {
            return savingPlans.filter({ $0.isArchived }).sorted { $0.dateOfEnd! > $1.dateOfEnd! }
        } else { return [] }
    }

} // END Class
