//
//  CreditCardAPIRequester.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation

enum CreditCardAPIRequester: APIRequestBuilder {
    case fetch(accountID: Int)
    case create(accountID: Int, cardUUID: UUID)
    case delete(cardID: Int)
}

extension CreditCardAPIRequester {
    var path: String {
        switch self {
        case .fetch:                return NetworkPath.CreditCard.base
        case .create:               return NetworkPath.CreditCard.base
        case .delete(let cardID):   return NetworkPath.CreditCard.delete(id: cardID)
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetch:    return .GET
        case .create:   return .POST
        case .delete:   return .DELETE
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .fetch(let accountID):     return [URLQueryItem(name: "accountID", value: String(accountID))]
        case .create(let accountID, _): return [URLQueryItem(name: "accountID", value: String(accountID))]
        case .delete:                   return nil
        }
    }
    
    var isTokenNeeded: Bool {
        return true
    }
    
    var body: Data? {
        switch self {
        case .fetch:                    return nil
        case .create(_ ,let cardUUID):  return try? JSONEncoder().encode(["uuid": cardUUID.uuidString])
        case .delete:                   return nil
        }
    }
}
