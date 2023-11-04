//
//  AddAutomationViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 02/11/2023.
//

import Foundation
import CoreData
import SwiftUI

enum AutomationFrequently: CaseIterable {
    case monthly, yearly
}

class AddAutomationViewModel: ObservableObject {
    static let shared = AddAutomationViewModel()
    let userDefaultsManager = UserDefaultsManager.shared
    let viewContext = persistenceController.container.viewContext
    
    @Published var selectedCategory: PredefinedCategory? = nil
    @Published var selectedSubcategory: PredefinedSubcategory? = nil
    @Published var titleTransaction: String = ""
    @Published var amountTransaction: Double = 0.0
    @Published var dayAutomation: Int = 1
    @Published var dateAutomation: Date = .now
    @Published var typeTransaction: ExpenseOrIncome = .expense
    @Published var automationFrenquently: AutomationFrequently = .monthly
    
    @Published var showSuccessfulAutomation: Bool = false
    @Published var allowNotification: Bool = false
    @Published var addNotification: Bool = false
    
    @Published var mainAccount: Account? = nil
    @Published var theNewTransaction: Transaction? = nil
    @Published var theNewAutomation: Automation? = nil
    @Published var info: MultipleAlert?
    
    // init
    init() {
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        var allAccount: [Account] = []
        do {
            allAccount = try viewContext.fetch(fetchRequest)
            if allAccount.count != 0 {
                mainAccount = allAccount[0]
            }
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
    
    func createNewAutomation() {
        
        let finalDate: Date
        if automationFrenquently == .monthly {
            var comps = Calendar.current.dateComponents([.day, .month, .year], from: Date())
            comps.day = dayAutomation
            finalDate = Calendar.current.date(from: comps) ?? .now
        } else {
            finalDate = dateAutomation
        }
        
        let newTransaction = Transaction(context: viewContext)
        newTransaction.id = UUID()
        newTransaction.title = titleTransaction
        newTransaction.amount = typeTransaction == .expense ? -amountTransaction : amountTransaction
        newTransaction.date = finalDate
        newTransaction.isAuto = true
        newTransaction.predefCategoryID = typeTransaction == .income ? categoryPredefined0.idUnique : selectedCategory?.idUnique ?? ""
        newTransaction.predefSubcategoryID = typeTransaction == .income ? "" : selectedSubcategory?.idUnique ?? ""
        
        let newAutomation = Automation(context: viewContext)
        newAutomation.id = UUID()
        newAutomation.title = titleTransaction
        newAutomation.date = finalDate
        newAutomation.frenquently = automationFrenquently == .monthly ? 0 : 1
        newAutomation.automationToTransaction = newTransaction
        newAutomation.automationToAccount = mainAccount
        
        newTransaction.transactionToAutomation = newAutomation
        
        //Create a Notification
        if allowNotification && addNotification {
            newAutomation.isNotif = true
            NotificationManager().createNotification(transaction: newTransaction, Automation: newAutomation, dateSchedule: newTransaction.date)
        }
        
        do {
            try viewContext.save()
            print("🔥 New Transaction created with Success")
            print("🔥 New Automation created with Success")
            theNewTransaction = newTransaction
            theNewAutomation = newAutomation
            withAnimation { showSuccessfulAutomation.toggle() }
        } catch {
            print("⚠️ Error for : \(error.localizedDescription)")
        }
    }
}

//MARK: - Utils
extension AddAutomationViewModel {
    
    //-------------------- checkAllowNotification() ----------------------
    // Description : Allows to know if the user has activated the notifications. If not, they are asked if they want to activate them or are told to go to their settings
    // Parameter : No
    // Output : Void
    // Extra :
    //-----------------------------------------------------------
    func checkAllowNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                self.allowNotification = true
            } else if let error = error {
                self.allowNotification = false
                self.userDefaultsManager.notificationTimeDay = 0
                print("⚠️ Error for check notif : \(error.localizedDescription)")
            } else {
                self.info = MultipleAlert(id: .one, title: NSLocalizedString("alert_notification_title", comment: ""), message: NSLocalizedString("alert_notification_desc", comment: ""), action: {})
                self.addNotification = false
                self.allowNotification = false
                self.userDefaultsManager.notificationTimeDay = 0
            }
        }
    }
}

//MARK: - Verification
extension AddAutomationViewModel {
    func validateAutomation() -> Bool {
        if !titleTransaction.isEmptyWithoutSpace() && amountTransaction != 0.0 && selectedCategory != nil {
            return true
        }
        return false
    }
}
