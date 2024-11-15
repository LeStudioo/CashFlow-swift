//
//  ContributionAPIRequester.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation

enum ContributionAPIRequester: APIRequestBuilder {
    case fetch(savingsplanID: Int)
    case create(savingsplanID: Int, body: ContributionModel)
    case update(contributionID: Int, body: ContributionModel)
    case delete(contributionID: Int)
}

extension ContributionAPIRequester {
    var path: String {
        switch self {
        case .fetch:                            return NetworkPath.Contribution.base
        case .create:                           return NetworkPath.Contribution.base
        case .update(let contributionID, _):    return NetworkPath.Contribution.update(id: contributionID)
        case .delete(let contributionID):       return NetworkPath.Contribution.delete(id: contributionID)
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
        case .fetch(let savingsplanID):     return [URLQueryItem(name: "savingsplanID", value: String(savingsplanID))]
        case .create(let savingsplanID, _): return [URLQueryItem(name: "savingsplanID", value: String(savingsplanID))]
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
