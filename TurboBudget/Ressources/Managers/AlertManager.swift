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
    
    func deleteTransaction(transaction: TransactionModel) {
        self.isPresented = true
        self.alert = .init(
            title: "transaction_detail_delete_transac".localized,
            message: transaction.type == .expense ? "transaction_detail_alert_if_expense".localized : "transaction_detail_alert_if_income".localized,
            actionButton: .init(
                title: "word_delete".localized,
                isDestructive: true,
                action: {
                    if let transactionID = transaction.id {
                        await TransactionRepository.shared.deleteTransaction(transactionID: transactionID)
                    }
                }
            )
        )
    }
    
}
