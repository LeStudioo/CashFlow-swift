//
//  HomeScreenView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
// Localizations 01/10/2023

import SwiftUI
import Charts
import CoreData
//import StoreKit // For requestReview

struct HomeScreenView: View {
    
    //Custom type
    @Binding var account: Account?
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    @ObservedObject var predefinedObjectManager = PredefinedObjectManager.shared
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.position, ascending: true)])
    private var accounts: FetchedResults<Account>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.amount, ascending: true)])
    private var transactions: FetchedResults<Transaction>
    
    //Environnements
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var csManager: ColorSchemeManager
    @EnvironmentObject var store: Store
    
    //State or Binding String
    @State private var searchText: String = ""
    
    //State or Binding Int, Float and Double
    @State private var accountBalanceInt: Int = 0
    @State private var accountBalanceDouble: Double = 0.0
    
    //State or Binding Bool
    @State private var busy: Bool = false
    @State private var showPaywall: Bool = false
    
    //State or Binding Orientation
    @State private var orientation = UIDeviceOrientation.unknown
    
    //Enum
    
    //Computed var
    
    //Binding update
    @Binding var update: Bool
    
    //MARK: - Body
    var body: some View {
        if let account {
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
                        
                        Text(NSLocalizedString("home_screen_available_balance", comment: ""))
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
                    
                    NavigationLink(destination: {
                        SettingsHomeView(account: account, update: $update)
                            .environmentObject(csManager)
                    }, label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.colorLabel)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                    })
                }
                .padding([.horizontal, .bottom])
                // End Header
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        CarouselOfChartsView(account: $account, update: $update)
                        
                        // Saving Plans
                        if userDefaultsManager.isSavingPlansDisplayedHomeScreen {
                            SavingPlansForHomeScreen(account: $account, update: $update)
                        }
                        //End Saving Plans
                        
                        // Automations
                        if userDefaultsManager.isAutomationsDisplayedHomeScreen {
                            AutomationsForHomeScreen(account: $account, update: $update)
                        }
                        // End Automations
                        
                        // Recent Transactions
                        if userDefaultsManager.isRecentTransactionsDisplayedHomeScreen {
                            VStack {
                                NavigationLink(destination: {
                                    RecentTransactionsView(account: $account, update: $update)
                                }, label: {
                                    HStack {
                                        Text(NSLocalizedString("word_recent_transactions", comment: ""))
                                            .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                                            .font(.semiBoldCustom(size: 22))
                                        
                                        Spacer()
                                        Image(systemName: "arrow.right")
                                            .foregroundColor(HelperManager().getAppTheme().color)
                                            .font(.system(size: 20, weight: .medium, design: .rounded))
                                    }
                                    .padding(.horizontal)
                                    .padding(.top)
                                })
                                
                                if account.transactions.count != 0 {
                                    ForEach(account.transactions.prefix(userDefaultsManager.recentTransactionNumber)) { transaction in
                                        NavigationLink(destination: {
                                            TransactionDetailView(transaction: transaction, update: $update)
                                        }, label: {
                                            CellTransactionView(transaction: transaction, update: $update)
                                        })
                                    }
                                } else {
                                    VStack(spacing: 20) {
                                        Image("NoTransaction\(themeSelected)")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .shadow(radius: 4, y: 4)
                                            .frame(width: isIPad ? (orientation.isLandscape ? UIScreen.main.bounds.width / 3 : UIScreen.main.bounds.width / 2) : UIScreen.main.bounds.width / 1.5)
                                        
                                        Text(NSLocalizedString("home_screen_no_transaction", comment: ""))
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
                        //END Recent Transactions
                    }
                    Spacer()
                }//End Scroll View
                
            } //End VStack
            .padding(update ? 0 : 0)
            .onRotate { newOrientation in
                orientation = newOrientation
                update.toggle()
            }
            .onChange(of: userDefaultsManager.isStepsEnbaleForAllSavingsPlans) { newValue in
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
                print("🔥 LOCALE : \(Locale.current.identifier)")
                addDefaultValueForPreference()
                getOrientationOnAppear()
                
                AutomationManager().activateScheduledAutomations(automations: account.automations)
                TransactionManager().archiveTransactionsAutomatically(account: account)
                SavingPlanManager().archiveCompletedSavingPlansAutomatically(account: account)
                
                accountBalanceInt = account.balance.splitDecimal().0
                accountBalanceDouble = account.balance.splitDecimal().1
                if accountBalanceDouble.rounded(places: 2) == 1 { accountBalanceDouble = 0 }
                
                //Notification Counter
                UserDefaults.standard.set(0, forKey: "counterOfNotif")
                UIApplication.shared.applicationIconBadgeNumber = 0
                
                let arrayOfTransactionWithBadSubcategory = transactions.filter({ ($0.predefSubcategoryID == "" || $0.predefSubcategoryID == nil) && $0.transactionToSubCategory != nil })
                if arrayOfTransactionWithBadSubcategory.count != 0 {
                    for transaction in arrayOfTransactionWithBadSubcategory {
                        if transaction.transactionToSubCategory?.idUnique != "" {
                            print("🔥 TRANSACTION BAD SUBCATEGORY: \(transaction.title) -> \(transaction.date.formatted(date: .numeric, time: .omitted)) -> CAT \(transaction.predefCategoryID)")
                            transaction.predefSubcategoryID = transaction.transactionToSubCategory?.idUnique ?? ""
                            transaction.transactionToSubCategory = nil
                            persistenceController.saveContext()
                        }
                    }
                    predefinedObjectManager.reloadTransactions()
                }
                
                let arrayOfTransactionWithBadCategory = transactions.filter({ ($0.predefCategoryID == "" || $0.predefCategoryID == nil) && $0.transactionToCategory != nil })
                if arrayOfTransactionWithBadCategory.count != 0 {
                    for transaction in arrayOfTransactionWithBadCategory {
                        if transaction.transactionToCategory?.idUnique != "" {
                            print("🔥 TRANSACTION BAD CATEGORY: \(transaction.title) \(transaction.date.formatted(date: .numeric, time: .omitted))")
                            transaction.predefCategoryID = transaction.transactionToCategory?.idUnique ?? ""
                            transaction.transactionToCategory = nil
                            persistenceController.saveContext()
                        }
                    }
                    predefinedObjectManager.reloadTransactions()
                }

                update.toggle()
            }
        } // End if
    }//END body
    
    //MARK: Fonctions
    func addDefaultValueForPreference() { //TODO: Changer de place
        if userDefaultsManager.cardLimitPercentage == 0 { userDefaultsManager.cardLimitPercentage = 80 }
        if userDefaultsManager.recentTransactionNumber == 0 { userDefaultsManager.recentTransactionNumber = 5 }
    }
    
    func getOrientationOnAppear() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            orientation = UIDeviceOrientation.landscapeLeft
        } else { orientation = UIDeviceOrientation.portrait }
    }
    
//    func checkIfBadSubcategory() {
//        var arrayOfTransactionWithBadSubcategory = transactions.filter { transaction in
//            let category = PredefinedCategoryManager().categoryByUniqueID(idUnique: transaction.predefCategoryID)
//            
//            let hasEmptySubcategory = (transaction.predefSubcategoryID == "" || transaction.predefSubcategoryID == nil)
//            let hasValidCategory = (transaction.predefCategoryID != "")
//            let categoryHasSubcategories = (category?.subcategories.count ?? 0) != 0
//            
//            return hasEmptySubcategory && hasValidCategory && categoryHasSubcategories
//        }
//        if arrayOfTransactionWithBadSubcategory.count != 0 {
//            for transaction in arrayOfTransactionWithBadSubcategory {
//                transaction.predefSubcategoryID = transaction.transactionToSubCategory?.idUnique ?? ""
//                persistenceController.saveContext()
//                predefinedObjectManager.reloadTransactions()
//            }
//        }
//    }
}//END struct

//MARK: - Preview
#Preview {
    HomeScreenView(account: Binding.constant(previewAccount1()), update: Binding.constant(false))
}
