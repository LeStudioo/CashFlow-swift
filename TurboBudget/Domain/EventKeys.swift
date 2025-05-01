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
    
    case userPremium = "user_premium"
    case userLogout = "user_logout"
    
    case paywallDetailPrediction = "paywall_detail_prediction"
    case paywallDetailBudgets = "paywall_detail_budgets"
    
    case preferenceSecurityBiometrie = "preference_security_biometrie"
    case preferenceSecurityReinforced = "preference_security_reinforced"
    case preferenceAppearanceTint = "preference_appearance_tint"
    case preferenceSubscriptionNotifications = "preference_subscription_notifications"
    case preferenceApplePayAutocat = "preference_applepay_autocat"
    case preferenceApplePayPosition = "preference_applepay_position"
    
    case settingsPage = "settingsPage"
    
    case accountSavingsDetailPage = "account_savings_detail_page"
    
    case autocatSuggestionAccepeted = "autocat_suggestion_accepted"
 
    case transactionDetailPage = "transaction_detail_page"
    case transactionListPage = "transaction_list_page"
    case transactionCreationCanceled = "transaction_creation_canceled"
    case transactionUpdateCanceled = "transaction_update_canceled"
    
    case subscriptionDetailPage = "subscription_detail_page"
    case subscriptionListPage = "subscription_list_page"
    case subscriptionCreationCanceled = "subscription_creation_canceled"
    case subscriptionUpdateCanceled = "subscription_update_canceled"
    
    case savingsplanDetailPage = "savingsplan_detail_page"
    case savingsplanListPage = "savingsplan_list_page"
    case savingsplanCreationCanceled = "savingsplan_creation_canceled"
    case savingsplanUpdateCanceled = "savingsplan_update_canceled"
    
    case contributionCreationCanceled = "contribution_creation_canceled"
    
    case budgetCreationCanceled = "budget_creation_canceled"
    
    case creditcardCreationCanceled = "creditcard_creation_canceled"
    
    case transferDetailPage = "transfer_detail_page"
    case transferCreationCanceled = "transfer_creation_canceled"
}
