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
    case delete(accountID: Int, cardID: UUID)
}

extension CreditCardAPIRequester {
    var path: String {
        switch self {
        case .fetch(let accountID):                 return NetworkPath.CreditCard.base(accountID: accountID)
        case .create(let accountID, _):             return NetworkPath.CreditCard.base(accountID: accountID)
        case .delete(let accountID, let cardID):    return NetworkPath.CreditCard.delete(accountID: accountID, creditCardID: cardID)
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
        return nil
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
