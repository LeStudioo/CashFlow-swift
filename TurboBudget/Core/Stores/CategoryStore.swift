//
//  CategoryStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/11/2024.
//

import Foundation
import NetworkKit

final class CategoryStore: ObservableObject {
    static let shared = CategoryStore()
    
    @Published var categories: [CategoryModel] = []
    @Published var subcategories: [SubcategoryModel] = []
    
}

extension CategoryStore {
    
    @MainActor
    func fetchCategories() async {
        do {
            let categories = try await NetworkService.sendRequest(
                apiBuilder: CategoryAPIRequester.fetchCategories,
                responseModel: [CategoryDTO].self
            ).map { try $0.toModel() }
            self.categories = categories
            for (index, category) in self.categories.enumerated() {
                self.categories[index].subcategories = category.subcategories?.filter { $0.isVisible }
            }
            self.subcategories = categories.flatMap { $0.subcategories ?? [] }
        } catch { NetworkService.handleError(error: error) }
    }
    
}

extension CategoryStore {
    
    private func computeCategoryData(for month: Date) -> [Int?: CategoryTransactionData] {
        let allMonthTransactions = TransactionStore.shared.getTransactions(in: month)
        let transactionsByCategory = Dictionary(grouping: allMonthTransactions) { $0.category }
        
        return Dictionary(uniqueKeysWithValues: categories
            .compactMap { category in
                let categoryTransactions = transactionsByCategory[category, default: []]
                if categoryTransactions.isEmpty { return nil }
                return (
                    category.id,
                    CategoryTransactionData(
                        category: category,
                        transactions: categoryTransactions
                    )
                )
            })
    }
    
    private func computeSubcategoryData(for month: Date, in category: CategoryModel) -> [Int?: SubcategoryTransactionData] {
        let allMonthTransactions = TransactionStore.shared.getTransactions(for: category, in: month)
        let transactionsBySubcategory = Dictionary(grouping: allMonthTransactions) { $0.subcategory }
        
        return Dictionary(uniqueKeysWithValues: (category.subcategories ?? [])
            .compactMap { subcategory in
                let subcategoryTransactions = transactionsBySubcategory[subcategory, default: []]
                if subcategoryTransactions.isEmpty { return nil }
                return (
                    subcategory.id,
                    SubcategoryTransactionData(
                        subcategory: subcategory,
                        transactions: subcategoryTransactions
                    )
                )
            })
    }
        
    func categoriesSlices(for month: Date) -> [PieSliceData] {
        let slices = computeCategoryData(for: month)
            .values
            .filter { !$0.category.isRevenue }
            .map { data in
                PieSliceData(
                    categoryID: data.category.id,
                    icon: data.category.icon,
                    value: data.totalAmount,
                    color: data.category.color
                )
            }
        return slices
    }
    
    func subcategoriesSlices(for category: CategoryModel, in month: Date) -> [PieSliceData] {
        let slices = computeSubcategoryData(for: month, in: category)
            .values
            .map { data in
                PieSliceData(
                    categoryID: category.id,
                    subcategoryID: data.subcategory.id,
                    icon: data.subcategory.icon,
                    value: data.totalAmount,
                    color: data.subcategory.color
                )
            }
        return slices
    }
}

// MARK: - Utils
extension CategoryStore {
    
    var toCategorized: CategoryModel? {
        return self.categories.first { $0.isToCategorized }
    }
    
    func findCategoryByName(_ name: String) -> CategoryModel? {
        return self.categories.first(where: { $0.name == name })
    }

    func findCategoryById(_ id: Int?) -> CategoryModel? {
        return self.categories.first(where: { $0.id == id })
    }
    
    func findSubcategoryById(_ id: Int?) -> SubcategoryModel? {
        return self.subcategories.first(where: { $0.id == id })
    }
    
    func reset() {
        self.categories = []
        self.subcategories = []
    }
    
}
