//
//  AppRouterManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/04/2025.
//

import Foundation
import NavigationKit

final class AppRouterManager: ObservableObject {
    static let shared = AppRouterManager()
    private var routers: [AppTabs: Router<AppDestination>] = [:]
}

extension AppRouterManager {

    func register(router: Router<AppDestination>, for tab: AppTabs) {
        return routers[tab] = router
    }
    
    func router(for tab: AppTabs) -> Router<AppDestination>? {
        return routers[tab]
    }
    
    func resetRouters() {
        routers.removeAll()
    }
    
}

extension AppRouterManager {
    
    func navigateToTab(_ tab: AppTabs, then: @escaping () -> Void) {
        AppManager.shared.selectedTab = tab.rawValue
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            then()
        }
    }
    
    var isNavigationInProgress: Bool {
        return routers.values.map(\.isNavigationInProgress).contains(true)
    }
    
}
