//
//  TransferAPIRequester.swift
//  CashFlow
//
//  Created by Theo Sementa on 30/11/2024.
//

import Foundation
import NetworkKit

enum TransferAPIRequester: APIRequestBuilder {
    case transfer(senderAccountID: Int, receiverAccountID: Int, body: TransferBody)
    case delete(transferID: Int)
}

extension TransferAPIRequester {
    var path: String {
        switch self {
        case .transfer(let senderAccountIDD, let receiverAccountID, _):
            return NetworkPath.Transfer.doTransfer(senderAccountID: senderAccountIDD, receiverAccountID: receiverAccountID)
        case .delete(let transferID):
            return NetworkPath.Transfer.delete(id: transferID)
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .transfer: return .POST
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
        case .transfer(_, _, let body): return try? JSONEncoder().encode(body)
        default: return nil
        }
    }
}
