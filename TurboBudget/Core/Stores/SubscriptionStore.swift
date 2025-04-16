//
//  SubscriptionStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation
import NetworkKit

final class SubscriptionStore: ObservableObject {
    static let shared = SubscriptionStore()
    
    @Published var subscriptions: [SubscriptionModel] = []
    
    var subscriptionsByMonth: [Date: [SubscriptionModel]] {
        let groupedByMonth = Dictionary(grouping: subscriptions) { subscription in
            Calendar.current.date(from: Calendar.current.dateComponents([.month, .year], from: subscription.date))!
        }
        
        return groupedByMonth
            .sorted { $0.key > $1.key }
            .reduce(into: [Date: [SubscriptionModel]]()) { result, entry in
                result[entry.key] = entry.value
            }
    }
}

extension SubscriptionStore {
    
    @MainActor
    func fetchSubscriptions(accountID: Int) async {
        do {
            self.subscriptions = try await SubscriptionService.fetchAll(for: accountID)
            sortSubscriptionsByDate()
        } catch { NetworkService.handleError(error: error) }
    }
    
    @discardableResult
    @MainActor
    func createSubscription(accountID: Int, body: SubscriptionModel, shouldReturn: Bool = false) async -> SubscriptionModel? {
        do {
            let subscription = try await SubscriptionService.create(accountID: accountID, body: body)
            self.subscriptions.append(subscription)
            sortSubscriptionsByDate()
            return shouldReturn ? subscription : nil
        } catch {
            NetworkService.handleError(error: error)
            return nil
        }
    }
    
    @discardableResult
    @MainActor
    func updateSubscription(subscriptionID: Int, body: SubscriptionModel) async -> SubscriptionModel? {
        do {
            let subscription = try await SubscriptionService.update(subscriptionID: subscriptionID, body: body)
            if let index = self.subscriptions.firstIndex(where: { $0.id == subscriptionID }) {
                self.subscriptions[index] = subscription
                sortSubscriptionsByDate()
            }
            return subscription
        } catch {
            NetworkService.handleError(error: error)
            return nil
        }
    }
    
    @MainActor
    func deleteSubscription(subscriptionID: Int) async {
        do {
            try await SubscriptionService.delete(subscriptionID: subscriptionID)
            if let index = self.subscriptions.firstIndex(where: { $0.id == subscriptionID }) {
                self.subscriptions.remove(at: index)
            }
        } catch { NetworkService.handleError(error: error) }
    }
    
}

extension SubscriptionStore {
    
    func reset() {
        subscriptions.removeAll()
    }
    
}
