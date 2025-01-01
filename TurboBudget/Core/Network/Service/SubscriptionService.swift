//
//  SubscriptionService.swift
//  CashFlow
//
//  Created by Theo Sementa on 01/01/2025.
//

import Foundation

struct SubscriptionService {
    
    static func fetchAll(for accountID: Int) async throws -> [SubscriptionModel] {
        return try await NetworkService.shared.sendRequest(
            apiBuilder: SubscriptionAPIRequester.fetch(accountID: accountID),
            responseModel: [SubscriptionModel].self
        )
    }
    
    static func create(accountID: Int, body: SubscriptionModel) async throws -> SubscriptionModel {
        return try await NetworkService.shared.sendRequest(
            apiBuilder: SubscriptionAPIRequester.create(accountID: accountID, body: body),
            responseModel: SubscriptionModel.self
        )
    }
    
    static func update(subscriptionID: Int, body: SubscriptionModel) async throws -> SubscriptionModel {
        return try await NetworkService.shared.sendRequest(
            apiBuilder: SubscriptionAPIRequester.update(subscriptionID: subscriptionID, body: body),
            responseModel: SubscriptionModel.self
        )
    }
    
    static func delete(subscriptionID: Int) async throws {
        try await NetworkService.shared.sendRequest(
            apiBuilder: SubscriptionAPIRequester.delete(subscriptionID: subscriptionID)
        )
    }
    
}
