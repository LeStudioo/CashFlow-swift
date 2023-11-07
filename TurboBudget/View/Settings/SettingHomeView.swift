//
//  SettingsHomeView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//
// Localizations 01/10/2023

import SwiftUI
import Setting
import LocalAuthentication
import CoreData
import CloudKit

struct SettingsHomeView: View {
    
    //Custom type
    var account: Account?
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    @State private var info: MultipleAlert?
    @StateObject var settingViewModel = SettingViewModel()
    
    //CoreData
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.position, ascending: true)])
    private var accounts: FetchedResults<Account>
    
    //Environnements
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    //EnvironnementsObject
    @EnvironmentObject var csManager: ColorSchemeManager
    @EnvironmentObject var store: Store
    
    //State or Binding String
    
    //State or Binding Int, Float and Double
    
    //State or Binding Bool
    @Binding var update: Bool
    @State private var isSharing: Bool = false
    @State private var showAlertPaywall: Bool = false
    @State private var showPaywall: Bool = false
    @State private var isDarkMode: Bool = false
    
    //Enum
    
    //Computed var
    private var arrayOfAccounts: [Account] { return Array(accounts) }
    
    //Preferences - Display
    @State private var indexAutomationsNumber: Int = 0
    @State private var indexSavingPlansNumber: Int = 0
    @State private var indexTransactionsNumber: Int = 0
    
    //Preferences - Transactions
    @State private var recentTransactions: [String] = ["5", "6", "7", "8", "9", "10"]
    @State private var indexDayArchivedTransaction: Int = 0
    
    //Setting - Saving Plan
    @State private var indexDayArchivedSavingPlan: Int = 0
    
    //Setting - Budget
    @State private var indexPercentageBudgetAlert: Int = 0
    
    //Preferences - Account
    @State private var indexChoosePercentage: Int = 0
    @State private var percentages: [String] = ["50%", "55%", "60%", "65%", "70%", "75%", "80%", "85%", "90%", "95%"]
    
    //Preferences - Notifications
    @State private var indexChooseNotif: Int = 0
    @State var notifications: [String] = [
        NSLocalizedString("setting_home_same_day", comment: ""),
        NSLocalizedString("setting_home_one_day_before", comment: ""),
        NSLocalizedString("setting_home_two_days_before", comment: ""),
        NSLocalizedString("setting_home_five_days_before", comment: ""),
        NSLocalizedString("setting_home_ten_days_before", comment: "")
    ]
    @State var notificationTimeHour: Date = Date()
    
    //Appearance
    @State private var colorSelected: String = ""
    
    //MARK: - Body
    var body: some View {
        SettingStack(isSearchable: true, settingViewModel: settingViewModel) {
            SettingPage(title: NSLocalizedString("setting_home_title", comment: "")) {
                
                SettingGroup {
                    SettingButton(title: NSLocalizedString("setting_home_cashflow_pro", comment: ""), action: { showPaywall.toggle() })
                        .icon(icon: .system(icon: "crown.fill", foregroundColor: Color.white, backgroundColor: Color.primary500))
                }
                
                SettingGroup {
                    
                    //MARK: General
                    settingGeneralView()
                    
                    //MARK: Appearance
                    SettingPage(title: NSLocalizedString("setting_home_appearance", comment: "")) {
                        SettingCustomView { SettingAppearenceView(colorSelected: $colorSelected, update: $update) }
                    }
                    .previewIcon("sun.max.fill", backgroundColor: .indigo)
                    
                    //MARK: Display
                    settingDisplayView(indexAutomationsNumber: $indexAutomationsNumber, indexSavingPlansNumber: $indexSavingPlansNumber, indexTransactionsNumber: $indexTransactionsNumber)
                }
                
                SettingGroup {
                    //MARK: Security
                    settingSecurityView()
                    
                    //MARK: Notification
                    SettingPage(title: NSLocalizedString("word_notification", comment: "")) {
                        SettingGroup(footer: NSLocalizedString("setting_home_notification_desc", comment: "")) {
                            SettingPicker(title: NSLocalizedString("word_notifications", comment: ""), choices: notifications, selectedIndex: $indexChooseNotif)
                                .pickerDisplayMode(.menu)
                        }
                        SettingGroup(footer: NSLocalizedString("setting_home_notification_picker_time_desc", comment: "")) {
                            SettingCustomView {
                                VStack {
                                    DatePicker(NSLocalizedString("setting_home_notification_picker_time", comment: ""), selection: $notificationTimeHour, displayedComponents: .hourAndMinute)
                                        .onChange(of: notificationTimeHour) { newValue in
                                            userDefaultsManager.notificationTimeHour = notificationTimeHour
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                }
                            }
                        }
                    }
                    .previewIcon("bell.fill", foregroundColor: .white, backgroundColor: .red)
                }
                
                SettingGroup {
                    settingAccountView(indexChoosePercentage: $indexChoosePercentage)
                    settingTransactionView(indexDayArchivedTransaction: $indexDayArchivedTransaction)
                    settingSavingPlansView(indexDayArchived: $indexDayArchivedSavingPlan)
                    if store.isLifetimeActive {
                        settingBudgetsView(indexChoosePercentage: $indexPercentageBudgetAlert)
                        settingFinancialAdviceView(isDarkMode: $isDarkMode)
                    } else {
                        SettingButton(icon: .system(icon: "chart.pie.fill", foregroundColor: .white, backgroundColor: .purple), title: NSLocalizedString("word_budgets", comment: ""), indicator: "lock.fill", action: { showAlertPaywall.toggle() })
                        SettingButton(icon: .system(icon: "text.book.closed.fill", foregroundColor: .white, backgroundColor: .green), title: NSLocalizedString("word_financial_advice", comment: ""), indicator: "lock.fill", action: { showAlertPaywall.toggle() })
                    }
                }
                
                SettingGroup {
                    SettingButton(title: NSLocalizedString("setting_home_write_review", comment: ""), action: {
                        let url = URL(string: "https://itunes.apple.com/app/https://apps.apple.com/gb/app/cashflow-tracker/id6450913423?action=write-review")!
                        if UIApplication.shared.canOpenURL(url) { UIApplication.shared.open(url) }
                    })
                        .icon("star.fill", backgroundColor: .orange)
                    SettingButton(title: NSLocalizedString("setting_home_share_app", comment: ""), action: { isSharing.toggle() })
                        .icon("square.and.arrow.up.fill")
                    SettingButton(title: NSLocalizedString("setting_home_report_bug", comment: ""), action: {
                        let url = URL(string: "https://docs.google.com/forms/d/1Y7hJEwy3oNWfs1udHR8e9AsifMuCOfsiWoZLMLBDwlY/")!
                        if UIApplication.shared.canOpenURL(url) { UIApplication.shared.open(url) }
                    })
                    .icon("exclamationmark.triangle.fill", backgroundColor: .red)
                    SettingButton(title: NSLocalizedString("setting_home_new_features", comment: ""), action: {
                        let url = URL(string: "https://docs.google.com/forms/u/3/d/1LPAvhoByojEFjCbkHd_dzGBDFEigJGeqQD9ZSwhbNvk/")!
                        if UIApplication.shared.canOpenURL(url) { UIApplication.shared.open(url) }
                    })
                    .icon("wand.and.stars", backgroundColor: .purple)
                }
                
                SettingGroup {
                    //MARK: - Credits
                    settingCreditsView(isDarkMode: $isDarkMode)
                    
                    //MARK: - More from this Developer
                    SettingButton(title: NSLocalizedString("setting_home_more_from_dev", comment: "")) {
                        let url = URL(string: "https://apps.apple.com/fr/developer/theo-sementa/id1608409500")!
                        if UIApplication.shared.canOpenURL(url) { UIApplication.shared.open(url) }
                    }
                    .icon("app.badge.checkmark.fill", backgroundColor: .blue)
                }
                
                SettingGroup {
                    SettingButton(title: NSLocalizedString("setting_home_privacy_policy", comment: ""), action: { })
                        .icon("lock.fill", foregroundColor: .blue, backgroundColor: .clear)
                    
                    SettingButton(title: NSLocalizedString("setting_home_terms_conditions", comment: ""), action: {
                        let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!
                        if UIApplication.shared.canOpenURL(url) { UIApplication.shared.open(url) }
                    })
                    .icon("hand.raised.fill", foregroundColor: .blue, backgroundColor: .clear)
                }
                
                SettingGroup {
                    SettingPage(title: NSLocalizedString("setting_home_danger", comment: "")) {
                        SettingGroup {
                            SettingButton(title: NSLocalizedString("setting_home_reset_settings", comment: ""), action: {
                                info = MultipleAlert(id: .six, title: NSLocalizedString("setting_home_reset_settings", comment: ""), message: NSLocalizedString("setting_home_reset_settings_desc", comment: ""), action: { resetSettings() })
                            })
                            .icon("arrow.counterclockwise", foregroundColor: .white, backgroundColor: .red)
                        }
                        
                        SettingGroup {
                            SettingButton(title: NSLocalizedString("setting_home_reset_data", comment: ""), action: {
                                info = MultipleAlert(id: .seven, title: NSLocalizedString("setting_home_reset_data", comment: ""), message: NSLocalizedString("setting_home_reset_data_desc", comment: ""), action: { deleteAllData() })
                            })
                            .icon("trash.fill", foregroundColor: .white, backgroundColor: .red)
                        }
                    }
                    .previewIcon("trash.fill", backgroundColor: .red)
                }
                
                SettingCustomView {
                    HStack {
                        Spacer()
                        Text(NSLocalizedString("setting_home_made_by", comment: ""))
                            .foregroundColor(.colorLabel)
                            .font(.semiBoldText16())
                        Spacer()
                    }
                }
            }
        } customNoResultsView: {
            VStack(spacing: 20) {
                Image("NoResults\(themeSelected)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 4, y: 4)
                    .frame(width: isIPad ? (orientation.isLandscape ? UIScreen.main.bounds.width / 3 : UIScreen.main.bounds.width / 2) : UIScreen.main.bounds.width / 1.5 )
                
                Text(NSLocalizedString("word_no_results", comment: "") + " '\(settingViewModel.searchText)'")
                    .font(Font.mediumText16())
                    .multilineTextAlignment(.center)
            }
            .offset(y: -20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(update ? 0 : 0)
        .background(SharingViewController(isPresenting: $isSharing) {
            let urlApp = URL(string: "https://apps.apple.com/fr/app/cashflow-tracker/id6450913423")!
            let text: String = NSLocalizedString("setting_home_alert_share_desc", comment: "")
            let av = UIActivityViewController(activityItems: [text, urlApp], applicationActivities: nil)
            
            // For iPad
            if UIDevice.current.userInterfaceIdiom == .pad { av.popoverPresentationController?.sourceView = UIView() }
            
            av.completionWithItemsHandler = { _, _, _, _ in
                isSharing = false // required for re-open !!!
            }
            return av
        })
        .onAppear {
            isDarkMode = colorScheme == .light ? false : true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                for index in recentTransactions.indices {
                    if userDefaultsManager.recentTransactionNumber == Int(recentTransactions[index]) {
                        indexTransactionsNumber = index
                    }
                }
                
                for index in percentages.indices {
                    if userDefaultsManager.cardLimitPercentage == Double(percentages[index].replacingOccurrences(of: "%", with: "", options: NSString.CompareOptions.literal, range: nil)) {
                        indexChoosePercentage = index
                    }
                }
                
                for index in percentages.indices {
                    if userDefaultsManager.budgetPercentage == Double(percentages[index].replacingOccurrences(of: "%", with: "", options: NSString.CompareOptions.literal, range: nil)) {
                        indexPercentageBudgetAlert = index
                    }
                }
                
                indexChooseNotif = -userDefaultsManager.notificationTimeDay
                
                notificationTimeHour = userDefaultsManager.notificationTimeHour
                
                colorSelected = userDefaultsManager.colorSelected
                
                switch userDefaultsManager.numberOfAutomationsDisplayedInHomeScreen {
                case 2: indexAutomationsNumber = 0
                case 4: indexAutomationsNumber = 1
                case 6: indexAutomationsNumber = 2
                default: break
                }
                
                switch userDefaultsManager.numberOfSavingPlansDisplayedInHomeScreen {
                case 2: indexSavingPlansNumber = 0
                case 4: indexSavingPlansNumber = 1
                case 6: indexSavingPlansNumber = 2
                default: break
                }
                
                switch userDefaultsManager.numberOfDayForArchivedTransaction {
                case 0: indexDayArchivedTransaction = 0
                case 1: indexDayArchivedTransaction = 1
                case 2: indexDayArchivedTransaction = 2
                case 3: indexDayArchivedTransaction = 3
                case 5: indexDayArchivedTransaction = 4
                case 10: indexDayArchivedTransaction = 5
                case 30: indexDayArchivedTransaction = 6
                default: break
                }
                
                switch userDefaultsManager.numberOfDayForArchivedSavingPlan {
                case 0: indexDayArchivedSavingPlan = 0
                case 1: indexDayArchivedSavingPlan = 1
                case 2: indexDayArchivedSavingPlan = 2
                case 3: indexDayArchivedSavingPlan = 3
                case 5: indexDayArchivedSavingPlan = 4
                case 10: indexDayArchivedSavingPlan = 5
                case 30: indexDayArchivedSavingPlan = 6
                default: break
                }
                
            }
        }
        .onDisappear { update.toggle() }
        .onChange(of: indexTransactionsNumber, perform: { newValue in
            userDefaultsManager.recentTransactionNumber = Int(recentTransactions[newValue])!
        })
        .onChange(of: userDefaultsManager.isFaceIDEnable) { newValue in
            if userDefaultsManager.isFaceIDEnable == false && newValue {
                authenticate()
                userDefaultsManager.isFaceIDEnable = true
            } else if !newValue {
                userDefaultsManager.isFaceIDEnable = false
            }
        }
        .onChange(of: indexAutomationsNumber, perform: { newValue in
            switch newValue {
            case 0: userDefaultsManager.numberOfAutomationsDisplayedInHomeScreen = 2
            case 1: userDefaultsManager.numberOfAutomationsDisplayedInHomeScreen = 4
            case 2: userDefaultsManager.numberOfAutomationsDisplayedInHomeScreen = 6
            default: break
            }
        })
        .onChange(of: indexSavingPlansNumber, perform: { newValue in
            switch newValue {
            case 0: userDefaultsManager.numberOfSavingPlansDisplayedInHomeScreen = 2
            case 1: userDefaultsManager.numberOfSavingPlansDisplayedInHomeScreen = 4
            case 2: userDefaultsManager.numberOfSavingPlansDisplayedInHomeScreen = 6
            default: break
            }
        })
        .onChange(of: indexDayArchivedTransaction, perform: { newValue in
            switch newValue {
            case 0: userDefaultsManager.numberOfDayForArchivedTransaction = 0
            case 1: userDefaultsManager.numberOfDayForArchivedTransaction = 1
            case 2: userDefaultsManager.numberOfDayForArchivedTransaction = 2
            case 3: userDefaultsManager.numberOfDayForArchivedTransaction = 3
            case 4: userDefaultsManager.numberOfDayForArchivedTransaction = 5
            case 5: userDefaultsManager.numberOfDayForArchivedTransaction = 10
            case 6: userDefaultsManager.numberOfDayForArchivedTransaction = 30
            default: break
            }
        })
        .onChange(of: indexDayArchivedSavingPlan, perform: { newValue in
            switch newValue {
            case 0: userDefaultsManager.numberOfDayForArchivedSavingPlan = 0
            case 1: userDefaultsManager.numberOfDayForArchivedSavingPlan = 1
            case 2: userDefaultsManager.numberOfDayForArchivedSavingPlan = 2
            case 3: userDefaultsManager.numberOfDayForArchivedSavingPlan = 3
            case 4: userDefaultsManager.numberOfDayForArchivedSavingPlan = 5
            case 5: userDefaultsManager.numberOfDayForArchivedSavingPlan = 10
            case 6: userDefaultsManager.numberOfDayForArchivedSavingPlan = 30
            default: break
            }
        })
        .onChange(of: indexChoosePercentage, perform: { index in
            userDefaultsManager.cardLimitPercentage = Double(percentages[index].replacingOccurrences(of: "%", with: "", options: NSString.CompareOptions.literal, range: nil)) ?? 0
        })
        .onChange(of: indexPercentageBudgetAlert, perform: { index in
            userDefaultsManager.budgetPercentage = Double(percentages[index].replacingOccurrences(of: "%", with: "", options: NSString.CompareOptions.literal, range: nil)) ?? 0
        })
        .onChange(of: indexChooseNotif) { newValue in
            userDefaultsManager.notificationTimeDay = -newValue
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading ) {
                Button(action: { dismiss() }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.colorLabel)
                })
                .padding(.bottom, 8)
            }
        }
        .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
        .alert(item: $info, content: { info in
            Alert(title: Text(info.title), message: Text(info.message),
                  primaryButton: .cancel(Text(NSLocalizedString("word_cancel", comment: ""))) { return },
                  secondaryButton: .destructive(Text(info.id == .six ? NSLocalizedString("word_reset", comment: "") : NSLocalizedString("word_delete", comment: ""))) {
                info.action()
                persistenceController.saveContext()
            })
        })
        .alert(NSLocalizedString("alert_cashflow_pro_title", comment: ""), isPresented: $showAlertPaywall, actions: {
            Button(action: { return }, label: { Text(NSLocalizedString("word_cancel", comment: "")) })
            Button(action: { showPaywall.toggle() }, label: { Text(NSLocalizedString("alert_cashflow_pro_see", comment: "")) })
        }, message: {
            Text(NSLocalizedString("alert_cashflow_pro_desc", comment: ""))
        })
        .sheet(isPresented: $showPaywall, content: { PaywallScreenView() })
    }//END body
        
    //MARK: Fonctions
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = NSLocalizedString("alert_request_biometric", comment: "")
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success { userDefaultsManager.isFaceIDEnable = true } else {
                    userDefaultsManager.isFaceIDEnable = false
                }
            }
        } else { /* no biometrics */ }
    }
    
    func deleteAllData() {
        DispatchQueue.main.async {
            deleteAccount()
            deleteTransaction()
            deleteSavingPlan()
            deleteContribution()
            deleteCard()
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
    
    func deleteCard() {
        if let card = account?.accountToCard {
            viewContext.delete(card)
        }
    }
    
    func deleteTransaction() {
        if let account {
            for transactions in account.transactions {
                viewContext.delete(transactions)
            }
        }
    }
    
    func deleteSavingPlan() {
        if let account {
            for savingPlan in account.savingPlans {
                viewContext.delete(savingPlan)
            }
        }
    }
    
    func deleteContribution() {
        if let account {
            for savingPlan in account.savingPlans {
                for contribution in savingPlan.contributions { viewContext.delete(contribution) }
            }
        }
        
    }
    
    
    func deleteEntity(entityName: String) {
        let context = persistenceController.container.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do { try context.execute(batchDeleteRequest) } catch {
            print("Erreur lors de la suppression des données CoreData : \(error.localizedDescription)")
        }
    }
    
    //MARK: Reset Setting
    func resetSettings() {
        
        //Setting - General
        userDefaultsManager.hapticFeedback = true
        
        //Setting - Display
        userDefaultsManager.isSavingPlansDisplayedHomeScreen = true
        userDefaultsManager.isAutomationsDisplayedHomeScreen = true
        userDefaultsManager.isRecentTransactionsDisplayedHomeScreen = true
        userDefaultsManager.isIncomeFromTransactionsChart = true
        userDefaultsManager.isIncomeFromTransactionsWithAutomationChart = true
        userDefaultsManager.isExpenseTransactionsChart = true
        userDefaultsManager.isExpenseTransactionsWithAutomationChart = true
        let charts = [NSLocalizedString("word_incomes", comment: ""),
                      NSLocalizedString("word_expenses", comment: ""),
                      NSLocalizedString("word_automations_incomes", comment: ""),
                      NSLocalizedString("word_automations_expenses", comment: "")]
        userDefaultsManager.orderOfCharts = charts
        
        //Setting - Appearance
        csManager.colorScheme = .unspecified
        userDefaultsManager.colorSelected = "111"
        
        //Setting - Security
        userDefaultsManager.isFaceIDEnable = false
        userDefaultsManager.isSecurityPlusEnable = false
        
        //Setting - Account
        userDefaultsManager.accountCanBeNegative = false
        userDefaultsManager.blockExpensesIfCardLimitExceeds = true
        userDefaultsManager.cardLimitPercentage = 80
        
        //Setting - Transactions
        userDefaultsManager.recentTransactionNumber = 5
        userDefaultsManager.automatedArchivedTransaction = false
        userDefaultsManager.numberOfDayForArchivedTransaction = 0
        
        //Setting - Saving Plan
        userDefaultsManager.automatedArchivedSavingPlan = false
        userDefaultsManager.numberOfDayForArchivedSavingPlan = 0
        
        //Setting - Budgets
        userDefaultsManager.blockExpensesIfBudgetAmountExceeds = true
        userDefaultsManager.budgetPercentage = 80
        
        //Setting - Financial Adivce
        userDefaultsManager.isBuyingQualityEnable = false
        userDefaultsManager.isPayingYourselfFirstEnable = false
        userDefaultsManager.isSearchDuplicateEnable = false
        
        //Setting - Notifications
        userDefaultsManager.notificationTimeDay = 0
        
        var components = DateComponents()
        components.hour = 10
        components.minute = 0
        
        let dateDefaultNotificationHour = Calendar.current.date(from: components)
        
        if let dateDefaultNotificationHour {
            userDefaultsManager.notificationTimeHour = dateDefaultNotificationHour
        }
        
    }
    
//        func supprimerDonneesCloudKit() {
//            let container = CKContainer.default()
//            let database = container.publicCloudDatabase
//    
//            let fetchAllRecords = CKFetchRecordsOperation.fetchAllRecordsOperation()
//            fetchAllRecords.fetchRecordsCompletionBlock = { recordsByRecordID, error in
//                guard let records = recordsByRecordID?.values else { return }
//    
//                let deleteRecords = records.map { recordID, _ in
//                    return CKRecord.ID(recordName: recordID.recordName)
//                }
//    
//                let deleteOperation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: deleteRecords)
//                deleteOperation.modifyRecordsCompletionBlock = { _, _, error in
//                    if let error = error {
//                        print("Erreur lors de la suppression des données CloudKit : \(error.localizedDescription)")
//                    } else {
//                        print("Données CloudKit supprimées avec succès.")
//                    }
//                }
//    
//                database.add(deleteOperation)
//            }
//    
//            database.add(fetchAllRecords)
//        }
}//END struct

//MARK: - Preview
struct SettingsHomeView_Previews: PreviewProvider {
    
    @StateObject static var csManager: ColorSchemeManager = ColorSchemeManager()
    @State static var previewUpdate: Bool = false
    
    static var previews: some View {
        SettingsHomeView(account: previewAccount1(), update: $previewUpdate)
            .environmentObject(csManager)
    }
}

