//
//  SubscriptionAPIRequester.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation

enum SubscriptionAPIRequester: APIRequestBuilder {
    case fetch(accountID: Int)
    case create(accountID: Int, body: SubscriptionModel)
    case update(subscriptionID: Int, body: SubscriptionModel)
    case delete(subscriptionID: Int)
}

extension SubscriptionAPIRequester {
    var path: String {
        switch self {
        case .fetch:                            return NetworkPath.Subscription.base
        case .create:                           return NetworkPath.Subscription.base
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
        switch self {
        case .fetch(let accountID):     return [URLQueryItem(name: "accountID", value: String(accountID))]
        case .create(let accountID, _): return [URLQueryItem(name: "accountID", value: String(accountID))]
        case .update:                   return nil
        case .delete:                   return nil
        }
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
