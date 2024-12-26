//
//  SubscriptionStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation

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
            let subscriptions = try await NetworkService.shared.sendRequest(
                apiBuilder: SubscriptionAPIRequester.fetch(accountID: accountID),
                responseModel: [SubscriptionModel].self
            )
            self.subscriptions = subscriptions
            sortSubscriptionsByDate()
        } catch { NetworkService.handleError(error: error) }
    }
    
    @discardableResult
    @MainActor
    func createSubscription(accountID: Int, body: SubscriptionModel, shouldReturn: Bool = false) async -> SubscriptionModel? {
        do {
            let subscription = try await NetworkService.shared.sendRequest(
                apiBuilder: SubscriptionAPIRequester.create(accountID: accountID, body: body),
                responseModel: SubscriptionModel.self
            )
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
            let subscription = try await NetworkService.shared.sendRequest(
                apiBuilder: SubscriptionAPIRequester.update(subscriptionID: subscriptionID, body: body),
                responseModel: SubscriptionModel.self
            )
            if let index = self.subscriptions.map(\.id).firstIndex(of: subscriptionID) {
                self.subscriptions[index].name = subscription.name
                self.subscriptions[index].amount = subscription.amount
                self.subscriptions[index].frequencyDate = subscription.frequencyDate
                self.subscriptions[index].frequencyNum = subscription.frequencyNum
                self.subscriptions[index].categoryID = subscription.categoryID
                self.subscriptions[index].subcategoryID = subscription.subcategoryID
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
            try await NetworkService.shared.sendRequest(
                apiBuilder: SubscriptionAPIRequester.delete(subscriptionID: subscriptionID)
            )
            self.subscriptions.removeAll(where: { $0.id == subscriptionID })
        } catch { NetworkService.handleError(error: error) }
    }
    
}
