//
//  SubscriptionRepository.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation

final class SubscriptionRepository: ObservableObject {
    static let shared = SubscriptionRepository()
    
    @Published var subscriptions: [SubscriptionModel] = []
}

extension SubscriptionRepository {
    
    @MainActor
    func fetchSubscriptions(accountID: Int) async {
        do {
            let subscriptions = try await NetworkService.shared.sendRequest(
                apiBuilder: SubscriptionAPIRequester.fetch(accountID: accountID),
                responseModel: [SubscriptionModel].self
            )
            self.subscriptions = subscriptions
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func createSubscription(accountID: Int, body: SubscriptionModel) async {
        do {
            let subscription = try await NetworkService.shared.sendRequest(
                apiBuilder: SubscriptionAPIRequester.create(accountID: accountID, body: body),
                responseModel: SubscriptionModel.self
            )
            self.subscriptions.append(subscription)
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func updateSubscription(subscriptionID: Int, body: SubscriptionModel) async {
        do {
            let subscription = try await NetworkService.shared.sendRequest(
                apiBuilder: SubscriptionAPIRequester.update(subscriptionID: subscriptionID, body: body),
                responseModel: SubscriptionModel.self
            )
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func deleteSubscription(subscriptionID: Int) async {
        do {
            try await NetworkService.shared.sendRequest(
                apiBuilder: SubscriptionAPIRequester.delete(subscriptionID: subscriptionID)
            )
            self.subscriptions.removeAll(where: { $0.id == subscriptionID })
        } catch { NetworkService.handleError(error: error) }
    }
    
}
