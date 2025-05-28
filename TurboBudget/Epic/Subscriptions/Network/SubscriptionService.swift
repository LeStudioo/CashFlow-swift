//
//  SubscriptionService.swift
//  CashFlow
//
//  Created by Theo Sementa on 01/01/2025.
//

import Foundation
import NetworkKit

struct SubscriptionService {
    
    static func fetchAll(for accountID: Int) async throws -> [SubscriptionModel] {
        return try await NetworkService.sendRequest(
            apiBuilder: SubscriptionAPIRequester.fetch(accountID: accountID),
            responseModel: [SubscriptionDTO].self
        ).compactMap { try $0.toModel() }
    }
    
    static func create(accountID: Int, body: SubscriptionDTO) async throws -> SubscriptionModel {
        return try await NetworkService.sendRequest(
            apiBuilder: SubscriptionAPIRequester.create(accountID: accountID, body: body),
            responseModel: SubscriptionDTO.self
        ).toModel()
    }
    
    static func update(subscriptionID: Int, body: SubscriptionDTO) async throws -> SubscriptionModel {
        return try await NetworkService.sendRequest(
            apiBuilder: SubscriptionAPIRequester.update(subscriptionID: subscriptionID, body: body),
            responseModel: SubscriptionDTO.self
        ).toModel()
    }
    
    static func delete(subscriptionID: Int) async throws {
        try await NetworkService.sendRequest(
            apiBuilder: SubscriptionAPIRequester.delete(subscriptionID: subscriptionID)
        )
    }
    
}
