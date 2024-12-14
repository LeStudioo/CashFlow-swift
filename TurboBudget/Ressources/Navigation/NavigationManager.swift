//
//  NavigationManager.swift
//  Krabs
//
//  Created by Theo Sementa on 29/11/2023.
//

import SwiftUI

class NavigationManager: Router {

    // Push
    
    func pushHome(account: Account) {
        navigateTo(.home(account: account))
    }
    
    func pushHomeSavingPlans() {
        navigateTo(.homeSavingPlans)
    }
    
    func pushHomeAutomations() {
        navigateTo(.homeAutomations)
    }
    
    
    func pushAnalytics() {
        navigateTo(.analytics)
    }
    
    
    func pushAllTransactions() {
        navigateTo(.allTransactions)
    }
    
    func pushTransactionDetail(transaction: TransactionModel) {
        navigateTo(.transactionDetail(transaction: transaction))
    }
    
    
    func pushSavingPlansDetail(savingsPlan: SavingsPlanModel) {
        navigateTo(.savingPlansDetail(savingsPlan: savingsPlan))
    }
    
    
    func pushAccountDashboard() {
        navigateTo(.accountDashboard)
    }
    
    func pushSavingsAccountDetail(savingsAccount: AccountModel) {
        navigateTo(.savingsAccountDetail(savingsAccount: savingsAccount))
    }
    
    func pushAllSavingsAccount() {
        navigateTo(.allSavingsAccount)
    }
    
    func pushAllBudgets() {
        navigateTo(.allBudgets)
    }
    
    func pushBudgetTransactions(subcategory: SubcategoryModel) {
        navigateTo(.budgetTransactions(subcategory: subcategory))
    }
    
    func pushArchivedSavingPlans(account: Account) {
        navigateTo(.allArchivedSavingPlans(account: account))
    }
    
    
    func pushHomeCategories() {
        navigateTo(.homeCategories)
    }
    
    func pushCategoryTransactions(category: CategoryModel) {
        navigateTo(.categoryTransactions(category: category))
    }
    
    func pushHomeSubcategories(category: CategoryModel) {
        navigateTo(.homeSubcategories(category: category))
    }
    
    func pushSubcategoryTransactions(subcategory: SubcategoryModel) {
        navigateTo(.subcategoryTransactions(subcategory: subcategory))
    }
    
    
    func pushSettings() {
        navigateTo(.settings)
    }
    
    func pushSettingsDebug() {
        navigateTo(.settingsDebug)
    }
    
    func pushSettingsGeneral() {
        navigateTo(.settingsGeneral)
    }
    
    func pushSettingsSecurity() {
        navigateTo(.settingsSecurity)
    }
    
    func pushSettingsAppearence() {
        navigateTo(.settingsAppearence)
    }
    
    func pushSettingsDisplay() {
        navigateTo(.settingsDisplay)
    }
    
    func pushSettingsSubscription() {
        navigateTo(.settingsSubscription)
    }
    
    func pushSettingsCredits() {
        navigateTo(.settingsCredits)
    }
    
    func pushSettingsApplePay() {
        navigateTo(.settingsApplePay)
    }
    
    
    // Present
    func presentWhatsNew() {
        presentSheet(.whatsNew)
    }
    
    func presentPaywall() {
        presentSheet(.paywall)
    }
    
    func presentCreateAccount(type: AccountType, account: AccountModel? = nil) {
        presentSheet(.createAccount(type: type, account: account))
    }
    
    func presentCreateSubscription(subscription: SubscriptionModel? = nil, dismissAction: (() -> Void)? = nil) {
        presentSheet(.createSubscription(subscription: subscription), dismissAction)
    }
    
    func presentCreateBudget() {
        presentSheet(.createBudget)
    }
    
    func presentCreateSavingsPlan(savingsPlan: SavingsPlanModel? = nil, dismissAction: (() -> Void)? = nil) {
        presentSheet(.createSavingsPlan(savingsPlan: savingsPlan), dismissAction)
    }
    
    func presentCreateContribution(savingsPlan: SavingsPlanModel, dismissAction: (() -> Void)? = nil) {
        presentSheet(.createContribution(savingsPlan: savingsPlan), dismissAction)
    }
    
    func presentCreateTransaction(transaction: TransactionModel? = nil, dismissAction: (() -> Void)? = nil) {
        presentSheet(.createTransaction(transaction: transaction), dismissAction)
    }
    
    func presentCreateTransfer(receiverAccount: AccountModel? = nil, dismissAction: (() -> Void)? = nil) {
        presentSheet(.createTransfer(receiverAccount: receiverAccount), dismissAction)
    }
    
    func presentCreateCreditCard(dismissAction: (() -> Void)? = nil) {
        presentSheet(.createCreditCard, dismissAction)
    }
    
    func presentSelectCategory(
        category: Binding<CategoryModel?>,
        subcategory: Binding<SubcategoryModel?>,
        dismissAction: (() -> Void)? = nil
    ) {
        presentSheet(.selectCategory(category: category, subcategory: subcategory), dismissAction)
    }
    
    // Build view
    override func view(direction: NavigationDirection, route: Route) -> AnyView {
        AnyView(buildView(direction: direction, route: route))
    }
}

private extension NavigationManager {

    @ViewBuilder
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
                
            case .selectCategory(let category, let subcategory):
                SelectCategoryView(selectedCategory: category, selectedSubcategory: subcategory)
                
                
            case .allTransactions:
                TransactionsView()
            case .transactionDetail(let transaction):
                TransactionDetailView(transaction: transaction)
                
                
            case .savingPlansDetail(let savingsPlan):
                SavingsPlanDetailView(savingsPlan: savingsPlan)
                
                
            case .accountDashboard:
                AccountDashboardView()
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
            case .categoryTransactions(let category):
                CategoryTransactionsView(category: category)
            case .homeSubcategories(let category):
                SubcategoryHomeView(category: category)
            case .subcategoryTransactions(let subcategory):
                SubcategoryTransactionsView(subcategory: subcategory)
                
            case .whatsNew:
                WhatsNewView()
            case .paywall:
                PaywallScreenView()
                
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
