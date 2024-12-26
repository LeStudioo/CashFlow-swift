//
//  SubscriptionDetailViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 22/12/2024.
//

import Foundation

final class SubscriptionDetailViewModel: ObservableObject {
    @Published var selectedCategory: CategoryModel?
    @Published var selectedSubcategory: SubcategoryModel?
}

extension SubscriptionDetailViewModel {
    
    @MainActor
    func updateCategory(subscriptionID: Int) {
        let accountRepository: AccountStore = .shared
        let subscriptionRepository: SubscriptionStore = .shared
        guard let account = accountRepository.selectedAccount, let accountID = account.id else { return }
        
        let body: SubscriptionModel = .init()
        
        if let selectedCategory, let newCategory = CategoryStore.shared.findCategoryById(selectedCategory.id) {
            body.categoryID = newCategory.id
            body.subcategoryID = nil
            
            if newCategory.id == 0 {
                selectedSubcategory = nil
            }
            
            if let selectedSubcategory, let newSubcategory = CategoryStore.shared.findSubcategoryById(selectedSubcategory.id) {
                body.subcategoryID = newSubcategory.id
            }
            
            Task {
                await subscriptionRepository.updateSubscription(
                    subscriptionID: subscriptionID,
                    body: body
                )
                
                self.selectedCategory = nil
                self.selectedSubcategory = nil
            }
        }
    }
    
}
