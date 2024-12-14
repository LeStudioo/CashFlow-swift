//
//  PreferencesApplePay.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/12/2024.
//

import Foundation

final class PreferencesApplePay: ObservableObject {
    static let shared = PreferencesApplePay()
        
    @CustomUserDefault("PreferencesApplePay_isAddCategoryAutomaticallyEnabled", defaultValue: false) // Notifiaction sent at 10h00
    var isAddCategoryAutomaticallyEnabled: Bool
    
}
