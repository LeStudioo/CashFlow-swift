//
//  Filter.swift
//  CashFlow
//
//  Created by KaayZenn on 27/07/2023.
//

import Foundation
import SwiftUI

class Filter: Identifiable, ObservableObject {
    var id: UUID = UUID()
    
    @Published var date: Date = Date()
    
    @Published var showMenu: Bool = false
    @Published var fromBudget: Bool = false
    @Published var fromAnalytics: Bool = false
    
    @Published var byDay: Bool = false
    @Published var automation: Bool = false
    @Published var total: Bool = false
}

class FilterManager: ObservableObject {
    @Published var filter = Filter()
}

let sharedFilter = FilterManager().filter
