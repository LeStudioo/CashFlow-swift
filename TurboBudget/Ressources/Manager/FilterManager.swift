//
//  FilterManager.swift
//  CashFlow
//
//  Created by KaayZenn on 16/03/2024.
//

import Foundation

class FilterManager: ObservableObject {
    static let shared = FilterManager()
    
    @Published var byMonth: Bool = false
    @Published var date: Date = Date()
    
    @Published var onlyExpenses: Bool = false
    @Published var onlyIncomes: Bool = false
    
    @Published var sortBy: FilterSort = .date
}

enum FilterSort {
    case date
    case ascendingOrder
    case descendingOrder
    case alphabetic
}
