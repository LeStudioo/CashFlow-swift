//
//  NavigationManager.swift
//  Krabs
//
//  Created by Theo Sementa on 29/11/2023.
//

import SwiftUI

class NavigationManager: Router {

    // Push
    func pushFilter() {
        navigateTo(.filter)
    }
    
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
    
    func pushSavingsAccountDetail(savingsAccount: SavingsAccount) {
        navigateTo(.savingsAccountDetail(savingsAccount: savingsAccount))
    }
    
    func pushAllSavingsAccount() {
        navigateTo(.allSavingsAccount)
    }
    
    func pushAllBudgets() {
        navigateTo(.allBudgets)
    }
    
    func pushBudgetTransactions(subcategory: PredefinedSubcategory) {
        navigateTo(.budgetTransactions(subcategory: subcategory))
    }
    
    func pushArchivedSavingPlans(account: Account) {
        navigateTo(.allArchivedSavingPlans(account: account))
    }
    
    
    func pushHomeCategories() {
        navigateTo(.homeCategories)
    }
    
    func pushCategoryTransactions(category: PredefinedCategory) {
        navigateTo(.categoryTransactions(category: category))
    }
    
    func pushHomeSubcategories(category: PredefinedCategory) {
        navigateTo(.homeSubcategories(category: category))
    }
    
    func pushSubcategoryTransactions(subcategory: PredefinedSubcategory) {
        navigateTo(.subcategoryTransactions(subcategory: subcategory))
    }
    
    
    func pushSettings() {
        navigateTo(.settings)
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
    
    func pushSettingsAccount() {
        navigateTo(.settingsAccount)
    }
   
    func pushSettingsSavingPlans() {
        navigateTo(.settingsSavingPlans)
    }
    
    func pushSettingsBudget() {
        navigateTo(.settingsBudget)
    }
    
    func pushSettingsCredits() {
        navigateTo(.settingsCredits)
    }
    
    func pushSettingsDangerZone() {
        navigateTo(.settingsDangerZone)
    }
    
    
    // Present
    func presentPaywall() {
        presentSheet(.paywall)
    }
    
    func presentCreateAccount() {
        presentSheet(.createAccount)
    }
    
    func presentCreateAutomation() {
        presentSheet(.createAutomation)
    }
    
    func presentCreateBudget() {
        presentSheet(.createBudget)
    }
    
    func presentCreateSavingsPlan(savingsPlan: SavingsPlanModel? = nil, dismissAction: (() -> Void)? = nil) {
        presentSheet(.createSavingsPlan(savingsPlan: savingsPlan), dismissAction)
    }
    
    func presentCreateTransaction(transaction: TransactionModel? = nil, dismissAction: (() -> Void)? = nil) {
        presentSheet(.createTransaction(transaction: transaction), dismissAction)
    }
    
    func presentRecoverTransaction() {
        presentSheet(.recoverTransaction)
    }
    
    func presentCreateSavingsAccount() {
        presentSheet(.createSavingsAccount)
    }
    
    func presentCreateTransfer() {
        presentSheet(.createTransfer)
    }
    
    func presentSelectCategory(category: Binding<PredefinedCategory?>, subcategory: Binding<PredefinedSubcategory?>) {
        presentSheet(.selectCategory(category: category, subcategory: subcategory))
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
            case .filter:
                NewFilterView()
                
            case .home:
                HomeView()
            case .homeSavingPlans:
                SavingPlansHomeView()
            case .homeAutomations:
                AutomationsHomeView()
                
            case .analytics:
                AnalyticsHomeView()
                
            case .createAccount:
                CreateAccountView()
            case .createAutomation:
                CreateAutomationView()
            case .createBudget:
                CreateBudgetView()
            case .createSavingsPlan(let savingsPlan):
                CreateSavingPlansView(savingsPlan: savingsPlan)
            case .createTransaction(let transaction):
                CreateTransactionView(transaction: transaction)
            case .recoverTransaction:
                RecoverTransactionView()
            case .createSavingsAccount:
                CreateSavingsAccountView()
            case .createTransfer:
                CreateTransferView()
                
                
            case .selectCategory(let category, let subcategory):
                SelectCategoryView(selectedCategory: category, selectedSubcategory: subcategory)
                
                
            case .allTransactions:
                RecentTransactionsView()
            case .transactionDetail(let transaction):
                TransactionDetailView(transaction: transaction)
                
                
            case .savingPlansDetail(let savingsPlan):
                SavingPlanDetailView(savingsPlan: savingsPlan)
                
                
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
                
            case .paywall:
                PaywallScreenView()
                
            case .settings:
                SettingsHomeView()
            case .settingsGeneral:
                SettingsGeneralView()
            case .settingsSecurity:
                SettingsSecurityView()
            case .settingsAppearence:
                SettingsAppearenceView()
            case .settingsDisplay:
                SettingsDisplayView()
            case .settingsAccount:
                SettingsAccountView()
            case .settingsSavingPlans:
                SettingsSavingPlansView()
            case .settingsBudget:
                SettingsBudgetView()
            case .settingsCredits:
                SettingsCreditsView()
            case .settingsDangerZone:
                SettingsDangerZoneView()
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
