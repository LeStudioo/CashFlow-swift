//
//  SavingsPlanAPIRequester.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation

enum SavingsPlanAPIRequester: APIRequestBuilder {
    case fetch(accountID: Int)
    case create(accountID: Int, body: SavingsPlanModel)
    case update(savingsplanID: Int, body: SavingsPlanModel)
    case delete(savingsplanID: Int)
}

extension SavingsPlanAPIRequester {
    var path: String {
        switch self {
        case .fetch:                            return NetworkPath.SavingsPlan.base
        case .create:                           return NetworkPath.SavingsPlan.base
        case .update(let savingsplanID, _):     return NetworkPath.SavingsPlan.update(id: savingsplanID)
        case .delete(let savingsplanID):        return NetworkPath.SavingsPlan.delete(id: savingsplanID)
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetch: .GET
        case .create: .POST
        case .update: .PUT
        case .delete: .DELETE
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .fetch(let accountID):         return [URLQueryItem(name: "accountID", value: String(accountID))]
        case .create(let accountID, _):     return [URLQueryItem(name: "accountID", value: String(accountID))]
        case .update:                       return nil
        case .delete:                       return nil
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
