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
    case update(savingsplanID: Int, contributionID: Int, body: ContributionModel)
    case delete(savingsplanID: Int, contributionID: Int)
}

extension ContributionAPIRequester {
    var path: String {
        switch self {
        case .fetch(let savingsplanID):
            return NetworkPath.Contribution.base(savingsplanID: savingsplanID)
        case .create(let savingsplanID, _):
            return NetworkPath.Contribution.base(savingsplanID: savingsplanID)
        case .update(let savingsplanID, let contributionID, _):
            return NetworkPath.Contribution.update(savingsplanID: savingsplanID, id: contributionID)
        case .delete(let savingsplanID, let contributionID):
            return NetworkPath.Contribution.delete(savingsplanID: savingsplanID, id: contributionID)
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
        case .fetch:                    return nil
        case .create(_, let body):      return try? JSONEncoder().encode(body)
        case .update(_, _, let body):   return try? JSONEncoder().encode(body)
        case .delete:                   return nil
        }
    }
}
