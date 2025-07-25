//
//  CategoryModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/11/2024.
//

import Foundation
import SwiftUI
import CoreModule

struct CategoryModel: Identifiable, Equatable, Hashable {
    var id: Int
    var name: String
    var icon: ImageResource
    var color: Color
    var subcategories: [SubcategoryModel]?
}

extension CategoryModel {
    
    static var revenue: CategoryModel? {
        return CategoryStore.shared.findCategoryById(1)
    }
    
    static var toCategorized: CategoryModel? {
        return CategoryStore.shared.findCategoryById(0)
    }
    
    var isIncome: Bool {
        return self.name == "word_income".localized
    }
    
    var isToCategorized: Bool {
        return self.name == "category00_name".localized
    }
    
}

extension CategoryModel: Searchable {
    var searchableText: String {
        let subcategoryNames = subcategories?.map { $0.name } ?? []
        return "\(name) \(subcategoryNames.joined(separator: " "))"
    }
}

extension CategoryModel {
    
    var transactions: [TransactionModel] {
        return TransactionStore.shared.transactions.filter { $0.category?.id == self.id }
    }
    
    /// Transactions of type expense in a Category
    var expenses: [TransactionModel] {
        return transactions.filter { $0.type == .expense }
    }
    
    /// Transactions of type income in a Category
    var incomes: [TransactionModel] {
        return transactions.filter { $0.type == .income }
    }
    
    /// Transactions from Subscription in a Category
    var subscriptions: [TransactionModel] {
        return transactions.filter { $0.isFromSubscription == true }
    }

    var transactionsFiltered: [TransactionModel] {
        return self.transactions
            .filter { Calendar.current.isDate($0.date, equalTo: FilterManager.shared.date, toGranularity: .month) }
    }
    
}

extension CategoryModel {
    
    var categorySlices: [PieSliceData] {
        var array: [PieSliceData] = []
        let filterManager = FilterManager.shared
        
        for subcategory in self.subcategories ?? [] {
            let transactionsFiltered = subcategory.transactions
                .filter { Calendar.current.isDate($0.date, equalTo: filterManager.date, toGranularity: .month) }
            
            let amount = transactionsFiltered
                .map { $0.amount }
                .reduce(0, +)
            
            if amount != 0 {
                array.append(
                    .init(
                        categoryID: self.id,
                        subcategoryID: subcategory.id,
                        icon: subcategory.icon,
                        value: subcategory.transactionsFiltered
                            .map { $0.amount }
                            .reduce(0, +),
                        color: subcategory.color
                    )
                )
            }
        }
        
        return array
    }
        
}
