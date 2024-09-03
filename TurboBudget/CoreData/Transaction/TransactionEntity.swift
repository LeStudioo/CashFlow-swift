//
//  TransactionEntity+CoreDataProperties.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
//

import Foundation
import CoreData

@objc(Transaction)
public class TransactionEntity: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        return NSFetchRequest<TransactionEntity>(entityName: "Transaction")
    }

    @NSManaged public var id: UUID
    
    @NSManaged public var predefCategoryID: String
    @NSManaged public var predefSubcategoryID: String
    
    @NSManaged public var title: String
    @NSManaged public var amount: Double
    @NSManaged public var date: Date?
    @NSManaged public var creationDate: Date
    @NSManaged public var note: String
    @NSManaged public var isAuto: Bool
    @NSManaged public var isArchived: Bool
    @NSManaged public var comeFromAuto: Bool
    @NSManaged public var comeFromApplePay: Bool
    @NSManaged public var nameFromApplePay: String
    @NSManaged public var transactionToAccount: Account?
    @NSManaged public var transactionToAutomation: Automation?

} // End class

extension TransactionEntity {
    
    var category: PredefinedCategory? {
        return PredefinedCategory.findByID(self.predefCategoryID)
    }
    
    var subcategory: PredefinedSubcategory? {
        if let category {
            return category.subcategories.findByID(self.predefSubcategoryID)
        } else { return nil }
    }
    
}

extension TransactionEntity {
    
    static private func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
        if s1.isEmpty || s2.isEmpty { return 0 }
        
        let s1 = Array(s1)
        let s2 = Array(s2)
        let s1Count = s1.count
        let s2Count = s2.count
        
        var dp = [[Int]](repeating: [Int](repeating: 0, count: s2Count + 1), count: s1Count + 1)
        
        for i in 0...s1Count {
            dp[i][0] = i
        }
        
        for j in 0...s2Count {
            dp[0][j] = j
        }
        
        for i in 1...s1Count {
            for j in 1...s2Count {
                if s1[i - 1] == s2[j - 1] {
                    dp[i][j] = dp[i - 1][j - 1]
                } else {
                    dp[i][j] = min(dp[i - 1][j - 1], dp[i - 1][j], dp[i][j - 1]) + 1
                }
            }
        }
        
        return dp[s1Count][s2Count]
    }

    static private func similarityPercentage(_ s1: String, _ s2: String) -> Double {
        let maxLen = max(s1.count, s2.count)
        guard maxLen > 0 else { return 100.0 }
        
        let distance = levenshteinDistance(s1, s2)
        let similarity = 1.0 - (Double(distance) / Double(maxLen))
        
        return similarity * 100.0
    }
    
    static func findBestCategory(for title: String) -> (PredefinedCategory?, PredefinedSubcategory?) {
        let transactions = TransactionRepository.shared.transactions
        
        let transactionTitle = title
            .lowercased()
            .trimmingCharacters(in: .whitespaces)
        
        var arrayOfCandidate: [TransactionEntity] = []

        for transaction in transactions {
            let formattedTitle = transaction.title
                .lowercased()
                .trimmingCharacters(in: .whitespaces)
            if (similarityPercentage(formattedTitle, transactionTitle) >= 75
                || transactionTitle.contains(formattedTitle)
                || formattedTitle.contains(transactionTitle)
            ) && transactionTitle.count > 2 {
                arrayOfCandidate.append(transaction)
            }
        }

        // Au lieu de compter les catégories, créez un dictionnaire pour stocker la transaction la plus récente de chaque catégorie
        var mostRecentTransactionByCategory: [String: TransactionEntity] = [:]

        for candidate in arrayOfCandidate {
            if !candidate.predefCategoryID.isEmpty
                && candidate.predefCategoryID != PredefinedCategory.PREDEFCAT0.id
                && candidate.predefCategoryID != PredefinedCategory.PREDEFCAT00.id {
                // Vérifier si la transaction actuelle est plus récente que celle stockée
                if let existingTransaction = mostRecentTransactionByCategory[candidate.predefCategoryID], existingTransaction.date.withDefault < candidate.date.withDefault {
                    mostRecentTransactionByCategory[candidate.predefCategoryID] = candidate
                } else if mostRecentTransactionByCategory[candidate.predefCategoryID] == nil {
                    mostRecentTransactionByCategory[candidate.predefCategoryID] = candidate
                }
            }
        }

        // Trouvez la transaction la plus récente toutes catégories confondues
        guard let mostRecentTransaction = mostRecentTransactionByCategory.values
            .sorted(by: { $0.date.withDefault > $1.date.withDefault })
            .first 
        else { return (nil, nil) }

        guard let finalCategory = PredefinedCategory.findByID(mostRecentTransaction.predefCategoryID) else {
            return (nil, nil)
        }
        let finalSubcategory = finalCategory.subcategories.findByID(mostRecentTransaction.predefSubcategoryID)
        
        return (finalCategory, finalSubcategory)
    }

}

extension TransactionEntity {
    
    static var preview1: TransactionEntity {
        let transaction = TransactionEntity(context: previewViewContext)
        transaction.id = UUID()
        transaction.predefCategoryID = PredefinedCategory.PREDEFCAT1.id
        transaction.predefSubcategoryID = PredefinedCategory.PREDEFCAT1.subcategories[1].id
        transaction.title = "Preview TransactionEntity"
        transaction.amount = -40.51
        transaction.date = Date()
        transaction.creationDate = Date()
        
        return transaction
    }
    
}
