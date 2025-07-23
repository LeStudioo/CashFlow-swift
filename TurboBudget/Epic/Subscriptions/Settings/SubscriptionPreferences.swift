//
//  SubscriptionPreferences.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/12/2024.
//

import Foundation
import Combine
import StatsKit
import CoreModule

final class SubscriptionPreferences: ObservableObject {
    static let shared = SubscriptionPreferences()
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("PreferencesSubscription_isNotificationsEnabled", defaultValue: false) // Notifiaction sent at 10h00
    var isNotificationsEnabled: Bool {
        willSet {
            if newValue { EventService.sendEvent(key: .preferenceSubscriptionNotifications) }
            objectWillChange.send()
        }
    }
    
    @UserDefault("PreferencesSubscription_dayBeforeReceiveNotification", defaultValue: 1) // [1, 2, 3, 4, 5, 6, 7]
    var dayBeforeReceiveNotification: Int {
        willSet { objectWillChange.send() }
    }
    
}
