//
//  PageControllerView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
// Localizations 30/09/2023

import SwiftUI
import CloudKit
import CoreData
import LocalAuthentication

struct PageControllerView: View {
    
    //Custom type
    let persistenceController = PersistenceController.shared
    @State private var account: Account? = nil
    @StateObject private var icloudManager: ICloudManager = ICloudManager()
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    @ObservedObject var filter: Filter = sharedFilter
    @ObservedObject var viewModelCustomBar = CustomTabBarViewModel.shared
    @ObservedObject var viewModelAddTransaction = AddTransactionViewModel.shared
    
    //CoreData
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.position, ascending: true)])
    private var accounts: FetchedResults<Account>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Card.position, ascending: true)])
    private var cards: FetchedResults<Card>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \SavingPlan.position, ascending: true)])
    private var savingPlans: FetchedResults<SavingPlan>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Subcategory.title, ascending: true)])
    private var subCategories: FetchedResults<Subcategory>
    
    // Capture NOTIFICATION changes
    var didRemoteChange = NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange).receive(on: RunLoop.main)
    
    //Environnements
    @EnvironmentObject var csManager: ColorSchemeManager
    @EnvironmentObject private var store: Store
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) private var colorScheme
    
    //State or Binding String
    
    //State or Binding Int, Float and Double
    @State private var selectedTab: Int = 0
    @State private var offsetY: CGFloat = 0
    @State private var scale: CGFloat = 0
    @State private var offsetYMenu: CGFloat = 0
    @State private var offsetYFilterView: CGFloat = -UIScreen.main.bounds.height
    
    //State or Binding Bool
    @State private var update: Bool = false
    
    @State private var showAlertAccount: Bool = false
    @State private var showOnboarding: Bool = false
    @State private var isUnlocked: Bool = false
    @State private var launchScreenEnd: Bool = false
    
    @State private var showAlertPaywall: Bool = false
    @State private var showPaywall: Bool = false
    
    @State private var showUpdateView: Bool = false
    
    //Enum
    
    //Computed var
    private var arrayOfSubCategories: [Subcategory] { return Array(subCategories) }
    
    //MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            NavigationStack {
                VStack {
                    if !launchScreenEnd { LaunchScreen(launchScreenEnd: $launchScreenEnd) }
                    if !isUnlocked && icloudManager.icloudDataStatus == .found {
                        VStack {
                            Spacer()
                            ProgressView()
                            Text(NSLocalizedString("alert_recover_data", comment: ""))
                                .multilineTextAlignment(.center)
                                .font(.mediumText16())
                            Spacer()
                        }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                do {
                                    let context = persistenceController.container.viewContext
                                    let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
                                    
                                    do {
                                        let results = try context.fetch(fetchRequest)
                                        if let accoutRetrieve = results.first {
                                            account = accoutRetrieve
                                            isUnlocked = true
                                        }
                                        print("🔥 results : \(results.count)")
                                    } catch {
                                        print("⚠️ Error for : \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                    } else if isUnlocked {
                        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                            if account != nil {
                                VStack {
                                    switch selectedTab {
                                    case 0:
                                        HomeScreenView(
                                            account: $account,
                                            update: $update
                                        )
                                        .environmentObject(csManager)
                                        .environmentObject(store)
                                    case 1:
                                        AnalyticsHomeView(
                                            account: $account,
                                            update: $update
                                        )
                                        .environmentObject(csManager)
                                        .environmentObject(store)
                                    case 3:
                                        AccountHomeView(
                                            account: $account,
                                            update: $update
                                        )
                                        .environmentObject(csManager)
                                        .environmentObject(store)
                                    case 4:
                                        CategoriesHomeView(
                                            update: $update
                                        )
                                        .environmentObject(csManager)
                                        .environmentObject(store)
                                    default:
                                        EmptyView() //Can't arrived
                                    }
                                }
                                .blur(radius: viewModelCustomBar.showMenu ? 3 : 0)
                                .disabled(viewModelCustomBar.showMenu)
                                .onTapGesture {
                                    withAnimation { viewModelCustomBar.showMenu = false }
                                }
                            } else {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        VStack(spacing: 20) {
                                            Image("NoAccount\(themeSelected)")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .shadow(radius: 4, y: 4)
                                                .frame(width: isIPad ? (orientation.isLandscape ? UIScreen.main.bounds.width / 3 : UIScreen.main.bounds.width / 2) : UIScreen.main.bounds.width / 1.5)
                                            
                                            Text(NSLocalizedString("home_screen_no_account", comment: ""))
                                                .font(.semiBoldText16())
                                                .multilineTextAlignment(.center)
                                        }
                                        .offset(y: -50)
                                        Spacer()
                                    }
                                    
                                    Spacer()
                                }
                            }
                            
                            TabbarView(account: $account,
                                       selectedTab: $selectedTab,
                                       offsetYMenu: $offsetYMenu,
                                       update: $update
                            )
                        }
                        .onChange(of: viewModelCustomBar.showMenu, perform: { newValue in //Keep for nice animation
                            withAnimation {
                                if newValue {
                                    if accounts.count != 0 {
                                        offsetYMenu = -180
                                    } else { offsetYMenu = -80 }
                                } else { offsetYMenu = 0 }
                            }
                        })
                        .sheet(isPresented: $viewModelCustomBar.showAddAccount, onDismiss: {
                            selectedTab = 3;
                            withAnimation { update.toggle() }
                        }, content: {  AddAccountView(account: $account) })
                        
                        .sheet(isPresented: $viewModelCustomBar.showAddSavingPlan, onDismiss: {
                            withAnimation { update.toggle() }
                        }, content: { AddSavingPlanView(account: $account) })
                        .sheet(isPresented: $viewModelCustomBar.showRecoverTransaction, content: {
                            RecoverTransactionView(account: $account)
                        })
                        .sheet(isPresented: $viewModelCustomBar.showAddAutomation, onDismiss: {
                            withAnimation {
                                if let account { AutomationManager().activateScheduledAutomations(automations: account.automations) }
                                update.toggle()
                            }
                        }, content: { AddAutomationsView(account: $account) })
                        .sheet(isPresented: $viewModelCustomBar.showScanTransaction, onDismiss: { viewModelCustomBar.showAddTransaction = true }) {
                            viewModelAddTransaction.makeScannerView()
                        }
                        .sheet(isPresented: $viewModelCustomBar.showAddTransaction, onDismiss: {
                            withAnimation {
                                viewModelAddTransaction.resetData()
                                update.toggle()
                            }
                        }, content: { AddTransactionView(account: $account) })
                        .sheet(isPresented: $showOnboarding, onDismiss: {
                            withAnimation {
                                account = accounts[0]
                                update.toggle()
                            }
                        }, content: { OnboardingView(account: $account).interactiveDismissDisabled() })
                        .edgesIgnoringSafeArea(.bottom)
                        .ignoresSafeArea(.keyboard) //Pour pas que la tap bar monte quand un clavier apparait
                    }
                }
                .padding(update ? 0 : 0)
                .padding(isUnlocked ? 0 : 0)
                .onAppear {
                    if accounts.count != 0 { account = Array(accounts)[0] }
                }
                .onRotate { _ in
                    update.toggle()
                }
                .onChange(of: launchScreenEnd, perform: { newValue in
                    if newValue && (icloudManager.icloudDataStatus == .none || icloudManager.icloudDataStatus == .error) {
                        if !UserDefaults.standard.bool(forKey: "alreadyOpen") && accounts.count == 0 { //First Launch of CashFlow
                            showOnboarding.toggle()
                            firstLaunchOfCashFlow()
                        } else if !UserDefaults.standard.bool(forKey: "alreadyOpen") && accounts.count != 0 {
                            firstLaunchOfCashFlow()
                        }
                        if !UserDefaults.standard.bool(forKey: "appIsOpen") && UserDefaults.standard.bool(forKey: "alreadyOpen") {
                            if userDefaultsManager.isFaceIDEnable {
                                authenticate()
                            } else {
                                withAnimation { isUnlocked = true }
                                UserDefaults.standard.set(true, forKey: "appIsOpen")
                            }
                        } else {
                            withAnimation { isUnlocked = true }
                            UserDefaults.standard.set(true, forKey: "appIsOpen")
                        }
                    }
                })
                .onChange(of: scenePhase) { newValue in
                    if newValue != .active {
                        UserDefaults.standard.set(false, forKey: "appIsOpen")
                    }
                }
            } // END NavigationStack

            FilterView(showAlertPaywall: $showAlertPaywall, update: $update)
                .offset(y: offsetYFilterView)
                .edgesIgnoringSafeArea(.top)
                .onChange(of: filter.showMenu) { newValue in
                    withAnimation {
                        if newValue { offsetYFilterView = 0 } else { offsetYFilterView = -UIScreen.main.bounds.height }
                        update.toggle()
                    }
                }
            
        } //END ZStack
        .onReceive(self.didRemoteChange){ _ in
            withAnimation { update.toggle() }
        }
        .onAppear {
            store.loadStoredPurchases()
            if !UserDefaults.standard.bool(forKey: "alreadyOpen") {
                icloudManager.checkDataInCloudKit()
            }
            if !udV1_1 {
                showUpdateView.toggle()
                UserDefaults.standard.setValue(true, forKey: "udV1_1")
            }
        }
        .alert(NSLocalizedString("alert_cashflow_pro_title", comment: ""), isPresented: $showAlertPaywall, actions: {
            Button(action: { return }, label: { Text(NSLocalizedString("word_cancel", comment: "")) })
            Button(action: { showPaywall.toggle() }, label: { Text(NSLocalizedString("alert_cashflow_pro_see", comment: "")) })
        }, message: {
            Text(NSLocalizedString("alert_cashflow_pro_desc", comment: ""))
        })
        .sheet(isPresented: $showPaywall) { PaywallScreenView() }
        .sheet(isPresented: $showUpdateView) { NewUpdateView() }
        .onChange(of: icloudManager.icloudDataStatus) { newValue in
            if newValue == .found {
                DispatchQueue.main.async {
                    if !UserDefaults.standard.bool(forKey: "alreadyOpen") {
                        showOnboarding = false
                        isUnlocked = false
                        firstLaunchOfCashFlow()
                        UserDefaults.standard.set(true, forKey: "alreadyOpen")
                    }
                }
            }
        }
    }//END body
    
    //MARK: Fonctions
    
    //-------------------- firstLaunchOfCashFlow() ----------------------
    // Description : Setup user default at the first launch
    // Parameter :
    // Output :
    // Extra :
    //-----------------------------------------------------------
    func firstLaunchOfCashFlow() {
        userDefaultsManager.hapticFeedback = true
        userDefaultsManager.blockExpensesIfCardLimitExceeds = true
        userDefaultsManager.isSavingPlansDisplayedHomeScreen = true
        userDefaultsManager.isAutomationsDisplayedHomeScreen = true
        userDefaultsManager.isRecentTransactionsDisplayedHomeScreen = true
        userDefaultsManager.isIncomeFromTransactionsChart = true
        userDefaultsManager.isExpenseTransactionsChart = true
        userDefaultsManager.isIncomeFromTransactionsWithAutomationChart = true
        userDefaultsManager.isExpenseTransactionsWithAutomationChart = true
        userDefaultsManager.blockExpensesIfBudgetAmountExceeds = true
        
        userDefaultsManager.numberOfSavingPlansDisplayedInHomeScreen = 4
        userDefaultsManager.numberOfAutomationsDisplayedInHomeScreen = 4
        
        userDefaultsManager.cardLimitPercentage = 80
        userDefaultsManager.budgetPercentage = 80
        
        var components = DateComponents()
        components.hour = 10
        components.minute = 0
        
        let dateDefaultNotificationHour = Calendar.current.date(from: components)
        
        if let dateDefaultNotificationHour {
            userDefaultsManager.notificationTimeHour = dateDefaultNotificationHour
        }
        
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            // it's possible, so go ahead and use it
            let reason = NSLocalizedString("alert_request_biometric", comment: "")
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    isUnlocked = true
                    UserDefaults.standard.set(true, forKey: "appIsOpen")
                } else {
                    isUnlocked = false
                    UserDefaults.standard.set(false, forKey: "appIsOpen")
                }
            }
        } else {
            // no biometrics
        }
    }
    
}//END struct

//MARK: - Preview
struct PageControllerView_Previews: PreviewProvider {
    static var previews: some View {
        PageControllerView()
    }
}
