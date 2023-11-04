//
//  Notification Manager.swift
//  CashFlow
//
//  Created by KaayZenn on 18/07/2023.
//

import Foundation
import SwiftUI

class NotificationManager {
    
    //-------------------- createNotification() ----------------------
    // Description : Create a new notification
    // Parameter :
    // Output :
    // Extra : Add a badge
    //-----------------------------------------------------------
    func createNotification(transaction: Transaction, Automation: Automation, dateSchedule: Date) {
        
        //+1 for badge because we create a new notification
        let numberOfNotif = UserDefaults.standard.integer(forKey: "counterOfNotif")
        UserDefaults.standard.set(numberOfNotif + 1, forKey: "counterOfNotif")
        
        //New Notification Content
        let newNotification = UNMutableNotificationContent()
        newNotification.title = "CashFlow"
        newNotification.body = transaction.title
        newNotification.sound = .default
        newNotification.badge = (UserDefaults.standard.integer(forKey: "counterOfNotif")) as NSNumber
        
        let nextTriggerDate = Calendar.current.date(byAdding: .day, value: UserDefaultsManager().notificationTimeDay, to: dateSchedule)!
        
        //Setup date
        let yearDayAndMonth = Calendar.current.dateComponents([.year, .month, .day], from: nextTriggerDate)
        let hourAndMinute = Calendar.current.dateComponents([.hour, .minute], from: UserDefaultsManager().notificationTimeHour)
        
        //For transform Date to DateComponents
        var dateComponents: DateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: nextTriggerDate)
        dateComponents.year = yearDayAndMonth.year
        dateComponents.month = yearDayAndMonth.month
        dateComponents.day = yearDayAndMonth.day
        dateComponents.hour = hourAndMinute.hour
        dateComponents.minute = hourAndMinute.minute
        dateComponents.second = 0
        
        let triggerForNotif: UNNotificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //Create and add the request
        let requestNotif = UNNotificationRequest(identifier: Automation.id.uuidString, content: newNotification, trigger: triggerForNotif)
        UNUserNotificationCenter.current().add(requestNotif)

        print("✅ Notification is created")
        print("🔥 DATE COMPONENTS : \(Calendar.current.date(from: dateComponents)!)")
    }
    
    //-------------------- deleteNotification() ----------------------
    // Description : Delete a notification
    // Parameter : transaction -> Transaction
    // Output : Void
    // Extra : No
    //-----------------------------------------------------------
    func deleteNotification(transaction: Transaction, Automation: Automation) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (reqs) in
            var ids =  [String]()
            reqs.forEach {
                if $0.identifier.contains(Automation.id.uuidString) {
                    ids.append($0.identifier)
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
                }
            }
        }
    }
    
}
