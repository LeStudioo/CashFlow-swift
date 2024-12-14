//
//  PreferencesSubscription.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/12/2024.
//

import Foundation

final class PreferencesSubscription: ObservableObject {
    static let shared = PreferencesSubscription()
    
    @CustomUserDefault("PreferencesSubscription_isNotificationsEnabled", defaultValue: false) // Notifiaction sent at 10h00
    var isNotificationsEnabled: Bool
    
    @CustomUserDefault("PreferencesSubscription_dayBeforeReceiveNotification", defaultValue: 1) // [1, 2, 3, 4, 5, 6, 7]
    var dayBeforeReceiveNotification: Int
    
}
