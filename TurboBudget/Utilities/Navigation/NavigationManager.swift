//
//  NavigationManager.swift
//  Krabs
//
//  Created by Theo Sementa on 29/11/2023.
//

import SwiftUI

class NavigationManager: Router {

    override func view(direction: NavigationDirection, route: Route) -> AnyView {
        AnyView(buildView(direction: direction, route: route))
    }
    
}

private extension NavigationManager {

    @ViewBuilder
    // swiftlint:disable cyclomatic_complexity
    func buildView(direction: NavigationDirection, route: Route) -> some View {
        Group {
            switch direction {
            case .pageController:
                PageControllerView()
                
            case .home:
                HomeView()
            case .homeSavingPlans:
                SavingsPlansHomeView()
            case .homeAutomations:
                SubscriptionHomeView()
                
            case .analytics:
                AnalyticsHomeView()
            case .transactionsForMonth(let month, let type):
                TransactionsForMonthView(selectedDate: month, type: type)
                
            case .createAccount(let type, let account):
                CreateAccountView(type: type, account: account)
            case .createSubscription(let subscription):
                CreateSubscriptionView(subscription: subscription)
            case .createBudget:
                CreateBudgetView()
            case .createSavingsPlan(let savingsPlan):
                CreateSavingPlansView(savingsPlan: savingsPlan)
            case .createContribution(let savingsPlan):
                CreateContributionView(savingsPlan: savingsPlan)
            case .createTransaction(let transaction):
                CreateTransactionView(transaction: transaction)
            case .createTransfer(let receiverAccount):
                CreateTransferView(receiverAccount: receiverAccount)
            case .createCreditCard:
                CreateCreditCardView()
            case .createTransactionForSavingsAccount(let savingsAccount, let transaction):
                CreateTransactionForSavingsAccountView(savingsAccount: savingsAccount, transaction: transaction)
            case .qrCodeScanner:
                QRCodeScannerView()
                
            case .selectCategory(let category, let subcategory):
                SelectCategoryView(selectedCategory: category, selectedSubcategory: subcategory)
                
            case .allTransactions:
                TransactionsView()
            case .transactionDetail(let transaction):
                TransactionDetailView(transaction: transaction)
                
            case .savingPlansDetail(let savingsPlan):
                SavingsPlanDetailView(savingsPlan: savingsPlan)
                
            case .subscriptionDetail(let subscription):
                SubscriptionDetailView(subscription: subscription)
                
            case .accountDashboard:
                AccountDashboardView()
            case .accountStatistics:
                AccountStatisticsView()
            case .savingsAccountDetail(let savingsAccount):
                SavingsAccountDetailView(savingsAccount: savingsAccount)
            case .allSavingsAccount:
                SavingsAccountHomeView()
            case .allBudgets:
                BudgetsHomeView()
            case .budgetTransactions(let subcategory):
                BudgetsTransactionsView(subcategory: subcategory)
            case .allArchivedSavingPlans(let account):
                ArchivedSavingPlansView(account: account)
                
            case .homeCategories:
                CategoryHomeView()
            case .categoryTransactions(let category, let selectedDate):
                CategoryTransactionsView(category: category, selectedDate: selectedDate)
            case .homeSubcategories(let category, let selectedDate):
                SubcategoryHomeView(category: category, selectedDate: selectedDate)
            case .subcategoryTransactions(let subcategory, let selectedDate):
                SubcategoryTransactionsView(subcategory: subcategory, selectedDate: selectedDate)
                
            case .whatsNew:
                WhatsNewView()
            case .paywall:
                PaywallView()
                
            case .settings:
                SettingsHomeView()
            case .settingsDebug:
                SettingsDebugView()
            case .settingsGeneral:
                SettingsGeneralView()
            case .settingsSecurity:
                SettingsSecurityView()
            case .settingsAppearence:
                SettingsAppearenceView()
            case .settingsDisplay:
                SettingsDisplayView()
            case .settingsSubscription:
                SettingsSubscriptionView()
            case .settingsCredits:
                SettingsCreditsView()
            case .settingsApplePay:
                SettingsApplePayView()
            }
        }
    }

    func router(route: Route) -> NavigationManager {
        switch route {
        case .navigation:
            return self
        case .sheet:
            return NavigationManager(isPresented: presentingSheet)
        case .fullScreenCover:
            return NavigationManager(isPresented: presentingFullScreen)
        case .modal:
            return NavigationManager(isPresented: presentingModal)
        case .modalCanFullScreen:
            return NavigationManager(isPresented: presentingModalCanFullScreen)
        }
    }
}
