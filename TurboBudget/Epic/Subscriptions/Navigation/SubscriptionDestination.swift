//
//  SubscriptionDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import NavigationKit

enum SubscriptionDestination: AppDestinationProtocol {
    case list
    case create
    case update(subscription: SubscriptionModel)
    case detail(subscriptionId: Int)
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .list:
            SubscriptionsListScreen()
        case .create:
            CreateSubscriptionScreen()
        case .update(let subscription):
            CreateSubscriptionScreen(subscription: subscription)
        case .detail(let subscriptionId):
            SubscriptionDetailScreen(subscriptionId: subscriptionId)
        }
    }
    
}
