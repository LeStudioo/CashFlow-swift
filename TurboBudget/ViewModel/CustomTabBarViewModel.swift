//
//  CustomTabBarViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 27/10/2023.
//

import Foundation

class CustomTabBarViewModel: ObservableObject {
    static let shared = CustomTabBarViewModel()
    
    @Published var showAddAccount: Bool = false
    @Published var showAddSavingPlan: Bool = false
    @Published var showRecoverTransaction: Bool = false
    @Published var showAddAutomation: Bool = false
    @Published var showScanTransaction: Bool = false
    @Published var showAddTransaction: Bool = false
    
    @Published var showMenu: Bool = false
}

//MARK: - Navigation
extension CustomTabBarViewModel {
    
    func showAddAccountSheet() {
        showAddAccount.toggle()
        showMenu = false
    }
    
    func showAddSavingPlanSheet() {
        showAddSavingPlan.toggle()
        showMenu = false
    }
    
    func showRecoverTransactionSheet() {
        showRecoverTransaction.toggle()
        showMenu = false
    }
    
    func showAddAutomationSheet() {
        showAddAutomation.toggle()
        showMenu = false
    }
    
    func showScanTransactionSheet() {
        showScanTransaction.toggle()
        showMenu = false
    }
    
    func showAddTransactionSheet() {
        showAddTransaction.toggle()
        showMenu = false
    }
    
}
