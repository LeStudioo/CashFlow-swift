//
//  AlertManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/08/2024.
//  Localized with Toglee on 14/04/2025

import Foundation
import AlertKit
import SwiftUI
import NavigationKit

extension AlertManager {
    
    func showPaywall(router: Router<AppDestination>) {
        self.present(
            title: "alert_cashflow_pro_title".localized,
            message: "alert_cashflow_pro_desc".localized,
            buttonTitle: "alert_cashflow_pro_action_button".localized,
            isDestructive: false,
            action: {
                router.present(route: .sheet, .shared(.paywall))
            }
        )
    }

    func onlyOneCreditCardByAccount() {
        self.present(
            title: "alert_creditcard_title".localized,
            message: "alert_creditcard_message".localized
        )
    }
    
}

extension AlertManager {
    
    func signOut(dismiss: DismissAction) {
        self.present(
            title: "alert_signout_title".localized,
            message: "",
            buttonTitle: "alert_signout_action_button".localized,
            isDestructive: true,
            action: {
                await UserStore.shared.signOut()
                dismiss()
            }
        )
    }
    
    func deleteUser(dismiss: DismissAction) {
        self.present(
            title: "alert_user_account_delete_title".localized,
            message: "alert_user_account_delete_message".localized,
            buttonTitle: "word_delete".localized,
            isDestructive: true,
            action: {
                await UserStore.shared.deleteAccount()
                dismiss()
            }
        )
    }
    
}
        
// MARK: - Deletation
extension AlertManager {
    
    func deleteAccount(account: AccountModel, dismissAction: DismissAction? = nil) {
        self.present(
            title: "alert_account_delete_title".localized,
            message: "alert_account_delete_message".localized,
            buttonTitle: "word_delete".localized,
            isDestructive: true,
            action: {
                if let accountID = account._id {
                    await AccountStore.shared.deleteAccount(accountID: accountID)
                    if let dismissAction { dismissAction() }
                }
            }
        )
    }
    
    func deleteTransaction(transaction: TransactionModel, dismissAction: DismissAction? = nil) {
        self.present(
            title: "alert_transaction_delete_title".localized,
            message: transaction.type == .expense
            ? "alert_transaction_expense_message".localized
            : "alert_transaction_income_message".localized,
            buttonTitle: "word_delete".localized,
            isDestructive: true,
            action: {
                if let transactionID = transaction.id {
                    await TransactionStore.shared.deleteTransaction(transactionID: transactionID)
                    if let dismissAction { dismissAction() }
                }
            }
        )
    }
    
    func deleteTransfer(transfer: TransactionModel, dismissAction: DismissAction? = nil) {
        self.present(
            title: "alert_transfer_delete_title".localized,
            message: "alert_transfer_delete_message".localized,
            buttonTitle: "word_delete".localized,
            isDestructive: true,
            action: {
                if let transactionID = transfer.id {
                    await TransferStore.shared.deleteTransfer(transferID: transactionID)
                    if let dismissAction { dismissAction() }
                }
            }
        )
    }
    
    func deleteSubscription(subscription: SubscriptionModel, dismissAction: DismissAction? = nil) {
        self.present(
            title: "alert_subscription_delete_title".localized,
            message: "alert_subscription_delete_message".localized,
            buttonTitle: "word_delete".localized,
            isDestructive: true,
            action: {
                await SubscriptionStore.shared.deleteSubscription(subscriptionID: subscription.id)
                if let dismissAction { dismissAction() }
            }
        )
    }
    
    func deleteSavingsPlan(savingsPlan: SavingsPlanModel, dismissAction: DismissAction? = nil) {
        self.present(
            title: "alert_savingsplan_delete_title".localized,
            message: "alert_savingsplan_delete_message".localized,
            buttonTitle: "word_delete".localized,
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
            title: "alert_contribution_delete_title".localized,
            message: "alert_contribution_delete_message".localized,
            buttonTitle: "word_delete".localized,
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
