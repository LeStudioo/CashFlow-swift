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
    @Published var showScanTransaction: Bool = false
    
    @Published var showMenu: Bool = false
}

//MARK: - Navigation
extension CustomTabBarViewModel {
    
    func showAddAccountSheet() {
        showAddAccount.toggle()
        showMenu = false
    }
    
    func showScanTransactionSheet() {
        showScanTransaction.toggle()
        showMenu = false
    }
    
}
