//
//  EventKeys.swift
//  CashFlow
//
//  Created by Theo Sementa on 01/05/2025.
//

import Foundation

enum EventKeys: String {
    
    case appSession = "app_session"
    case appPaywall = "app_paywall"
    
    case userRegister = "user_register"
    case userPremium = "user_premium"
    case userLogout = "user_logout"
    case userDeleted = "user_deleted"
    
    case paywallDetailPrediction = "paywall_detail_prediction"
    case paywallDetailBudgets = "paywall_detail_budgets"
    
    case preferenceSecurityBiometrie = "preference_security_biometrie"
    case preferenceSecurityReinforced = "preference_security_reinforced"
    case preferenceAppearanceTint = "preference_appearance_tint"
    case preferenceSubscriptionNotifications = "preference_subscription_notifications"
    case preferenceApplePayAutocat = "preference_applepay_autocat"
    case preferenceApplePayPosition = "preference_applepay_position"
    
    case settingsPage = "settingsPage"
    
    case accountClassicCreated = "account_classic_created"
    case accountClassicDeleted = "account_classic_deleted"
    case accountSavingsCreated = "account_savings_created"
    case accountSavingsDetailPage = "account_savings_detail_page"
    case accountSavingsDeleted = "account_savings_deleted"
    
    case autocatSuggestionAccepeted = "autocat_suggestion_accepted"
 
    case transactionCreated = "transaction_created"
    case transactionExpenseCreated = "transaction_expense_created"
    case transactionIncomeCreated = "transaction_income_created"
    case transactionCreatedApplePay = "transaction_created_applepay"
    case transactionNoteAdded = "transaction_note_added"
    case transactionUpdated = "transaction_updated"
    case transactionDeleted = "transaction_deleted"
    case transactionDetailPage = "transaction_detail_page"
    case transactionListPage = "transaction_list_page"
    case transactionListPagination = "transaction_list_pagination"
    case transactionCreationCanceled = "transaction_creation_canceled"
    case transactionUpdateCanceled = "transaction_update_canceled"
    
    case subscriptionCreated = "subscription_created"
    case subscriptionUpdated = "subscription_updated"
    case subscriptionDeleted = "subscription_deleted"
    case subscriptionDetailPage = "subscription_detail_page"
    case subscriptionListPage = "subscription_list_page"
    case subscriptionCreationCanceled = "subscription_creation_canceled"
    case subscriptionUpdateCanceled = "subscription_update_canceled"
    
    case sacingsPlanCreated = "savingsplan_created"
    case savingsPlanNoteAdded = "savingsplan_note_added"
    case savingsPlanUpdated = "savingsplan_updated"
    case savingsPlanDeleted = "savingsplan_deleted"
    case savingsplanDetailPage = "savingsplan_detail_page"
    case savingsplanListPage = "savingsplan_list_page"
    case savingsplanCreationCanceled = "savingsplan_creation_canceled"
    case savingsplanUpdateCanceled = "savingsplan_update_canceled"
    
    case contributionCreated = "contribution_created"
    case contributionUpdated = "contribution_updated"
    case contributionDeleted = "contribution_deleted"
    case contributionCreationCanceled = "contribution_creation_canceled"
    
    case budgetCreated = "budget_created"
    case budgetUpdated = "budget_updated"
    case budgetDeleted = "budget_deleted"
    case budgetCreationCanceled = "budget_creation_canceled"
    
    case creditcardCreated = "creditcard_created"
    case creditcardDeleted = "creditcard_deleted"
    case creditcardCreationCanceled = "creditcard_creation_canceled"
    
    case transferCreated = "transfer_created"
    case transferDeleted = "transfer_deleted"
    case transferDetailPage = "transfer_detail_page"
    case transferCreationCanceled = "transfer_creation_canceled"
}
