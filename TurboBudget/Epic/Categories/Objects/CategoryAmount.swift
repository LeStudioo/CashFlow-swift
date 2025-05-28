//
//  CategoryAmount.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/05/2025.
//

import Foundation

struct CategoryAmount: Identifiable {
    let id: UUID
    let categoryId: Int?
    let amount: Double
    
    init(categoryId: Int?, amount: Double) {
        self.id = UUID()
        self.categoryId = categoryId
        self.amount = amount
    }
}
