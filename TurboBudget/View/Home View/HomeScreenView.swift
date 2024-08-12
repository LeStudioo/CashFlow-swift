//
//  HomeScreenView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
// Localizations 01/10/2023
// Refactor 18/02/2024

import SwiftUI
import CoreData

struct HomeScreenView: View {
    
    // Repo
    @ObservedObject var account: Account
    
    // EnvironmentObject
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject var csManager: ColorSchemeManager
    @EnvironmentObject var store: Store
    
    // Preferences
    @Preference(\.isSavingPlansDisplayedHomeScreen) private var isSavingPlansDisplayedHomeScreen
    @Preference(\.isAutomationsDisplayedHomeScreen) private var isAutomationsDisplayedHomeScreen
    @Preference(\.isRecentTransactionsDisplayedHomeScreen) private var isRecentTransactionsDisplayedHomeScreen
    @Preference(\.numberOfRecentTransactionDisplayedInHomeScreen) private var numberOfRecentTransactionDisplayedInHomeScreen
    @Preference(\.isStepsEnbaledForAllSavingsPlans) private var isStepsEnbaledForAllSavingsPlans
    
    // Number variables
    @State private var accountBalanceInt: Int = 0
    @State private var accountBalanceDouble: Double = 0.0
    
    // Boolean variables
    @State private var busy: Bool = false
    @State private var showPaywall: Bool = false
    
    // MARK: - body
    var body: some View {
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
                        .foregroundStyle(Color.customGray)
                        .font(Font.mediumText16())
                }
                
                Spacer()
                
                if !store.isLifetimeActive {
                    Button(action: { showPaywall.toggle() }, label: {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(.primary500)
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
                        .foregroundStyle(Color(uiColor: .label))
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
                                        .foregroundStyle(Color.customGray)
                                        .font(.semiBoldCustom(size: 22))
                                    
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .foregroundStyle(HelperManager().getAppTheme().color)
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
                                        TransactionRow(transaction: transaction)
                                    })
                                }
                            } else {
                                VStack(spacing: 20) {
                                    Image("NoTransaction\(themeSelected)")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .shadow(radius: 4, y: 4)
                                        .frame(width: isIPad
                                               ? UIScreen.main.bounds.width / 3
                                               : UIScreen.main.bounds.width / 1.5
                                        )
                                    
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
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .onAppear {
            AutomationManager().activateScheduledAutomations(automations: account.automations)
            SavingPlanManager().archiveCompletedSavingPlansAutomatically(account: account)
            
            accountBalanceInt = account.balance.splitDecimal().0
            accountBalanceDouble = account.balance.splitDecimal().1
            if accountBalanceDouble.rounded(places: 2) == 1 { accountBalanceDouble = 0 }
            
            //Notification Counter
            UserDefaults.standard.set(0, forKey: "counterOfNotif")
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    HomeScreenView(account: .preview)
}
