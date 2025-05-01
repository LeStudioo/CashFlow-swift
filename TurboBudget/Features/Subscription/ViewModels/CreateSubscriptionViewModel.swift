//
//  CreateSubscriptionViewModel.swift
//  CashFlow
//
//  Created by KaayZenn on 02/11/2023.
//

import Foundation
import SwiftUI

class CreateSubscriptionViewModel: ObservableObject {
    let successfullModalManager: SuccessfullModalManager = .shared
    
    var subscription: SubscriptionModel?
    
    @Published var name: String = ""
    @Published var amount: String = ""
    @Published var frequencyDate: Date = .now
    @Published var type: TransactionType = .expense
    @Published var frequency: SubscriptionFrequency = .monthly
    @Published var selectedCategory: CategoryModel?
    @Published var selectedSubcategory: SubcategoryModel?
    
    @Published var presentingConfirmationDialog: Bool = false
    
    var isEditing: Bool {
        return subscription != nil
    }
    
    init(subscription: SubscriptionModel? = nil) {
        self.subscription = subscription
        if let subscription {
            self.name = subscription.name
            self.amount = subscription.amount.formatted()
            self.type = subscription.type
            self.frequency = subscription.frequency
            self.frequencyDate = subscription.frequencyDate
            self.selectedCategory = subscription.category
            self.selectedSubcategory = subscription.subcategory
        }
    }
    
}

extension CreateSubscriptionViewModel {
    
    func onChangeType(newValue: TransactionType) {
        if newValue == .income {
            selectedCategory = CategoryModel.revenue
            selectedSubcategory = nil
        } else if newValue == .expense && selectedCategory == CategoryModel.revenue {
            selectedCategory = nil
            selectedSubcategory = nil
        }
    }
    
    func bodyForCreation() -> SubscriptionDTO {
        return .init(
            name: name,
            amount: amount.toDouble(),
            type: type,
            frequency: frequency,
            frequencyDate: frequencyDate,
            categoryID: selectedCategory?.id ?? 0,
            subcategoryID: selectedSubcategory?.id
        )
    }
    
    func createNewSubscription(dismiss: DismissAction) async {
        let accountStore: AccountStore = .shared
        let subscriptionStore: SubscriptionStore = .shared
        let successfullModalManager: SuccessfullModalManager = .shared
        
        guard let account = accountStore.selectedAccount else { return }
        guard let accountID = account._id else { return }
        
        if let newSubscritpion = await subscriptionStore.createSubscription(
            accountID: accountID,
            body: bodyForCreation(),
            shouldReturn: true
        ) {
            await dismiss()
            await successfullModalManager.showSuccessfulSubscription(
                type: .new,
                subscription: newSubscritpion
            )
        }
    }
    
    func updateSubscription(dismiss: DismissAction) async {
        let subscriptionStore: SubscriptionStore = .shared
        
        if let subscription {
            if let updatedSubscription = await subscriptionStore.updateSubscription(
                subscriptionID: subscription.id,
                body: bodyForCreation()
            ) {
                await dismiss()
                await successfullModalManager.showSuccessfulSubscription(
                    type: .update,
                    subscription: updatedSubscription
                )
            }
        }
    }
    
}

// MARK: - Verification
extension CreateSubscriptionViewModel {
    
    func isAutomationInCreation() -> Bool {
        if selectedCategory != nil || selectedSubcategory != nil || !name.isBlank || amount.toDouble() != 0 {
            return true
        }
        return false
    }
    
    func validateAutomation() -> Bool {
        if !name.isBlank && amount.toDouble() != 0.0 && selectedCategory != nil {
            return true
        }
        return false
    }
}
