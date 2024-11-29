//
//  AlertManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/08/2024.
//

import Foundation

struct AlertData {
    let title: String
    let message: String
    var actionButtonTitle: String? = nil
    let action: () -> Void
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
            actionButtonTitle: "alert_cashflow_pro_see".localized,
            action: { self.router.presentPaywall() }
        )
    }
    
}
