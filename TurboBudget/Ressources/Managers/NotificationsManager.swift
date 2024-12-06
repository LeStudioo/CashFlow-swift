//
//  NotificationsManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/12/2024.
//

import Foundation
import UserNotifications


class NotificationsManager {
    static let shared = NotificationsManager()
    
    private var pendingNotifications: [UNNotificationRequest] = []
    
    private init() {
        Task {
            self.pendingNotifications = await UNUserNotificationCenter.current().pendingNotificationRequests()
            print("🔔 PENDING NOTIFICATIONS : \(pendingNotifications.map(\.identifier))")
        }
    }
    
    /// Demande l'autorisation d'envoyer des notifications
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Erreur lors de la demande d'autorisation de notification : \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func scheduleNotification(for subscription: SubscriptionModel, daysBefore: Int) async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        guard settings.authorizationStatus == .authorized else {
            print("🔔 Les notifications ne sont pas autorisées")
            return
        }
                
        let existingNotification = pendingNotifications.first(where: { $0.identifier == "subscription_\(subscription.id ?? 0)" })
        if existingNotification != nil {
            print("🔔 Une notification existe déjà pour cet abonnement \(subscription.name ?? "")")
            return
        }
        
        // Calculer la date de notification
        guard let notificationDate = Calendar.current.date(byAdding: .day, value: -daysBefore, to: subscription.date) else {
            return
        }
        
        guard notificationDate > Date() else {
            print("🔔 La date de notification est déjà passée, annulation de la planification")
            return
        }
        
        // Forcer l'heure à 10h00
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: notificationDate)
        dateComponents.hour = 10
        dateComponents.minute = 0
        dateComponents.timeZone = TimeZone.current
        
        let notifMessage = subscription.type == .expense ? Word.Notifications.willRemoved : Word.Notifications.willAdded
        
        // Créer le contenu de la notification
        let content = UNMutableNotificationContent()
        content.title = "CashFlow"
        content.body = "\(subscription.amount ?? 0)\(currencySymbol) \(notifMessage) \(daysBefore) \(Word.Classic.days). (\(subscription.name ?? ""))"
        content.sound = .default
        
        // Créer un déclencheur avec les composants de date (qui forcera 10h00)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Créer et ajouter la requête de notification
        let request = UNNotificationRequest(identifier: "subscription_\(subscription.id ?? 0)", content: content, trigger: trigger)
        
        do {
            try await UNUserNotificationCenter.current().add(request)
            print("🔔 \(request.identifier) - Notification planifiée avec succès - \(notificationDate) - \(subscription.name ?? "")")
        } catch {
            print("🔔 Erreur lors de la planification de la notification : \(error.localizedDescription)")
        }
        
    }
    
    /// Supprime toutes les notifications en attente
    func removeAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("🔔 Toutes les notifications en attente ont été supprimées")
    }
    
    /// Supprime la notification d'une souscription spécifique
    func removePendingNotification(for subscriptionId: Int) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            let notificationToRemove = notifications.first { notification in
                return notification.content.userInfo["subscriptionId"] as? Int == subscriptionId
            }
            
            if let notification = notificationToRemove {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notification.identifier])
                print("🔔 Notification pour l'abonnement \(subscriptionId) supprimée")
            }
        }
    }
    
}
