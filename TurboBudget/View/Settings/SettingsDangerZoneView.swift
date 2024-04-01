//
//  SettingsDangerZoneView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/02/2024.
//

import SwiftUI

struct SettingsDangerZoneView: View {
    
    // Builder
    @ObservedObject var account: Account
    
    // Custom
    @State private var info: MultipleAlert?
    
    // CoreData
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.position, ascending: true)])
    private var accounts: FetchedResults<Account>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Budget.id, ascending: true)])
    private var budgets: FetchedResults<Budget>
    
    // Environment
    @Environment(\.managedObjectContext) private var viewContext
    
    // Preferences
    @Preference(\.hapticFeedback) var hapticFeedback
    
    @Preference(\.isFaceIDEnabled) var isFaceIDEnabled
    @Preference(\.isSecurityPlusEnabled) var isSecurityPlusEnabled
    
    @Preference(\.colorSelected) var colorSelected
    
    @Preference(\.isSavingPlansDisplayedHomeScreen) var isSavingPlansDisplayedHomeScreen
    @Preference(\.numberOfSavingPlansDisplayedInHomeScreen) var numberOfSavingPlansDisplayedInHomeScreen
    @Preference(\.isAutomationsDisplayedHomeScreen) var isAutomationsDisplayedHomeScreen
    @Preference(\.numberOfAutomationsDisplayedInHomeScreen) var numberOfAutomationsDisplayedInHomeScreen
    @Preference(\.isRecentTransactionsDisplayedHomeScreen) var isRecentTransactionsDisplayedHomeScreen
    @Preference(\.numberOfRecentTransactionDisplayedInHomeScreen) var numberOfRecentTransactionDisplayedInHomeScreen
    
    @Preference(\.accountCanBeNegative) var accountCanBeNegative
    @Preference(\.blockExpensesIfCardLimitExceeds) var blockExpensesIfCardLimitExceeds
    @Preference(\.cardLimitPercentage) var cardLimitPercentage
    
    @Preference(\.automatedArchivedSavingPlan) var automatedArchivedSavingPlan
    @Preference(\.numberOfDayForArchivedSavingPlan) var numberOfDayForArchivedSavingPlan
    
    @Preference(\.blockExpensesIfBudgetAmountExceeds) var blockExpensesIfBudgetAmountExceeds
    @Preference(\.budgetPercentage) var budgetPercentage
    
    // MARK: - body
    var body: some View {
        Form {
            Section {
                Button(action: {
                    info = MultipleAlert(
                        id: .six,
                        title: "setting_home_reset_settings".localized,
                        message: "setting_home_reset_settings_desc".localized,
                        action: {
                            resetSettings()
                        }
                    )
                }, label: {
                    CellSettingsView(
                        icon: "arrow.counterclockwise",
                        backgroundColor: Color.red,
                        text: "setting_home_reset_settings".localized,
                        isButton: true
                    )
                })
            }
            
            Section {
                Button(action: {
                    info = MultipleAlert(
                        id: .seven,
                        title: "setting_home_reset_data".localized,
                        message: "setting_home_reset_data_desc".localized,
                        action: {
                            deleteAllData()
                        }
                    )
                }, label: {
                    CellSettingsView(
                        icon: "trash.fill",
                        backgroundColor: Color.red,
                        text: "setting_home_reset_data".localized,
                        isButton: true
                    )
                })
            }
        }
        .alert(item: $info, content: { info in
            Alert(title: Text(info.title), message: Text(info.message),
                  primaryButton: .cancel(Text("word_cancel".localized)) { return },
                  secondaryButton: .destructive(Text(info.id == .six ? "word_reset".localized : "word_delete".localized)) {
                info.action()
                persistenceController.saveContext()
            })
        })
        .navigationTitle("setting_home_danger".localized)
        .navigationBarTitleDisplayMode(.inline)
    } // End body
    
    // MARK: - Functions
    func deleteAllData() {
        DispatchQueue.main.async {
            deleteAccount()
            deleteTransaction()
            deleteSavingPlan()
            deleteContribution()
            deleteBudget()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            persistenceController.saveContext()
        }
    }
    
    func deleteAccount() {
        for account in accounts {
            viewContext.delete(account)
        }
    }
    
    func deleteTransaction() {
        for transactions in account.transactions {
            viewContext.delete(transactions)
        }
    }
    
    func deleteSavingPlan() {
        for savingPlan in account.savingPlans {
            viewContext.delete(savingPlan)
        }
    }
    
    func deleteContribution() {
        for savingPlan in account.savingPlans {
            for contribution in savingPlan.contributions {
                viewContext.delete(contribution)
            }
        }
    }
    
    func deleteBudget() {
        for budget in budgets {
            viewContext.delete(budget)
        }
    }
    
    func resetSettings() {
        
        // Setting - General
        hapticFeedback = true
        
        // Setting - Security
        isFaceIDEnabled = false
        isSecurityPlusEnabled = false
        
        // Setting - Display
        isAutomationsDisplayedHomeScreen = true
        numberOfAutomationsDisplayedInHomeScreen = 2
        
        isSavingPlansDisplayedHomeScreen = true
        numberOfSavingPlansDisplayedInHomeScreen = 4
        
        isRecentTransactionsDisplayedHomeScreen = true
        numberOfRecentTransactionDisplayedInHomeScreen = 5
        
        // Setting - Appearance
        colorSelected = "green"
        
        // Setting - Account
        accountCanBeNegative = false
        blockExpensesIfCardLimitExceeds = true
        cardLimitPercentage = 80
        
        // Setting - Saving Plan
        automatedArchivedSavingPlan = false
        numberOfDayForArchivedSavingPlan = 30
        
        // Setting - Budgets
        blockExpensesIfBudgetAmountExceeds = true
        budgetPercentage = 80
        
    }
    
} // End struct

// MARK: - Preview
#Preview {
    SettingsDangerZoneView(account: Account.preview)
}
