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
    @EnvironmentObject private var appManager: AppManager
    @EnvironmentObject private var router: NavigationManager
    
    // New Repository
    @EnvironmentObject private var accountRepository: AccountStore
    
    // Old Reposiyory
    @EnvironmentObject private var accountRepo: AccountRepositoryOld
    
    // Custom
    @StateObject private var icloudManager: ICloudManager = ICloudManager()
    @StateObject private var pageControllerVM: PageControllerViewModel = PageControllerViewModel()
    @ObservedObject var viewModelCustomBar = CustomTabBarViewModel.shared
    
    // Environement
    @Environment(\.scenePhase) private var scenePhase
    
    // EnvironmentObject
    @EnvironmentObject var csManager: ColorSchemeManager
    @EnvironmentObject private var store: PurchasesManager
    
    // Preferences
    @StateObject private var preferencesSecurity: PreferencesSecurity = .shared
    @StateObject private var preferencesGeneral: PreferencesGeneral = .shared
    
    // MARK: - body
    var body: some View {
        VStack {
            if !pageControllerVM.launchScreenEnd { LaunchScreen(launchScreenEnd: $pageControllerVM.launchScreenEnd) }
            if pageControllerVM.isUnlocked {
                ZStack(alignment: .bottom) {
                    if accountRepository.selectedAccount != nil {
                        Group {
                            switch appManager.selectedTab {
                            case 0: HomeView()
                            case 1: AnalyticsHomeView()
                            case 3: AccountDashboardView()
                            case 4: CategoryHomeView()
                            default: EmptyView() // Can't arrived
                            }
                        }
                    } else {
                        CustomEmptyView(
                            type: .empty(.account),
                            isDisplayed: true
                        )
                    }
                    
                    CustomTabBar()
                }
                .blur(radius: viewModelCustomBar.showMenu ? 12 : 0)
                .overlay {
                    if viewModelCustomBar.showMenu {
                        CreationSelectionView()
                    }
                }
                .sheet(isPresented: $pageControllerVM.showOnboarding) {
                    OnboardingView()
                }
                .edgesIgnoringSafeArea(.bottom)
                .ignoresSafeArea(.keyboard)
            } // End if unlocked
        }
        .padding(pageControllerVM.isUnlocked ? 0 : 0)
        .onChange(of: pageControllerVM.launchScreenEnd, perform: { newValue in
            if (preferencesGeneral.isAlreadyOpen && !preferencesGeneral.isWhatsNewSeen) {
                router.presentWhatsNew()
            }
            
            if accountRepository.mainAccount != nil && !preferencesGeneral.isAlreadyOpen {
                pageControllerVM.showOnboarding = false
                preferencesGeneral.isAlreadyOpen = true
            } else if !preferencesGeneral.isAlreadyOpen {
                pageControllerVM.showOnboarding = true
            }
            
            // LaunchScreen ended and no data in iCloud
            if newValue && (icloudManager.icloudDataStatus == .none || icloudManager.icloudDataStatus == .error) {
                // Already open + app close
                if !UserDefaults.standard.bool(forKey: "appIsOpen") && preferencesGeneral.isAlreadyOpen {
                    if preferencesSecurity.isBiometricEnabled {
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
    } // body
} // struct

// MARK: - Preview
#Preview {
    PageControllerView()
}
