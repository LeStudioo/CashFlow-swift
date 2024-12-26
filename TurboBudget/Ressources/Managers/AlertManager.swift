//
//  AlertManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/08/2024.
//

import Foundation
import AlertKit
import SwiftUI

extension AlertManager {
    
    func showPaywall(router: NavigationManager) {
        self.present(
            title: "alert_cashflow_pro_title".localized,
            message: "alert_cashflow_pro_desc".localized,
            buttonTitle: "alert_cashflow_pro_see".localized,
            isDestructive: false,
            action: {
                router.presentPaywall()
            }
        )
    }
    
    func onlyOneCreditCardByAccount() {
        self.present(
            title: Word.CreditCard.maxCard,
            message: Word.CreditCard.maxCardMessage
        )
    }
    
}

extension AlertManager {
    
    func signOut() {
        self.present(
            title: Word.Classic.disconnect + " ?",
            message: "",
            buttonTitle: Word.Classic.disconnect,
            isDestructive: true,
            action: {
                await UserStore.shared.signOut()
            }
        )
    }
    
    func deleteUser() {
        self.present(
            title: "user_delete_account_title".localized,
            message: "user_delete_account_message".localized,
            buttonTitle: Word.Classic.delete,
            isDestructive: true,
            action: {
                await UserStore.shared.deleteAccount()
            }
        )
    }
    
}
        
// MARK: - Deletation
extension AlertManager {
    
    func deleteAccount(account: AccountModel, dismissAction: DismissAction? = nil) {
        self.present(
            title: "account_detail_delete_account".localized,
            message: "account_detail_delete_account_desc".localized,
            buttonTitle: Word.Classic.delete,
            isDestructive: true,
            action: {
                if let accountID = account.id {
                    await AccountStore.shared.deleteAccount(accountID: accountID)
                    if let dismissAction { dismissAction() }
                }
            }
        )
    }
    
    func deleteTransaction(transaction: TransactionModel, dismissAction: DismissAction? = nil) {
        self.present(
            title: Word.Delete.Transaction.title,
            message: transaction.type == .expense ? Word.Delete.Transaction.expenseMessage : Word.Delete.Transaction.incomeMessage,
            buttonTitle: Word.Classic.delete,
            isDestructive: true,
            action: {
                if let transactionID = transaction.id {
                    await TransactionStore.shared.deleteTransaction(transactionID: transactionID)
                    if let dismissAction { dismissAction() }
                }
            }
        )
    }
    
    func deleteSubscription(subscription: SubscriptionModel, dismissAction: DismissAction? = nil) {
        self.present(
            title: Word.Delete.Subscription.title,
            message: Word.Delete.Subscription.message,
            buttonTitle: Word.Classic.delete,
            isDestructive: true,
            action: {
                if let subscriptionID = subscription.id {
                    await SubscriptionStore.shared.deleteSubscription(subscriptionID: subscriptionID)
                    if let dismissAction { dismissAction() }
                }
            }
        )
    }
    
    func deleteSavingsPlan(savingsPlan: SavingsPlanModel, dismissAction: DismissAction? = nil) {
        self.present(
            title: "savingsplan_detail_delete_savingsplan".localized,
            message: "savingsplan_detail_delete_savingsplan_desc".localized,
            buttonTitle: Word.Classic.delete,
            isDestructive: true,
            action: {
                if let savingsPlanID = savingsPlan.id {
                    await SavingsPlanStore.shared.deleteSavingsPlan(savingsPlanID: savingsPlanID)
                    if let dismissAction { dismissAction() }
                }
            }
        )
    }
    
    func deleteContribution(savingsPlan: SavingsPlanModel, contribution: ContributionModel) {
        self.present(
            title: Word.Delete.Contribution.title,
            message: Word.Delete.Contribution.message,
            buttonTitle: Word.Classic.delete,
            isDestructive: true,
            action: {
                if let contributionID = contribution.id, let savingsPlanID = savingsPlan.id {
                    await ContributionStore.shared.deleteContribution(
                        savingsplanID: savingsPlanID,
                        contributionID: contributionID
                    )
                }
            }
        )
    }
    
}
