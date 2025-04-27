//
//  SubscriptionAPIRequester.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation
import NetworkKit

enum SubscriptionAPIRequester: APIRequestBuilder {
    case fetch(accountID: Int)
    case create(accountID: Int, body: SubscriptionDTO)
    case update(subscriptionID: Int, body: SubscriptionDTO)
    case delete(subscriptionID: Int)
}

extension SubscriptionAPIRequester {
    var path: String {
        switch self {
        case .fetch(let accountID):             return NetworkPath.Subscription.base(accountID: accountID)
        case .create(let accountID, _):         return NetworkPath.Subscription.base(accountID: accountID)
        case .update(let subscriptionID, _):    return NetworkPath.Subscription.update(id: subscriptionID)
        case .delete(let subscriptionID):       return NetworkPath.Subscription.delete(id: subscriptionID)
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetch:    return .GET
        case .create:   return .POST
        case .update:   return .PUT
        case .delete:   return .DELETE
        }
    }
    
    var parameters: [URLQueryItem]? {
        return nil
    }
    
    var isTokenNeeded: Bool {
        return true
    }
    
    var body: Data? {
        switch self {
        case .fetch:                return nil
        case .create(_, let body):  return try? JSONEncoder().encode(body)
        case .update(_, let body):  return try? JSONEncoder().encode(body)
        case .delete:               return nil
        }
    }
}
