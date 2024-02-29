//
//  HomeScreenView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
// Localizations 01/10/2023
// Refactor 18/02/2024

import SwiftUI
import Charts
import CoreData

struct HomeScreenView: View {
    
    // Builder
    var router: NavigationManager
    @ObservedObject var account: Account
    
    // Custom
    @ObservedObject var predefinedObjectManager = PredefinedObjectManager.shared
    
    // CoreData
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.position, ascending: true)])
    private var accounts: FetchedResults<Account>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.amount, ascending: true)])
    private var transactions: FetchedResults<Transaction>
    
    // Environement
    @Environment(\.colorScheme) private var colorScheme
    
    // EnvironmentObject
    @EnvironmentObject var csManager: ColorSchemeManager
    @EnvironmentObject var store: Store
    
    // Preferences
    @Preference(\.isSavingPlansDisplayedHomeScreen) private var isSavingPlansDisplayedHomeScreen
    @Preference(\.isAutomationsDisplayedHomeScreen) private var isAutomationsDisplayedHomeScreen
    @Preference(\.isRecentTransactionsDisplayedHomeScreen) private var isRecentTransactionsDisplayedHomeScreen
    @Preference(\.numberOfRecentTransactionDisplayedInHomeScreen) private var numberOfRecentTransactionDisplayedInHomeScreen
    @Preference(\.isStepsEnbaledForAllSavingsPlans) private var isStepsEnbaledForAllSavingsPlans
    
    // String variables
    @State private var searchText: String = ""
    
    // Number variables
    @State private var accountBalanceInt: Int = 0
    @State private var accountBalanceDouble: Double = 0.0
    
    // Boolean variables
    @State private var busy: Bool = false
    @State private var showPaywall: Bool = false
    
    // State or Binding Orientation
    @State private var orientation = UIDeviceOrientation.unknown
    
    // MARK: - body
    var body: some View {
        NavStack(router: router) {
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            if accountBalanceDouble == 0 { Text(accountBalanceInt.currency) } else {
                                Text(currencySymbol)
                                HStack(spacing: -1) {
                                    Text(accountBalanceInt.formatted(style: .decimal))
                                    if accountBalanceDouble != 1 {
                                        Text(String(format: "%.2f", accountBalanceDouble).replacingOccurrences(of: "0", with: "").replacingOccurrences(of: "-", with: ""))
                                    }
                                }
                            }
                        }
                        .titleAdjustSize()
                        
                        Text("home_screen_available_balance".localized)
                            .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                            .font(Font.mediumText16())
                    }
                    
                    Spacer()
                    
                    if !store.isLifetimeActive {
                        Button(action: { showPaywall.toggle() }, label: {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.primary500)
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                        })
                        .sheet(isPresented: $showPaywall) {
                            PaywallScreenView()
                                .environmentObject(store)
                        }
                    }
                    
                    Button(action: {
                        router.pushSettings(account: account)
                    }, label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.colorLabel)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                    })
                }
                .padding([.horizontal, .bottom])
                // End Header
                
                ScrollView {
                    VStack {
                        CarouselOfChartsView(account: account)
                        
                        // Saving Plans
                        if isSavingPlansDisplayedHomeScreen {
                            SavingPlansForHomeScreen(
                                router: router,
                                account: account
                            )
                        }
                        // End Saving Plans
                        
                        // Automations
                        if isAutomationsDisplayedHomeScreen {
                            AutomationsForHomeScreen(
                                router: router,
                                account: account
                            )
                        }
                        // End Automations
                        
                        // Recent Transactions
                        if isRecentTransactionsDisplayedHomeScreen {
                            VStack {
                                Button(action: { 
                                    router.pushAllTransactions(account: account)
                                }, label: {
                                    HStack {
                                        Text("word_recent_transactions".localized)
                                            .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                                            .font(.semiBoldCustom(size: 22))
                                        
                                        Spacer()
                                        Image(systemName: "arrow.right")
                                            .foregroundColor(HelperManager().getAppTheme().color)
                                            .font(.system(size: 20, weight: .medium, design: .rounded))
                                    }
                                })
                                .padding(.horizontal)
                                .padding(.top)
                                
                                if account.transactions.count != 0 {
                                    ForEach(account.transactions.prefix(numberOfRecentTransactionDisplayedInHomeScreen)) { transaction in
                                        Button(action: {
                                            router.pushTransactionDetail(transaction: transaction)
                                        }, label: {
                                            CellTransactionView(transaction: transaction)
                                        })
                                    }
                                } else {
                                    VStack(spacing: 20) {
                                        Image("NoTransaction\(themeSelected)")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .shadow(radius: 4, y: 4)
                                            .frame(width: isIPad ? (orientation.isLandscape ? UIScreen.main.bounds.width / 3 : UIScreen.main.bounds.width / 2) : UIScreen.main.bounds.width / 1.5)
                                        
                                        Text("home_screen_no_transaction".localized)
                                            .font(.semiBoldText16())
                                            .multilineTextAlignment(.center)
                                    }
                                    .offset(y: -20)
                                }
                                Rectangle()
                                    .frame(height: 100)
                                    .opacity(0)
                                
                                Spacer()
                            }
                        }
                        // End Recent Transactions
                    }
                    Spacer()
                } // End ScrollView
                .scrollIndicators(.hidden)
            } // End VStack
//            .onRotate { newOrientation in
//                orientation = newOrientation
//            }
            .onChange(of: isStepsEnbaledForAllSavingsPlans) { newValue in // TODO: Ne devrait pas etre ici ??
                for savingPlan in account.savingPlans {
                    savingPlan.isStepEnable = newValue
                    persistenceController.saveContext()
                }
            }
            .onChange(of: account.balance, perform: { _ in
                Timer.animateNumber(number: $accountBalanceInt, busy: $busy, start: accountBalanceInt, end: Int(account.balance))
                withAnimation {
                    accountBalanceDouble = account.balance.splitDecimal().1
                    if accountBalanceDouble.rounded(places: 2) == 1 { accountBalanceDouble = 0 }
                }
            })
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
            .onAppear {
                getOrientationOnAppear()
                
                AutomationManager().activateScheduledAutomations(automations: account.automations)
                SavingPlanManager().archiveCompletedSavingPlansAutomatically(account: account)
                
                accountBalanceInt = account.balance.splitDecimal().0
                accountBalanceDouble = account.balance.splitDecimal().1
                if accountBalanceDouble.rounded(places: 2) == 1 { accountBalanceDouble = 0 }
                
                //Notification Counter
                UserDefaults.standard.set(0, forKey: "counterOfNotif")
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
        } // End NavStack
    } // End body
    
    // MARK: Fonctions
    func getOrientationOnAppear() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            orientation = UIDeviceOrientation.landscapeLeft
        } else { orientation = UIDeviceOrientation.portrait }
    }

} // End struct

// MARK: - Preview
#Preview {
    HomeScreenView(
        router: .init(isPresented: .constant(.home(account: Account.preview))),
        account: Account.preview
    )
}
