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
    case detail(subscription: SubscriptionModel)
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .list:
            SubscriptionHomeView()
        case .create:
            CreateSubscriptionView()
        case .update(let subscription):
            CreateSubscriptionView(subscription: subscription)
        case .detail(let subscription):
            SubscriptionDetailView(subscription: subscription)
        }
    }
    
}
