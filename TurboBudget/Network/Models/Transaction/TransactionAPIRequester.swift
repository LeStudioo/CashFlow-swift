//
//  TransactionAPIRequester.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

import Foundation

enum TransactionAPIRequester: APIRequestBuilder {
    case fetch(accountID: Int)
    case fetchWithPagination(accountID: Int, perPage: Int, skip: Int)
    case create(accountID: Int, body: TransactionModel)
    case update(id: Int, body: TransactionModel)
    case delete(id: Int)
}

extension TransactionAPIRequester {
    var path: String {
        switch self {
        case .fetch(let accountID):                     return NetworkPath.Transaction.base(accountID: accountID)
        case .fetchWithPagination(let accountID, _, _): return NetworkPath.Transaction.base(accountID: accountID)
        case .create(let accountID, _):                 return NetworkPath.Transaction.base(accountID: accountID)
        case .update(let id, _):                        return NetworkPath.Transaction.update(id: id)
        case .delete(let id):                           return NetworkPath.Transaction.delete(id: id)
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetch:    return .GET
        case .fetchWithPagination: return .GET
        case .create:   return .POST
        case .update:   return .PUT
        case .delete:   return .DELETE
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .fetchWithPagination(_, let perPage, let skip):
            return [
                .init(name: "perPage", value: "\(perPage)"),
                .init(name: "skip", value: "\(skip)")
            ]
        default:  return nil
        }
    }
    
    var isTokenNeeded: Bool {
        return true
    }
    
    var body: Data? {
        switch self {
        case .create( _, let body):     return try? JSONEncoder().encode(body)
        case .update(_, let body):      return try? JSONEncoder().encode(body)
        default:                        return nil
        }
    }
}
