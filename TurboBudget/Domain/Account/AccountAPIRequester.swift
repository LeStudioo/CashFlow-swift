//
//  AccountAPIRequester.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

import Foundation

enum AccountAPIRequester: APIRequestBuilder {
    case fetch
    case create(body: AccountModel)
    case update(accountID: Int, body: AccountModel)
    case delete(accountID: Int)
    case cashflow(accountID: Int, year: Int)
    case stats(accountID: Int, withSavings: Bool)
}

extension AccountAPIRequester {
    var path: String {
        switch self {
        case .fetch:                return NetworkPath.Account.base
        case .create:               return NetworkPath.Account.base
        case .update(let id, _):    return NetworkPath.Account.update(id: id)
        case .delete(let id):       return NetworkPath.Account.delete(id: id)
        case .cashflow(let id, let year): return NetworkPath.Account.cashflow(id: id, year: year)
        case .stats(let accountID, let withSavings): return NetworkPath.Account.stats(id: accountID, withSavings: withSavings)
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetch:    return .GET
        case .create:    return .POST
        case .update:   return .PUT
        case .delete:   return .DELETE
        case .cashflow:  return .GET
        case .stats:    return .GET
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
        case .fetch:                        return nil
        case .create(let body):             return try? JSONEncoder().encode(body)
        case .update(_, body: let body):    return try? JSONEncoder().encode(body)
        case .delete:                       return nil
        case .cashflow:                     return nil
        case .stats:                        return nil
        }
    }
}
