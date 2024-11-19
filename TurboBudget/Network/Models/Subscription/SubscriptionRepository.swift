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
    
    @discardableResult
    @MainActor
    func createSubscription(accountID: Int, body: SubscriptionModel, shouldReturn: Bool = false) async -> SubscriptionModel?  {
        do {
            let subscription = try await NetworkService.shared.sendRequest(
                apiBuilder: SubscriptionAPIRequester.create(accountID: accountID, body: body),
                responseModel: SubscriptionModel.self
            )
            self.subscriptions.append(subscription)
            return shouldReturn ? subscription : nil
        } catch {
            NetworkService.handleError(error: error)
            return nil
        }
    }
    
    @MainActor
    func updateSubscription(subscriptionID: Int, body: SubscriptionModel) async {
        do {
            let subscription = try await NetworkService.shared.sendRequest(
                apiBuilder: SubscriptionAPIRequester.update(subscriptionID: subscriptionID, body: body),
                responseModel: SubscriptionModel.self
            )
            if let index = self.subscriptions.map(\.id).firstIndex(of: subscriptionID) {
                self.subscriptions[index] = subscription
            }
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
