//
//  AccountHomeView.swift
//  CashFlow
//
//  Created by Théo Sementa on 09/07/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct AccountHomeView: View {
    
    //Custom type
    @Binding var account: Account?
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    var categories = PredefinedObjectManager.shared.allPredefinedCategory
    
    //CoreData
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Budget.title, ascending: true)])
    private var budgets: FetchedResults<Budget>
    
    //Environnements
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var csManager: ColorSchemeManager
    @EnvironmentObject var store: Store
    
    //State or Binding String
    @State private var cardNumber: String = ""
    @State private var cardHolder: String = ""
    @State private var cardDate: String = ""
    @State private var cardCVV: String = ""
    @State private var accountName: String = ""
    @State private var accountNameForDeleting: String = ""
    
    //State or Binding Int, Float and Double
    @State private var cardLimit: Double = 0.0
    @State private var accountBalanceInt: Int = 0
    @State private var accountBalanceDouble: Double = 0.0
    
    //State or Binding Bool
    @State private var isDeleting: Bool = false
    @State private var isEditingCardLimit: Bool = false
    @State private var isEditingAccountName: Bool = false
    @State private var showAddCard: Bool = false
    @State private var busy: Bool = false
    @State private var showAlertPaywall: Bool = false
    @State private var showPaywall: Bool = false
    
    //State or Binding Date

    //Enum
    
    //Computed var
    var widthOfChart: CGFloat {
        if isIPad {
            return UIScreen.main.bounds.width / 5
        } else {
            return UIScreen.main.bounds.width / 3
        }
    }
    
    var percentage: Double {
        if let account {
            if account.amountOfExpensesInActualMonth() / Double(account.cardLimit) >= 1 { return 0.98 } else {
                return account.amountOfExpensesInActualMonth() / Double(account.cardLimit)
            }
        } else { return 0 }
    }
    
    var realPercentage: Double {
        if let account {
            return account.amountOfExpensesInActualMonth() / Double(account.cardLimit)
        } else { return 0 }
    }
    
    var columns: [GridItem] {
        if isIPad {
            return [GridItem(), GridItem(), GridItem(), GridItem()]
        } else {
            return [GridItem(), GridItem()]
        }
    }
    
    //Other
    var numberFormatter: NumberFormatter {
        let numFor = NumberFormatter()
        numFor.numberStyle = .decimal
        numFor.zeroSymbol = ""
        return numFor
    }
    
    //Binding Bool
    @Binding var update: Bool
    
    //MARK: - Body
    var body: some View {
        VStack {
            if let account {
                ScrollView(showsIndicators: false) {
                    Text(account.title)
                        .titleAdjustSize()
                        .foregroundColor(HelperManager().getAppTheme().color)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    VStack(spacing: -2) {
                        Text(NSLocalizedString("account_detail_avail_balance", comment: ""))
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
                                    PieChartViewNoInteractive(categories: categories, width: .constant(widthOfChart), height: .constant(widthOfChart), update: $update)
                                        .padding(.horizontal, 8)
                                    VStack {
                                        cellForChart(text: NSLocalizedString("word_expenses", comment: ""), amount: amountExpenses.currency)
                                        cellForChart(text: NSLocalizedString("word_incomes", comment: ""), amount: amountIncomes.currency)
                                        cellForChart(text: NSLocalizedString("account_detail_cashflow", comment: ""), amount: amountCashFlow.currency)
                                        cellForChart(text: NSLocalizedString(amountGainOrLoss > 0 ? "account_detail_gain" : "account_detail_loss", comment: ""), amount: amountGainOrLoss.currency)
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
                        NavigationLink(destination: { RecentTransactionsView(account: $account, update: $update) }, label: {
                            cellForOnglet(text: NSLocalizedString("word_transactions", comment: ""), num: account.transactions.count, systemImage: "banknote.fill")
                        })
                        NavigationLink(destination: { AutomationsHomeView(account: $account, update: $update) }, label: {
                            cellForOnglet(text: NSLocalizedString("word_automations", comment: ""), num: account.automations.count, systemImage: "gearshape.2.fill")
                        })
                        
                        NavigationLink(destination: { SavingPlansHomeView(account: $account, update: $update) }, label: {
                            cellForOnglet(text: NSLocalizedString("word_savingsplans", comment: ""), num: account.savingPlans.count, systemImage: "building.columns.fill")
                        })
                        
                        if store.isLifetimeActive {
                            NavigationLink(destination: { BudgetsHomeView() }, label: {
                                cellForOnglet(text: NSLocalizedString("word_budgets", comment: ""), num: budgets.count, systemImage: "chart.pie.fill")
                            })
                        } else {
                            cellForOnglet(text: NSLocalizedString("word_budgets", comment: ""), num: budgets.count, systemImage: "chart.pie.fill")
                                .opacity(0.5)
                                .overlay { Image(systemName: "lock.fill") }
                                .onTapGesture { showAlertPaywall.toggle() }
                        }
                        
//                        if account.transactionsArchived.count != 0 {
//                            NavigationLink(destination: { ArchivedTransactionsView(account: $account, update: $update) }, label: {
//                                cellForOnglet(text: NSLocalizedString("word_archived_transactions", comment: ""), num: account.transactionsArchived.count, systemImage: "archivebox.fill")
//                            })
//                        }
                        if account.savingPlansArchived.count != 0 {
                            NavigationLink(destination: { ArchivedSavingPlansView(account: $account, update: $update) }, label: {
                                cellForOnglet(text: NSLocalizedString("word_archived_savingsplans", comment: ""), num: account.savingPlansArchived.count, systemImage: "archivebox.fill")
                            })
                        }
                        
                        if account.accountToCard == nil {
                            Button(action: { showAddCard.toggle() }, label: {
                                cellForOnglet(text: NSLocalizedString("account_detail_add_credit_card", comment: ""), num: 0, systemImage: "plus")
                            })
                        }
                    })
                    .padding(.horizontal, 8)

                    if account.cardLimit != 0 {
                        cardLimitProgress(account: account)
                    }
                    
                    if let card = account.accountToCard {
                        CardViewNotEditable(cardNumber: card.number, cardHolder: card.holder, cardDate: card.date)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                    }
                    
                    Rectangle().frame(height: 120).opacity(0)
                }
                .padding(update ? 0 : 0)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.large)
                .padding(.top, -40)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Menu(content: {
                            Button(action: { isEditingAccountName.toggle() }, label: { Label(NSLocalizedString("account_detail_rename", comment: ""), systemImage: "pencil") })
                            Button(action: { isEditingCardLimit.toggle() }, label: { Label(NSLocalizedString("account_detail_edit", comment: ""), systemImage: "pencil") })
                            Button(role: .destructive, action: { isDeleting.toggle() }, label: { Label(NSLocalizedString("word_delete", comment: ""), systemImage: "trash.fill") })
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
                                        .font(.system(size: 18, weight: .medium, design: .rounded))
                                })
                            }
                            
                            NavigationLink(destination: {
                                SettingsHomeView(account: account, update: $update)
                                    .environmentObject(csManager)
                            }, label: {
                                Image(systemName: "gearshape.fill")
                                    .foregroundColor(.colorLabel)
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                            })
                        }
                    }
                }
                .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
                .sheet(isPresented: $showAddCard, onDismiss: { update.toggle() }) { AddCardView(account: $account) }
                .alert(NSLocalizedString(NSLocalizedString("account_detail_rename", comment: ""), comment: ""), isPresented: $isEditingAccountName, actions: {
                    TextField(NSLocalizedString("account_detail_new_name", comment: ""), text: $accountName)
                    Button(action: { return }, label: { Text(NSLocalizedString("word_cancel", comment: "")) })
                    Button(action: {
                        account.title = accountName
                        persistenceController.saveContext()
                    }, label: { Text(NSLocalizedString("word_validate", comment: "")) })
                })
                .alert(NSLocalizedString(NSLocalizedString("account_detail_card_limit", comment: ""), comment: ""), isPresented: $isEditingCardLimit, actions: {
                    TextField(NSLocalizedString("account_detail_card_limit", comment: ""), value: $cardLimit, formatter: numberFormatter)
                        .keyboardType(.numberPad)
                    Button(action: { return }, label: { Text(NSLocalizedString("word_cancel", comment: "")) })
                    Button(action: {
                        account.cardLimit = cardLimit
                        persistenceController.saveContext()
                    }, label: { Text(NSLocalizedString("word_validate", comment: "")) })
                }, message: {
                    Text(NSLocalizedString("account_detail_edit_desc", comment: ""))
                })
                .alert(NSLocalizedString("account_detail_delete_account", comment: ""), isPresented: $isDeleting, actions: {
                    TextField(account.title, text: $accountNameForDeleting)
                    Button(role: .cancel, action: { return }, label: { Text(NSLocalizedString("word_cancel", comment: "")) })
                    Button(role: .destructive, action: {
                        if account.title == accountNameForDeleting {
                            withAnimation {
                                viewContext.delete(account)
                                self.account = nil
                                persistenceController.saveContext()
                                update.toggle()
                            }
                        }
                    }, label: { Text(NSLocalizedString("word_delete", comment: "")) })
                }, message: { Text(NSLocalizedString("account_detail_delete_account_desc", comment: "")) })
            } else {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        VStack(spacing: 20) {
                            Image("NoCards\(themeSelected)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .shadow(radius: 4, y: 4)
                                .frame(width: isIPad ? (orientation.isPortrait ? UIScreen.main.bounds.width / 2 : UIScreen.main.bounds.width / 3) : UIScreen.main.bounds.width / 1.5 )
                            
                            Text(NSLocalizedString("account_detail_no_account", comment: ""))
                                .font(.semiBoldText16())
                                .multilineTextAlignment(.center)
                        }
                        .offset(y: -50)
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
        } // Main VStack
        .padding(update ? 0 : 0)
        .onAppear {
            if let account {
                accountBalanceInt = account.balance.splitDecimal().0
                accountBalanceDouble = account.balance.splitDecimal().1
                if accountBalanceDouble.rounded(places: 2) == 1 { accountBalanceDouble = 0 }
            }
        }
        .alert(NSLocalizedString("alert_cashflow_pro_title", comment: ""), isPresented: $showAlertPaywall, actions: {
            Button(action: { return }, label: { Text(NSLocalizedString("word_cancel", comment: "")) })
            Button(action: { showPaywall.toggle() }, label: { Text(NSLocalizedString("alert_cashflow_pro_see", comment: "")) })
        }, message: {
            Text(NSLocalizedString("alert_cashflow_pro_desc", comment: ""))
        })
        .sheet(isPresented: $showPaywall) { PaywallScreenView().environmentObject(store) }
        .if(account != nil, transform: { view in
            view
                .onChange(of: account!.balance, perform: { _ in
                    Timer.animateNumber(number: $accountBalanceInt, busy: $busy, start: accountBalanceInt, end: Int(account!.balance))
                    withAnimation {
                        accountBalanceDouble = account!.balance.splitDecimal().1
                        if accountBalanceDouble.rounded(places: 2) == 1 { accountBalanceDouble = 0 }
                    }
                })
        })
    }//END body
    
    //MARK: - ViewBuilder
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
        
        let isPercentage80AndMoreButMinus100 = percentage >= userDefaultsManager.cardLimitPercentage / 100 && realPercentage < 1
        
        VStack {
            HStack {
                Text(NSLocalizedString("account_detail_card_limit", comment: ""))
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
                Text(NSLocalizedString("account_detail_card_remaining", comment: ""))
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
                    Text(isPercentage80AndMoreButMinus100 ? "⚠️ " + NSLocalizedString("account_detail_alert_almost_exceeded", comment: "") : "‼️ " + NSLocalizedString("account_detail_alert_exceeded", comment: ""))
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
    
}//END struct

//MARK: - Preview
struct AccountDetailView_Previews: PreviewProvider {
    
    @State static var previewBool: Bool = false
    @State static var previewAccount: Account? = previewAccount1()
    
    static var previews: some View {
        AccountHomeView(account: $previewAccount, update: $previewBool)
    }
}
