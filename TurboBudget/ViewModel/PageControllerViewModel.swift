//
//  PageControllerViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 27/10/2023.
//

import Foundation

class PageControllerViewModel: ObservableObject {
    static let shared = PageControllerViewModel()
    
    @Published var showAddAccount: Bool = false
    @Published var showAddSavingPlan: Bool = false
    @Published var showRecoverTransaction: Bool = false
    @Published var showAddAutomation: Bool = false
    @Published var showScanTransaction: Bool = false
    @Published var showAddTransaction: Bool = false
    
    
}
