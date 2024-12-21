//
//  SettingsSubscriptionView.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/12/2024.
//

import SwiftUI
import NotificationKit

struct SettingsSubscriptionView: View {
    
    @EnvironmentObject private var subscriptionRepository: SubscriptionRepository
    @StateObject private var preferencesSubscription: PreferencesSubscription = .shared
    
    // MARK: -
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $preferencesSubscription.isNotificationsEnabled) {
                    Text(Word.Classic.notifications)
                }
                if preferencesSubscription.isNotificationsEnabled {
                    Picker("", selection: $preferencesSubscription.dayBeforeReceiveNotification) {
                        ForEach(1...7, id: \.self) { day in
                            Text("\(day) \(Word.Notifications.daysBefore)").tag(day)
                        }
                    }
                }
            } footer: {
                Text(Word.Notifications.footer)
            }
        }
        .navigationTitle(Word.Main.subscription)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: preferencesSubscription.isNotificationsEnabled) { newValue in
            Task {
                if newValue {
                    if await NotificationsManager.shared.requestNotificationPermission() {
                        for subscription in subscriptionRepository.subscriptions {
                            guard let subscriptionID = subscription.id else { continue }
                            
                            await NotificationsManager.shared.scheduleNotification(
                                for: .init(
                                    id: subscriptionID,
                                    title: "CashFlow",
                                    message: subscription.notifMessage,
                                    date: subscription.date
                                ),
                                daysBefore: preferencesSubscription.dayBeforeReceiveNotification
                            )
                        }
                    } else {
                        preferencesSubscription.isNotificationsEnabled = false
                        return
                    }
                } else {
                    NotificationsManager.shared.removeAllPendingNotifications()
                }
            }
        }
        .onChange(of: preferencesSubscription.dayBeforeReceiveNotification) { newValue in
            NotificationsManager.shared.removeAllPendingNotifications()
            Task {
                for subscription in subscriptionRepository.subscriptions {
                    guard let subscriptionID = subscription.id else { continue }
                    
                    await NotificationsManager.shared.scheduleNotification(
                        for: .init(
                            id: subscriptionID,
                            title: "CashFlow",
                            message: subscription.notifMessage,
                            date: subscription.date
                        ),
                        daysBefore: newValue
                    )
                }
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    SettingsSubscriptionView()
}
