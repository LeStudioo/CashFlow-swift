//
//  SubscriptionDetailViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 22/12/2024.
//

import Foundation

final class SubscriptionDetailViewModel: ObservableObject {
    @Published var selectedCategory: CategoryModel? = nil
    @Published var selectedSubcategory: SubcategoryModel? = nil
}

extension SubscriptionDetailViewModel {
    
    @MainActor
    func updateCategory(subscriptionID: Int) {
        let accountRepository: AccountRepository = .shared
        let subscriptionRepository: SubscriptionRepository = .shared
        guard let account = accountRepository.selectedAccount, let accountID = account.id else { return }
        
        let body: SubscriptionModel = .init()
        
        if let selectedCategory, let newCategory = CategoryRepository.shared.findCategoryById(selectedCategory.id) {
            body.categoryID = newCategory.id
            body.subcategoryID = nil
            
            if newCategory.id == 0 {
                selectedSubcategory = nil
            }
            
            if let selectedSubcategory, let newSubcategory = CategoryRepository.shared.findSubcategoryById(selectedSubcategory.id) {
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
