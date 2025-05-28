//
//  TransactionService.swift
//  CashFlow
//
//  Created by Theo Sementa on 01/01/2025.
//

import Foundation
import NetworkKit

struct TransactionService {
    
    static func fetchTransactionsByPeriod(
        accountID: Int,
        startDate: Date,
        endDate: Date,
        type: TransactionType? = nil
    ) async throws -> [TransactionModel] {
        return try await NetworkService.sendRequest(
            apiBuilder: TransactionAPIRequester.fetchByPeriod(
                accountID: accountID,
                startDate: startDate.toQueryParam(),
                endDate: endDate.toQueryParam(),
                type: type?.rawValue
            ),
            responseModel: [TransactionDTO].self
        ).map { try $0.toModel() }
    }
    
    static func create(accountID: Int, body: TransactionDTO) async throws -> TransactionResponseWithBalance {
        return try await NetworkService.sendRequest(
            apiBuilder: TransactionAPIRequester.create(accountID: accountID, body: body),
            responseModel: TransactionResponseWithBalance.self
        )
    }
    
    static func update(transactionID: Int, body: TransactionDTO) async throws -> TransactionResponseWithBalance {
        return try await NetworkService.sendRequest(
            apiBuilder: TransactionAPIRequester.update(id: transactionID, body: body),
            responseModel: TransactionResponseWithBalance.self
        )
    }
    
    static func delete(transactionID: Int) async throws -> TransactionResponseWithBalance {
        return try await NetworkService.sendRequest(
            apiBuilder: TransactionAPIRequester.delete(id: transactionID),
            responseModel: TransactionResponseWithBalance.self
        )
    }
    
}

extension TransactionService {
    
    /// transactionID is for exclude one transaction of research
    static func fetchRecommendedCategory(name: String, transactionID: Int? = nil) async throws -> TransactionFetchCategoryResponse {
        return try await NetworkService.sendRequest(
            apiBuilder: TransactionAPIRequester.fetchCategory(name: name, transactionID: transactionID),
            responseModel: TransactionFetchCategoryResponse.self
        )
    }
    
}
