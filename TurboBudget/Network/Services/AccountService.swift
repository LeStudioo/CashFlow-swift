//
//  AccountService.swift
//  CashFlow
//
//  Created by Theo Sementa on 01/01/2025.
//

import Foundation
import NetworkKit

struct AccountService {
    
    static func fetchAll() async throws -> [AccountModel] {
        return try await NetworkService.sendRequest(
            apiBuilder: AccountAPIRequester.fetch,
            responseModel: [AccountModel].self
        )
    }
    
    static func create(body: AccountModel) async throws -> AccountModel {
        return try await NetworkService.sendRequest(
            apiBuilder: AccountAPIRequester.create(body: body),
            responseModel: AccountModel.self
        )
    }
    
    static func update(id: Int, body: AccountModel) async throws -> AccountModel {
        return try await NetworkService.sendRequest(
            apiBuilder: AccountAPIRequester.update(accountID: id, body: body),
            responseModel: AccountModel.self
        )
    }
    
    static func delete(id: Int) async throws {
        try await NetworkService.sendRequest(
            apiBuilder: AccountAPIRequester.delete(accountID: id)
        )
    }
    
}

extension AccountService {
    
    static func fetchCashFlow(id: Int, year: Int) async throws -> [Double] {
        return try await NetworkService.sendRequest(
            apiBuilder: AccountAPIRequester.cashflow(accountID: id, year: year),
            responseModel: [Double].self
        )
    }
    
    static func fetchStats(id: Int, withSavings: Bool) async throws -> StatisticsModel {
        return try await NetworkService.sendRequest(
            apiBuilder: AccountAPIRequester.stats(accountID: id, withSavings: withSavings),
            responseModel: StatisticsModel.self
        )
    }
    
}
