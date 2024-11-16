//
//  AccountDashboardView.swift
//  CashFlow
//
//  Created by Théo Sementa on 09/07/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct AccountDashboardView: View {
    
    //Environement
    @Environment(\.managedObjectContext) private var viewContext
    
    // EnvironmentObject
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject var csManager: ColorSchemeManager
    @EnvironmentObject var store: PurchasesManager
        
    @EnvironmentObject private var accountRepository: AccountRepository
    @EnvironmentObject private var transactionRepository: TransactionRepository
    @EnvironmentObject private var subscriptionRepository: SubscriptionRepository
    @EnvironmentObject private var savingsPlanRepository: SavingsPlanRepository
    @EnvironmentObject private var budgetRepository: BudgetRepository
    
    //State or Binding String
    @State private var accountName: String = ""
    @State private var accountNameForDeleting: String = ""
    
    //State or Binding Bool
    @State private var isDeleting: Bool = false
    @State private var isEditingAccountName: Bool = false
    @State private var showAlertPaywall: Bool = false
    @State private var showPaywall: Bool = false
    
    // Computed var
    var columns: [GridItem] {
        if isIPad {
            return [GridItem(spacing: 16), GridItem(spacing: 16), GridItem(spacing: 16), GridItem(spacing: 16)]
        } else {
            return [GridItem(spacing: 16), GridItem(spacing: 16)]
        }
    }
    
    // MARK: - body
    var body: some View {
        ScrollView {
            if let account = accountRepository.selectedAccount {
                VStack {
                    Text(account.name ?? "")
                        .titleAdjustSize()
                        .foregroundStyle(ThemeManager.theme.color)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    VStack(spacing: -2) {
                        Text("account_detail_avail_balance".localized)
                            .font(Font.mediumText16())
                            .foregroundStyle(Color.customGray)
                        
                        Text(currencySymbol + " " + (account.balance?.formatWith(2) ?? ""))
                            .titleAdjustSize()
                    }
                    .padding(.vertical, 12)
                }
            }
            
            VStack(spacing: 16) {
                if store.isCashFlowPro {
                    DashboardChart()
                }
                
                LazyVGrid(columns: columns, spacing: 16, content: {
                    NavigationButton(push: router.pushAllTransactions()) {
                        DashboardRow(
                            config: .init(
                                icon: "banknote.fill",
                                text: "word_transactions".localized,
                                num: transactionRepository.transactions.count
                            )
                        )
                    }
                    
                    NavigationButton(push: router.pushHomeAutomations()) {
                        DashboardRow(
                            config: .init(
                                icon: "gearshape.2.fill",
                                text: "word_automations".localized,
                                num: subscriptionRepository.subscriptions.count
                            )
                        )
                    }
                    
                    NavigationButton(push: router.pushHomeSavingPlans()) {
                        DashboardRow(
                            config: .init(
                                icon: "dollarsign.square.fill",
                                text: "word_savingsplans".localized,
                                num: savingsPlanRepository.savingsPlans.count
                            )
                        )
                    }
                    
                    NavigationButton(push: router.pushAllBudgets()) {
                        DashboardRow(
                            config: .init(
                                icon: "chart.pie.fill",
                                text: "word_budgets".localized,
                                num: budgetRepository.budgets.count,
                                isLocked: !store.isCashFlowPro
                            )
                        )
                    }
                    .disabled(!store.isCashFlowPro)
                    .onTapGesture {
                        if !store.isCashFlowPro {
                            showAlertPaywall.toggle()
                        }
                    }
                })
            }
            .padding(.horizontal)
            
            Rectangle()
                .frame(height: 120)
                .opacity(0)
        }
        .scrollIndicators(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Menu(content: {
                    Button(action: { isEditingAccountName.toggle() }, label: { Label("account_detail_rename".localized, systemImage: "pencil") })
                    Button(role: .destructive, action: { isDeleting.toggle() }, label: { Label("word_delete".localized, systemImage: "trash.fill") })
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.label)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    if !store.isCashFlowPro {
                        Button(action: { showPaywall.toggle() }, label: {
                            Image(systemName: "crown.fill")
                                .foregroundStyle(.primary500)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                        })
                    }
                    
                    NavigationButton(push: router.pushSettings()) {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(Color.label)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                    }
                }
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .alert("account_detail_rename".localized, isPresented: $isEditingAccountName, actions: {
            TextField("account_detail_new_name".localized, text: $accountName)
            Button(action: { return }, label: { Text("word_cancel".localized) })
            Button(action: {
                Task {
                    if let account = accountRepository.selectedAccount, let accountID = account.id {
                        await accountRepository.updateAccount(accountID: accountID, body: .init(name: accountName))
                    }
                }
            }, label: { Text("word_validate".localized) })
        })
//        .alert("account_detail_delete_account".localized, isPresented: $isDeleting, actions: {
//            TextField(account?.name ?? "", text: $accountNameForDeleting)
//            Button(role: .cancel, action: { return }, label: { Text("word_cancel".localized) })
//            Button(role: .destructive, action: {
//                if account?.name == accountNameForDeleting {
                    //                        withAnimation {
                    //                            viewContext.delete(account)
                    //                            AccountRepositoryOld.shared.mainAccount = nil
                    //                            persistenceController.saveContext()
                    //                        }
                    // TODO: Delete account
//                }
//            }, label: { Text("word_delete".localized) })
//        }, message: { Text("account_detail_delete_account_desc".localized) })
        //                VStack {
        //                    Spacer()
        //
        //                    HStack {
        //                        Spacer()
        //                        VStack(spacing: 20) {
        //                            Image("NoCards\(ThemeManager.theme.nameNotLocalized.capitalized)")
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
        
        .alert("alert_cashflow_pro_title".localized, isPresented: $showAlertPaywall, actions: {
            Button(action: { return }, label: { Text("word_cancel".localized) })
            Button(action: { showPaywall.toggle() }, label: { Text("alert_cashflow_pro_see".localized) })
        }, message: {
            Text("alert_cashflow_pro_desc".localized)
        })
        .sheet(isPresented: $showPaywall) { PaywallScreenView().environmentObject(store) }
        
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    AccountDashboardView()
}
