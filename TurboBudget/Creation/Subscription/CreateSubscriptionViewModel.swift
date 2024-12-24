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
    
    var subscription: SubscriptionModel? = nil

    @Published var name: String = ""
    @Published var amount: String = ""
    @Published var frequencyDate: Date = .now
    @Published var type: TransactionType = .expense
    @Published var frequency: SubscriptionFrequency = .monthly
    @Published var selectedCategory: CategoryModel? = nil
    @Published var selectedSubcategory: SubcategoryModel? = nil
        
    @Published var presentingConfirmationDialog: Bool = false
    
    init(subscription: SubscriptionModel? = nil) {
        self.subscription = subscription
        if let subscription {
            self.name = subscription.name ?? ""
            self.amount = subscription.amount?.formatted() ?? ""
            self.type = subscription.type
            self.frequency = subscription.frequency ?? .monthly
            self.frequencyDate = subscription.date
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
    
    func bodyForCreation() -> SubscriptionModel {
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
    
    func createNewSubscription(dismiss: DismissAction) {
        let accountRepository: AccountStore = .shared
        let subscriptionRepository: SubscriptionStore = .shared
        let successfullModalManager: SuccessfullModalManager = .shared
        
        Task {
            guard let account = accountRepository.selectedAccount else { return }
            guard let accountID = account.id else { return }
            
            if let subscription, let subscriptionID = subscription.id {
                if let updatedSubscription = await subscriptionRepository.updateSubscription(
                    subscriptionID: subscriptionID,
                    body: bodyForCreation()
                ) {
                    await dismiss()
                    await successfullModalManager.showSuccessfulSubscription(
                        type: .update,
                        subscription: updatedSubscription
                    )
                }
            } else if let newSubscritpion = await subscriptionRepository.createSubscription(
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
