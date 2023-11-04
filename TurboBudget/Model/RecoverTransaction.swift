//
//  RecoverTransaction.swift
//  CashFlow
//
//  Created by Théo Sementa on 25/06/2023.
//

import Foundation
import SwiftUI

struct RecoverTransaction: Decodable {
    var id: UUID
    var predefCategoryID: String
    var predefSubcategoryID: String
    var title: String
    var amount: Double
    var date: Date
    var transactionToAccount: String
    var transactionToCategory: String
    var transactionToSubCategory: String
    
    private enum CodingKeys: String, CodingKey {
            case id, predefCategoryID, predefSubcategoryID, title, amount, date, transactionToAccount, transactionToCategory, transactionToSubCategory
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(UUID.self, forKey: .id)
            predefCategoryID = try container.decode(String.self, forKey: .predefCategoryID)
            predefSubcategoryID = try container.decode(String.self, forKey: .predefSubcategoryID)
            title = try container.decode(String.self, forKey: .title)
            amount = try container.decode(Double.self, forKey: .amount)
            date = try container.decode(Date.self, forKey: .date)
            transactionToAccount = try container.decode(String.self, forKey: .transactionToAccount)
            transactionToCategory = try container.decode(String.self, forKey: .transactionToCategory)
            transactionToSubCategory = try container.decode(String.self, forKey: .transactionToSubCategory)
        }
}
