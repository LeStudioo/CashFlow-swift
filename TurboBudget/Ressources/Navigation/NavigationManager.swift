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
    
    func pushHomeSavingPlans(account: Account) {
        navigateTo(.homeSavingPlans(account: account))
    }
    
    func pushHomeAutomations(account: Account) {
        navigateTo(.homeAutomations(account: account))
    }
    
    
    func pushAllTransactions(account: Account) {
        navigateTo(.allTransactions(account: account))
    }
    
    func pushTransactionDetail(transaction: Transaction) {
        navigateTo(.transactionDetail(transaction: transaction))
    }
    
    
    func pushSavingPlansDetail(savingPlan: SavingPlan) {
        navigateTo(.savingPlansDetail(savingPlan: savingPlan))
    }
    
    
    func pushAccountDashboard(account: Account) {
        navigateTo(.accountDashboard(account: account))
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
    
    
    func pushSettings(account: Account) {
        navigateTo(.settings(account: account))
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
    
    func pushSettingsDangerZone(account: Account) {
        navigateTo(.settingsDangerZone(account: account))
    }
    
    
    // Present
    func presentPaywall() {
        presentSheet(.paywall)
    }
    
    func presentCreateAutomation() {
        presentSheet(.createAutomation)
    }
    
    func presentCreateBudget() {
        presentSheet(.createBudget)
    }
    
    func presentCreateSavingPlans() {
        presentSheet(.createSavingPlans)
    }
    
    func presentCreateTransaction() {
        presentSheet(.createTransaction)
    }
    
    func presentRecoverTransaction() {
        presentSheet(.recoverTransaction)
    }
    
    func presentCreateSavingsAccount() {
        presentSheet(.createSavingsAccount)
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
                
            case .home(let account):
                HomeScreenView(router: router(route: route), account: account)
            case .homeSavingPlans(let account):
                SavingPlansHomeView(router: router(route: route), account: account)
            case .homeAutomations(let account):
                AutomationsHomeView(account: account)
                
                
            case .createAutomation:
                CreateAutomationView(router: router(route: route))
            case .createBudget:
                CreateBudgetView(router: router(route: route))
            case .createSavingPlans:
                CreateSavingPlansView(router: router(route: route))
            case .createTransaction:
                CreateTransactionView(router: router(route: route))
            case .recoverTransaction:
                RecoverTransactionView()
            case .createSavingsAccount:
                CreateSavingsAccountView()
                
                
            case .selectCategory(let category, let subcategory):
                SelectCategoryView(selectedCategory: category, selectedSubcategory: subcategory)
                
                
            case .allTransactions(let account):
                RecentTransactionsView(router: router(route: route), account: account)
            case .transactionDetail(let transaction):
                TransactionDetailView(transaction: transaction)
                
                
            case .savingPlansDetail(let savingPlan):
                SavingPlanDetailView(savingPlan: savingPlan)
                
                
            case .accountDashboard(let account):
                AccountDashboardView(router: router(route: route), account: account)
            case .savingsAccountDetail(let savingsAccount):
                SavingsAccountDetailView(savingsAccount: savingsAccount)
            case .allSavingsAccount:
                SavingsAccountHomeView(router: router(route: route))
            case .allBudgets:
                BudgetsHomeView(router: router(route: route))
            case .budgetTransactions(let subcategory):
                BudgetsTransactionsView(router: router(route: route), subcategory: subcategory)
            case .allArchivedSavingPlans(let account):
                ArchivedSavingPlansView(router: router(route: route), account: account)
                
            case .homeCategories:
                CategoriesHomeView(router: router(route: route))
            case .categoryTransactions(let category):
                CategoryTransactionsView(router: router(route: route), category: category)
            case .homeSubcategories(let category):
                SubcategoryHomeView(router: router(route: route), category: category)
            case .subcategoryTransactions(let subcategory):
                SubcategoryTransactionsView(router: router(route: route), subcategory: subcategory)
                
            case .paywall:
                PaywallScreenView()
                
            case .settings(let account):
                SettingsHomeView(router: router(route: route), account: account)
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
            case .settingsDangerZone(let account):
                SettingsDangerZoneView(account: account)
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
