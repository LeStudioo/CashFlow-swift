//
//  BudgetAPIRequester.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation

enum BudgetAPIRequester: APIRequestBuilder {
    case fetch(accountID: Int)
    case create(accountID: Int, body: BudgetModel)
    case update(budgetID: Int, body: BudgetModel)
    case delete(budgetID: Int)
}

extension BudgetAPIRequester {
    var path: String {
        switch self {
        case .fetch(let accountID):     return NetworkPath.Budget.base(accountID: accountID)
        case .create(let accountID, _): return NetworkPath.Budget.base(accountID: accountID)
        case .update(let budgetID, _):  return NetworkPath.Budget.update(id: budgetID)
        case .delete(let budgetID):     return NetworkPath.Budget.delete(id: budgetID)
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
