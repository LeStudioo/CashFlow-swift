//
//  AlertManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/08/2024.
//

import Foundation
import SwiftUI

struct AlertData {
    
    struct ActionButton {
        var title: String
        var isDestructive: Bool
        var action: () async -> Void
    }
    
    let title: String
    let message: String
    var actionButton: ActionButton?
}

final class AlertManager: ObservableObject {
    
    // builder
    var router: NavigationManager
    
    @Published var isPresented: Bool = false
    @Published var alert: AlertData? = nil
    
    // init
    init(router: NavigationManager) {
        self.router = router
    }
}

extension AlertManager {
    
    func showPaywall() {
        self.isPresented = true
        self.alert = .init(
            title: "alert_cashflow_pro_title".localized,
            message: "alert_cashflow_pro_desc".localized,
            actionButton: .init(
                title: "alert_cashflow_pro_see".localized,
                isDestructive: false,
                action: { self.router.presentPaywall() }
            )
        )
    }
    
    func onlyOneCreditCardByAccount() {
        self.isPresented = true
        self.alert = .init(
            title: Word.CreditCard.maxCard,
            message: Word.CreditCard.maxCardMessage
        )
    }
    
}

extension AlertManager {
    
    func signOut() {
        self.isPresented = true
        self.alert = .init(
            title: Word.Classic.disconnect + " ?",
            message: "",
            actionButton: .init(
                title: Word.Classic.disconnect,
                isDestructive: true,
                action: {
                    await UserRepository.shared.signOut()
                }
            )
        )
    }
    
    func deleteUser() {
        self.isPresented = true
        self.alert = .init(
            title: "user_delete_account_title".localized,
            message: "user_delete_account_message".localized,
            actionButton: .init(
                title: Word.Classic.delete,
                isDestructive: true,
                action: {
                    await UserRepository.shared.deleteAccount()
                }
            )
        )
    }
    
}
        

// MARK: - Deletation
extension AlertManager {
    
    func deleteAccount(account: AccountModel, dismissAction: DismissAction? = nil) {
        self.isPresented = true
        self.alert = .init(
            title: "account_detail_delete_account".localized,
            message: "account_detail_delete_account_desc".localized,
            actionButton: .init(
                title: Word.Classic.delete,
                isDestructive: true,
                action: {
                    if let accountID = account.id {
                        await AccountRepository.shared.deleteAccount(accountID: accountID)
                        if let dismissAction { await dismissAction() }
                    }
                }
            )
        )
    }
    
    func deleteTransaction(transaction: TransactionModel, dismissAction: DismissAction? = nil) {
        self.isPresented = true
        self.alert = .init(
            title: Word.Delete.Transaction.title,
            message: transaction.type == .expense ? Word.Delete.Transaction.expenseMessage : Word.Delete.Transaction.incomeMessage,
            actionButton: .init(
                title: Word.Classic.delete,
                isDestructive: true,
                action: {
                    if let transactionID = transaction.id {
                        await TransactionRepository.shared.deleteTransaction(transactionID: transactionID)
                        if let dismissAction { await dismissAction() }
                    }
                }
            )
        )
    }
    
    func deleteSubscription(subscription: SubscriptionModel) {
        self.isPresented = true
        self.alert = .init(
            title: Word.Delete.Subscription.title,
            message: Word.Delete.Subscription.message,
            actionButton: .init(
                title: Word.Classic.delete,
                isDestructive: true,
                action: {
                    if let subscriptionID = subscription.id {
                        await SubscriptionRepository.shared.deleteSubscription(subscriptionID: subscriptionID)
                    }
                }
            )
        )
    }
    
    func deleteSavingsPlan(savingsPlan: SavingsPlanModel, dismissAction: DismissAction? = nil) {
        self.isPresented = true
        self.alert = .init(
            title: "savingsplan_detail_delete_savingsplan".localized,
            message: "savingsplan_detail_delete_savingsplan_desc".localized,
            actionButton: .init(
                title: Word.Classic.delete,
                isDestructive: true,
                action: {
                    if let savingsPlanID = savingsPlan.id {
                        await SavingsPlanRepository.shared.deleteSavingsPlan(savingsPlanID: savingsPlanID)
                        if let dismissAction { await dismissAction() }
                    }
                }
            )
        )
    }
    
    func deleteContribution(savingsPlan: SavingsPlanModel, contribution: ContributionModel) {
        self.isPresented = true
        self.alert = .init(
            title: Word.Delete.Contribution.title,
            message: Word.Delete.Contribution.message,
            actionButton: .init(
                title: Word.Classic.delete,
                isDestructive: true,
                action: {
                    if let contributionID = contribution.id, let savingsPlanID = savingsPlan.id {
                        await ContributionRepository.shared.deleteContribution(
                            savingsplanID: savingsPlanID,
                            contributionID: contributionID
                        )
                    }
                }
            )
        )
    }
    
}
