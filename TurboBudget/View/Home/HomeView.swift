//
//  HomeView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
// Localizations 01/10/2023
// Refactor 18/02/2024

import SwiftUI
import CoreData

struct HomeView: View {
    
//    @EnvironmentObject private var accountRepository: AccountRepository
    @EnvironmentObject private var transactionRepository: TransactionRepository
    
    // EnvironmentObject
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject var csManager: ColorSchemeManager
    @EnvironmentObject var store: PurchasesManager
        
    // Preferences
    @Preference(\.isRecentTransactionsDisplayedHomeScreen) private var isRecentTransactionsDisplayedHomeScreen
    @Preference(\.numberOfRecentTransactionDisplayedInHomeScreen) private var numberOfRecentTransactionDisplayedInHomeScreen
    @Preference(\.isStepsEnbaledForAllSavingsPlans) private var isStepsEnbaledForAllSavingsPlans
    
    // MARK: - body
    var body: some View {
        VStack(spacing: 16) {
            HomeHeader()
                .padding(.horizontal)
            
            ScrollView {
                CarouselOfChartsView()
                
                SavingPlansForHomeScreen()
                
                AutomationsForHomeScreen()
                
                // Recent Transactions
                if isRecentTransactionsDisplayedHomeScreen {
                    VStack {
                        NavigationButton(push: router.pushAllTransactions()) {
                            HStack {
                                Text("word_recent_transactions".localized)
                                    .foregroundStyle(Color.customGray)
                                    .font(.semiBoldCustom(size: 22))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Image(systemName: "arrow.right")
                                    .foregroundStyle(ThemeManager.theme.color)
                                    .font(.system(size: 20, weight: .medium, design: .rounded))
                            }
                        }
                        .padding([.horizontal, .top])
                        
                        if transactionRepository.transactions.count != 0 {
                            ForEach(transactionRepository.transactions.prefix(numberOfRecentTransactionDisplayedInHomeScreen)) { transaction in
                                NavigationButton(push: router.pushTransactionDetail(transaction: transaction)) {
                                    TransactionRow(transaction: transaction)
                                }
                            }
                        } else {
                            VStack(spacing: 20) {
                                Image("NoTransaction\(ThemeManager.theme.nameNotLocalized.capitalized)")
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
                } // End Recent Transactions
            } // ScrollView
            .scrollIndicators(.hidden)
        } // End VStack
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .onAppear {
//            AutomationManager().activateScheduledAutomations(automations: account.automations)
//            SavingPlanManager().archiveCompletedSavingPlansAutomatically(account: account)
            
            //Notification Counter
            UserDefaults.standard.set(0, forKey: "counterOfNotif")
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    HomeView()
}
