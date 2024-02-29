//
//  AccountDashboardView.swift
//  CashFlow
//
//  Created by Théo Sementa on 09/07/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct AccountDashboardView: View {
    
    // Builder
    var router: NavigationManager
    @ObservedObject var account: Account
    
    // Custom type
    var categories = PredefinedObjectManager.shared.allPredefinedCategory
    
    // CoreData
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Budget.title, ascending: true)])
    private var budgets: FetchedResults<Budget>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \SavingsAccount.id, ascending: true)])
    private var savingsAccounts: FetchedResults<SavingsAccount>
    
    //Environement
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    // EnvironmentObject
    @EnvironmentObject var csManager: ColorSchemeManager
    @EnvironmentObject var store: Store
    
    // Preferences
    @Preference(\.cardLimitPercentage) private var cardLimitPercentage
    
    //State or Binding String
    @State private var accountName: String = ""
    @State private var accountNameForDeleting: String = ""
    
    //State or Binding Int, Float and Double
    @State private var cardLimit: Double = 0.0
    @State private var accountBalanceInt: Int = 0
    @State private var accountBalanceDouble: Double = 0.0
    
    //State or Binding Bool
    @State private var isDeleting: Bool = false
    @State private var isEditingAccountName: Bool = false
    @State private var showAddCard: Bool = false
    @State private var busy: Bool = false
    @State private var showAlertPaywall: Bool = false
    @State private var showPaywall: Bool = false
    
    // Computed var
    var widthOfChart: CGFloat {
        if isIPad {
            return UIScreen.main.bounds.width / 5
        } else {
            return UIScreen.main.bounds.width / 3
        }
    }
    
    var percentage: Double {
        if account.amountOfExpensesInActualMonth() / Double(account.cardLimit) >= 1 { return 0.98 } else {
            return account.amountOfExpensesInActualMonth() / Double(account.cardLimit)
        }
    }
    
    var realPercentage: Double {
        return account.amountOfExpensesInActualMonth() / Double(account.cardLimit)
    }
    
    var columns: [GridItem] {
        if isIPad {
            return [GridItem(), GridItem(), GridItem(), GridItem()]
        } else {
            return [GridItem(), GridItem()]
        }
    }
    
    // Other
    var numberFormatter: NumberFormatter {
        let numFor = NumberFormatter()
        numFor.numberStyle = .decimal
        numFor.zeroSymbol = ""
        return numFor
    }
    
    // init
    init(router: NavigationManager, account: Account) {
        self.router = router
        self.account = account
    }
    
    // MARK: - body
    var body: some View {
        NavStack(router: router) {
            VStack {
                ScrollView(showsIndicators: false) {
                    Text(account.title)
                        .titleAdjustSize()
                        .foregroundColor(HelperManager().getAppTheme().color)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    VStack(spacing: -2) {
                        Text("account_detail_avail_balance".localized)
                            .font(Font.mediumText16())
                            .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
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
                        .font(.boldH1())
                    }
                    .padding(.vertical, 12)
                    
                    if store.isLifetimeActive {
                        let amountExpenses: Double = account.amountExpensesByMonth(month: .now)
                        let amountIncomes: Double = account.amountIncomesByMonth(month: .now)
                        let amountCashFlow: Double = account.amountCashFlowByMonth(month: .now)
                        let amountGainOrLoss: Double = account.amountGainOrLossByMonth(month: .now)
                        if amountExpenses != 0 {
                            VStack(alignment: .leading) {
                                Text(HelperManager().formattedDateWithMonthYear(date: .now))
                                    .font(.semiBoldH3())
                                    .padding(.leading, 8)
                                HStack {
                                    PieChartViewNoInteractive(
                                        categories: categories,
                                        width: .constant(widthOfChart),
                                        height: .constant(widthOfChart)
                                    )
                                    .padding(.horizontal, 8)
                                    VStack {
                                        cellForChart(text: "word_expenses".localized, amount: amountExpenses.currency)
                                        cellForChart(text: "word_incomes".localized, amount: amountIncomes.currency)
                                        cellForChart(text: "account_detail_cashflow".localized, amount: amountCashFlow.currency)
                                        cellForChart(text: amountGainOrLoss > 0 ? "account_detail_gain" : "account_detail_loss".localized, amount: amountGainOrLoss.currency)
                                    }
                                }
                            }
                            .padding(8)
                            .foregroundColor(colorScheme == .light ? .secondary500 : .primary0)
                            .background(Color.colorCell)
                            .cornerRadius(15)
                            .padding(.horizontal, 8)
                            .padding(.bottom, 4)
                        }
                    }
                    
                    LazyVGrid(columns: columns, spacing: 12, content: {
                        
                        Button(action: {
                            router.pushAllSavingsAccount()
                        }, label: {
                            cellForOnglet(
                                text: "word_savings_account".localized,
                                num: savingsAccounts.count,
                                systemImage: "building.columns.fill"
                            )
                        })
                        
                        Button(action: {
                            router.pushAllTransactions(account: account)
                        }, label: {
                            cellForOnglet(
                                text: "word_transactions".localized,
                                num: account.transactions.count,
                                systemImage: "banknote.fill"
                            )
                        })
                        
                        Button(action: {
                            router.pushHomeAutomations(account: account)
                        }, label: {
                            cellForOnglet(
                                text: "word_automations".localized,
                                num: account.automations.count,
                                systemImage: "gearshape.2.fill"
                            )
                        })
                        
                        Button(action: {
                            router.pushHomeSavingPlans(account: account)
                        }, label: {
                            cellForOnglet(
                                text: "word_savingsplans".localized,
                                num: account.savingPlans.count,
                                systemImage: "dollarsign.square.fill"
                            )
                        })
                        
                        if store.isLifetimeActive {
                            Button(action: {
                                router.pushAllBudgets()
                            }, label: {
                                cellForOnglet(
                                    text: "word_budgets".localized,
                                    num: budgets.count,
                                    systemImage: "chart.pie.fill"
                                )
                            })
                        } else {
                            cellForOnglet(text: "word_budgets".localized, num: budgets.count, systemImage: "chart.pie.fill")
                                .opacity(0.5)
                                .overlay { Image(systemName: "lock.fill") }
                                .onTapGesture { showAlertPaywall.toggle() }
                        }
                        
                        if account.savingPlansArchived.count != 0 {
                            Button(action: {
                                router.pushArchivedSavingPlans(account: account)
                            }, label: {
                                cellForOnglet(
                                    text: "word_archived_savingsplans".localized,
                                    num: account.savingPlansArchived.count,
                                    systemImage: "archivebox.fill"
                                )
                            })
                        }
                    })
                    .padding(.horizontal, 8)
                    
                    if account.cardLimit != 0 {
                        cardLimitProgress(account: account)
                    }
                    
                    Rectangle()
                        .frame(height: 120)
                        .opacity(0)
                }
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.large)
                .padding(.top, -40)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Menu(content: {
                            Button(action: { isEditingAccountName.toggle() }, label: { Label("account_detail_rename".localized, systemImage: "pencil") })
                            Button(role: .destructive, action: { isDeleting.toggle() }, label: { Label("word_delete".localized, systemImage: "trash.fill") })
                        }, label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.colorLabel)
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                        })
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            if !store.isLifetimeActive {
                                Button(action: { showPaywall.toggle() }, label: {
                                    Image(systemName: "crown.fill")
                                        .foregroundColor(.primary500)
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                })
                            }
                            
                            Button(action: {
                                router.pushSettings(account: account)
                            }, label: {
                                Image(systemName: "gearshape.fill")
                                    .foregroundStyle(Color(uiColor: .label))
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                            })
                        }
                    }
                }
                .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
                .alert("account_detail_rename".localized, isPresented: $isEditingAccountName, actions: {
                    TextField("account_detail_new_name".localized, text: $accountName)
                    Button(action: { return }, label: { Text("word_cancel".localized) })
                    Button(action: {
                        account.title = accountName
                        persistenceController.saveContext()
                    }, label: { Text("word_validate".localized) })
                })
                .alert("account_detail_delete_account".localized, isPresented: $isDeleting, actions: {
                    TextField(account.title, text: $accountNameForDeleting)
                    Button(role: .cancel, action: { return }, label: { Text("word_cancel".localized) })
                    Button(role: .destructive, action: {
                        if account.title == accountNameForDeleting {
                            withAnimation {
                                viewContext.delete(account)
                                persistenceController.saveContext()
                            }
                        }
                    }, label: { Text("word_delete".localized) })
                }, message: { Text("account_detail_delete_account_desc".localized) })
                //                VStack {
                //                    Spacer()
                //
                //                    HStack {
                //                        Spacer()
                //                        VStack(spacing: 20) {
                //                            Image("NoCards\(themeSelected)")
                //                                .resizable()
                //                                .aspectRatio(contentMode: .fit)
                //                                .shadow(radius: 4, y: 4)
                //                                .frame(width: isIPad ? (orientation.isPortrait ? UIScreen.main.bounds.width / 2 : UIScreen.main.bounds.width / 3) : UIScreen.main.bounds.width / 1.5 )
                //
                //                            Text("account_detail_no_account".localized)
                //                                .font(.semiBoldText16())
                //                                .multilineTextAlignment(.center)
                //                        }
                //                        .offset(y: -50)
                //                        Spacer()
                //                    }
                //
                //                    Spacer()
                //                }
                
            } // Main VStack
            .onAppear {
                accountBalanceInt = account.balance.splitDecimal().0
                accountBalanceDouble = account.balance.splitDecimal().1
                if accountBalanceDouble.rounded(places: 2) == 1 { accountBalanceDouble = 0 }
            }
            .alert("alert_cashflow_pro_title".localized, isPresented: $showAlertPaywall, actions: {
                Button(action: { return }, label: { Text("word_cancel".localized) })
                Button(action: { showPaywall.toggle() }, label: { Text("alert_cashflow_pro_see".localized) })
            }, message: {
                Text("alert_cashflow_pro_desc".localized)
            })
            .sheet(isPresented: $showPaywall) { PaywallScreenView().environmentObject(store) }
            .onChange(of: account.balance, perform: { _ in
                Timer.animateNumber(number: $accountBalanceInt, busy: $busy, start: accountBalanceInt, end: Int(account.balance))
                withAnimation {
                    accountBalanceDouble = account.balance.splitDecimal().1
                    if accountBalanceDouble.rounded(places: 2) == 1 { accountBalanceDouble = 0 }
                }
            })
        } // End NavStack
    } // End body
    
    // MARK: - ViewBuilder
    @ViewBuilder
    func cellForOnglet(text: String, num: Int, systemImage: String) -> some View {
        let width = isIPad ? UIScreen.main.bounds.width / 4 - 16 : UIScreen.main.bounds.width / 2 - 16
        
        VStack(alignment: .leading) {
            HStack {
                Rectangle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.color3Apple)
                    .cornerRadius(12)
                    .overlay {
                        Image(systemName: systemImage)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(colorScheme == .light ? .secondary500 : .primary0)
                            .shadow(radius: 2, y: 2)
                    }
                Spacer()
                
                if num != 0 {
                    Text(String(num))
                        .font(.semiBoldText16())
                }
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
            }
            Spacer(minLength: 0)
            Text(text)
                .font(.semiBoldText16())
                .multilineTextAlignment(.leading)
                .lineLimit(2)
        }
        .padding()
        .foregroundColor(colorScheme == .light ? .secondary500 : .primary0)
        .frame(width: width, height: width / 2 + 40)
        .background(Color.colorCell)
        .cornerRadius(15)
    }
    
    @ViewBuilder
    func cellForChart(text: String, amount: String) -> some View {
        HStack {
            Text(text)
            Spacer()
            Text(amount)
        }
        .padding(8)
        .background(Color.color3Apple)
        .cornerRadius(12)
        .font(.mediumSmall())
    }
    
    @ViewBuilder
    func cardLimitProgress(account: Account) -> some View {
        
        let isPercentage80AndMoreButMinus100 = percentage >= cardLimitPercentage / 100 && realPercentage < 1
        
        VStack {
            HStack {
                Text("account_detail_card_limit".localized)
                Spacer()
                Text(account.cardLimit.currency)
            }
            .font(.semiBoldText16())
            .foregroundColor(.colorLabel)
            
            GeometryReader { geometry in
                let widthCapsule = geometry.size.width * percentage
                let widthAmount = account.amountOfExpensesInActualMonth().currency.widthOfString(usingFont: UIFont(name: nameFontBold, size: 16)!) * 1.5
                
                Capsule()
                    .frame(height: 36)
                    .foregroundStyle(Color.color3Apple)
                    .overlay(alignment: .leading) {
                        Capsule()
                            .foregroundColor(HelperManager().getAppTheme().color)
                            .frame(width: widthCapsule < widthAmount ? widthAmount : widthCapsule)
                            .padding(4)
                            .overlay(alignment: .trailing) {
                                Text(account.amountOfExpensesInActualMonth().currency)
                                    .padding(.trailing, 12)
                                    .font(.semiBoldText16())
                                    .foregroundColor(.primary0)
                            }
                    }
                
            } // End GeometryReader
            .frame(height: 44)
            
            HStack {
                let amountRemaining = account.cardLimit - account.amountOfExpensesInActualMonth()
                Text("account_detail_card_remaining".localized)
                Spacer()
                Text(amountRemaining.currency)
            }
            .font(.semiBoldText16())
            .padding(8)
            .padding(.horizontal, 8)
            .background {
                Capsule()
                    .foregroundStyle(Color.color3Apple)
                    .frame(height: 40)
            }
            .padding(.bottom, (isPercentage80AndMoreButMinus100 || realPercentage >= 1) ? 8 : 0)
            
            if isPercentage80AndMoreButMinus100 || realPercentage >= 1 {
                HStack {
                    Text(isPercentage80AndMoreButMinus100 ? "⚠️ " + "account_detail_alert_almost_exceeded".localized : "‼️ " + "account_detail_alert_exceeded".localized)
                        .foregroundColor(isPercentage80AndMoreButMinus100 ? .yellow : .red)
                        .font(.mediumText16())
                    Spacer()
                }
                .font(.semiBoldText16())
                .padding(8)
                .padding(.horizontal, 8)
                .background {
                    Capsule()
                        .foregroundStyle(Color.color3Apple)
                        .frame(height: 44)
                }
            }
        }
        .padding(12)
        .padding(.bottom, 8)
        .background(Color.colorCell)
        .cornerRadius(15)
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }
    
} // End struct

// MARK: - Preview
#Preview {
    AccountDashboardView(
        router: .init(isPresented: .constant(.accountDashboard(account: Account.preview))),
        account: Account.preview
    )
}
