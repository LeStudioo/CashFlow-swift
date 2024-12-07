//
//  AlertManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/08/2024.
//

import Foundation

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
    
}

// MARK: - Deletation
extension AlertManager {
    
    func deleteTransaction(transaction: TransactionModel) {
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
