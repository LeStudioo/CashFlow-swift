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

struct PageControllerView: View {
    
    // Environment
    @EnvironmentObject private var router: NavigationManager
    
    // Repo
    @EnvironmentObject private var accountRepo: AccountRepository
    
    // Custom
    @StateObject private var icloudManager: ICloudManager = ICloudManager()
    @StateObject private var pageControllerVM: PageControllerViewModel = PageControllerViewModel()
    @ObservedObject var filter: Filter = sharedFilter
    @ObservedObject var viewModelCustomBar = CustomTabBarViewModel.shared
    @ObservedObject var viewModelAddTransaction = AddTransactionViewModel.shared
    
    // CoreData
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \SavingPlan.position, ascending: true)])
    private var savingPlans: FetchedResults<SavingPlan>
    
    // Capture NOTIFICATION changes
    var didRemoteChange = NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange).receive(on: RunLoop.main)
    
    // Environement
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    // EnvironmentObject
    @EnvironmentObject var csManager: ColorSchemeManager
    @EnvironmentObject private var store: Store
    
    // Preferences
    @Preference(\.isFaceIDEnabled) private var isFaceIDEnabled
    @Preference(\.alreadyOpen) private var alreadyOpen
    
    // Number variables
    @State private var selectedTab: Int = 0
    @State private var offsetY: CGFloat = 0
    @State private var offsetYMenu: CGFloat = 0
    @State private var offsetYFilterView: CGFloat = -UIScreen.main.bounds.height
    
    // Boolean variables
    @State private var update: Bool = false
    
    // MARK: - body
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                if !pageControllerVM.launchScreenEnd { LaunchScreen(launchScreenEnd: $pageControllerVM.launchScreenEnd) }
                if !pageControllerVM.isUnlocked && icloudManager.icloudDataStatus == .found {
                    VStack {
                        Spacer()
                        ProgressView()
                        Text("alert_recover_data".localized)
                            .multilineTextAlignment(.center)
                            .font(.mediumText16())
                        Spacer()
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                            let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
                            
                            do {
                                let results = try viewContext.fetch(fetchRequest)
                                if let accoutRetrieve = results.first {
                                    accountRepo.mainAccount = accoutRetrieve
                                    pageControllerVM.isUnlocked = true
                                }
                                print("🔥 results : \(results.count)")
                            } catch {
                                print("⚠️ Error for : \(error.localizedDescription)")
                            }
                        }
                    }
                } else if pageControllerVM.isUnlocked {
                    ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                        if let account = accountRepo.mainAccount {
                            Group {
                                switch selectedTab {
                                case 0: HomeScreenView(account: account)
                                case 1: AnalyticsHomeView(account: account)
                                case 3: AccountDashboardView(account: account)
                                case 4: CategoriesHomeView()
                                default: EmptyView() //Can't arrived
                                }
                            }
                            .environmentObject(csManager)
                            .environmentObject(store)
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
                                            .frame(width: isIPad
                                                   ? UIScreen.main.bounds.width / 3
                                                   : UIScreen.main.bounds.width / 1.5)
                                        
                                        Text("home_screen_no_account".localized)
                                            .font(.semiBoldText16())
                                            .multilineTextAlignment(.center)
                                    }
                                    .offset(y: -50)
                                    Spacer()
                                }
                                
                                Spacer()
                            }
                        }
                        
                        TabbarView(
                            router: router,
                            selectedTab: $selectedTab,
                            offsetYMenu: $offsetYMenu
                        )
                    }
                    .onChange(of: viewModelCustomBar.showMenu, perform: { newValue in //Keep for nice animation
                        withAnimation {
                            if newValue {
                                if accountRepo.mainAccount != nil {
                                    offsetYMenu = -180
                                } else { offsetYMenu = -80 }
                            } else { offsetYMenu = 0 }
                        }
                    })
                    .sheet(isPresented: $viewModelCustomBar.showAddAccount, onDismiss: {
                        selectedTab = 3;
                        withAnimation { update.toggle() }
                    }, content: {  CreateAccountView() })
                    .sheet(isPresented: $viewModelCustomBar.showScanTransaction) {
                        viewModelAddTransaction.makeScannerView()
                    }
                    .sheet(isPresented: $pageControllerVM.showOnboarding, onDismiss: {
                        router.presentPaywall()
                    }, content: { OnboardingView().interactiveDismissDisabled() })
                    .edgesIgnoringSafeArea(.bottom)
                    .ignoresSafeArea(.keyboard)
                } // End if unlocked
            }
            .padding(update ? 0 : 0)
            .padding(pageControllerVM.isUnlocked ? 0 : 0)
            .onChange(of: pageControllerVM.launchScreenEnd, perform: { newValue in
                // LaunchScreen ended and no data in iCloud
                if newValue && (icloudManager.icloudDataStatus == .none || icloudManager.icloudDataStatus == .error) {
                    // First open + no data in iCloud
                    if !UserDefaults.standard.bool(forKey: "alreadyOpen") && accountRepo.mainAccount == nil {
                        pageControllerVM.showOnboarding.toggle()
                        // First open + no iCloud
                    }
                    // Already open + app close
                    if !UserDefaults.standard.bool(forKey: "appIsOpen") && UserDefaults.standard.bool(forKey: "alreadyOpen") {
                        if isFaceIDEnabled {
                            pageControllerVM.authenticate()
                        } else {
                            withAnimation { pageControllerVM.isUnlocked = true }
                            UserDefaults.standard.set(true, forKey: "appIsOpen")
                        }
                    } else {
                        withAnimation { pageControllerVM.isUnlocked = true }
                        UserDefaults.standard.set(true, forKey: "appIsOpen")
                    }
                }
            })
            .onChange(of: scenePhase) { newValue in
                if newValue != .active {
                    UserDefaults.standard.set(false, forKey: "appIsOpen")
                }
            }
            
            //            FilterView(showAlertPaywall: $pageControllerVM.showAlertPaywall, update: $update)
            //                .offset(y: offsetYFilterView)
            //                .edgesIgnoringSafeArea(.top)
            //                .onChange(of: filter.showMenu) { newValue in
            //                    withAnimation {
            //                        if newValue { offsetYFilterView = 0 } else { offsetYFilterView = -UIScreen.main.bounds.height }
            //                        update.toggle()
            //                    }
            //                }
            
        } //END ZStack
        .onReceive(self.didRemoteChange){ _ in
            withAnimation { update.toggle() }
        }
        .onAppear {
            store.loadStoredPurchases()
            if !alreadyOpen {
                icloudManager.checkDataInCloudKit { success in
                    icloudManager.fetchTransactionFromCloudKit { records, error in
                        if let records {
                            icloudManager.saveRecordsToCoreData(records: records)
                        } else {
                            print("🔥 RECORDS FAIL")
                        }
                    }
                    if success {
                        pageControllerVM.isUnlocked = true
                    }
                }
            }
        }
        .alert("alert_cashflow_pro_title".localized, isPresented: $pageControllerVM.showAlertPaywall, actions: {
            Button(action: { return }, label: { Text("word_cancel".localized) })
            Button(action: { pageControllerVM.showPaywall.toggle() }, label: { Text("alert_cashflow_pro_see".localized) })
        }, message: {
            Text("alert_cashflow_pro_desc".localized)
        })
        .sheet(isPresented: $pageControllerVM.showPaywall) { PaywallScreenView() }
        .onChange(of: icloudManager.icloudDataStatus) { newValue in
            if newValue == .found {
                DispatchQueue.main.async {
                    if !alreadyOpen {
                        pageControllerVM.showOnboarding = false
                        pageControllerVM.isUnlocked = true
                        alreadyOpen = true
                    }
                }
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    PageControllerView()
}
