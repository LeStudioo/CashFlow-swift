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

    // New Repository
    @EnvironmentObject private var accountRepository: AccountRepository
    
    // Old Reposiyory
    @EnvironmentObject private var accountRepo: AccountRepositoryOld
    
    
    // Custom
    @StateObject private var icloudManager: ICloudManager = ICloudManager()
    @StateObject private var pageControllerVM: PageControllerViewModel = PageControllerViewModel()
    @ObservedObject var viewModelCustomBar = CustomTabBarViewModel.shared
    @ObservedObject var viewModelAddTransaction = CreateTransactionViewModel.shared
        
    // Environement
    @Environment(\.scenePhase) private var scenePhase
    
    // EnvironmentObject
    @EnvironmentObject var csManager: ColorSchemeManager
    @EnvironmentObject private var store: PurchasesManager
    
    // Preferences
    @Preference(\.isFaceIDEnabled) private var isFaceIDEnabled
    @Preference(\.alreadyOpen) private var alreadyOpen
    
    // Number variables
    @State private var selectedTab: Int = 0
    
    // MARK: - body
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                if !pageControllerVM.launchScreenEnd { LaunchScreen(launchScreenEnd: $pageControllerVM.launchScreenEnd) }
                if pageControllerVM.isUnlocked {
                    ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                        if accountRepository.mainAccount != nil {
                            Group {
                                switch selectedTab {
                                case 0: HomeView()
                                case 1: AnalyticsHomeView()
                                case 3: AccountDashboardView()
                                case 4: CategoriesHomeView()
                                default: EmptyView() //Can't arrived
                                }
                            }
                            .blur(radius: viewModelCustomBar.showMenu ? 3 : 0)
                            .disabled(viewModelCustomBar.showMenu)
                            .onTapGesture { viewModelCustomBar.showMenu = false }
                        } else {
                            CustomEmptyView(
                                imageName: "NoAccount\(ThemeManager.theme.nameNotLocalized.capitalized)",
                                description: "home_screen_no_account".localized
                            )
                        }
                        
                        TabbarView(selectedTab: $selectedTab)
                    }
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
        } //END ZStack
        .alert("alert_cashflow_pro_title".localized, isPresented: $pageControllerVM.showAlertPaywall, actions: {
            Button(action: { return }, label: { Text("word_cancel".localized) })
            Button(action: { pageControllerVM.showPaywall.toggle() }, label: { Text("alert_cashflow_pro_see".localized) })
        }, message: {
            Text("alert_cashflow_pro_desc".localized)
        })
        .sheet(isPresented: $pageControllerVM.showPaywall) { PaywallScreenView() }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    PageControllerView()
}
