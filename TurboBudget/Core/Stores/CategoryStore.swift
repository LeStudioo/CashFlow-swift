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
    
    private init() {
        Task {
            await fetchCategories()
        }
    }
}

extension CategoryStore {
    
    @MainActor
    private func fetchCategories() async {
        do {
            let categories = try await NetworkService.sendRequest(
                apiBuilder: CategoryAPIRequester.fetchCategories,
                responseModel: [CategoryModel].self
            )
            self.categories = categories
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
                guard let categoryID = category.id else { return nil }
                let categoryTransactions = transactionsByCategory[category, default: []]
                if categoryTransactions.isEmpty { return nil }
                return (
                    categoryID,
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
                guard let subcategoryID = subcategory.id else { return nil }
                let subcategoryTransactions = transactionsBySubcategory[subcategory, default: []]
                if subcategoryTransactions.isEmpty { return nil }
                return (
                    subcategoryID,
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
                    categoryID: data.category.id!,
                    iconName: data.category.icon,
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
                    categoryID: category.id!,
                    subcategoryID: data.subcategory.id!,
                    iconName: data.subcategory.icon,
                    value: data.totalAmount,
                    color: data.subcategory.color
                )
            }
        return slices
    }
}

// MARK: - Utils
extension CategoryStore {

    func findCategoryById(_ id: Int?) -> CategoryModel? {
        return self.categories.first(where: { $0.id == id })
    }
    
    func findSubcategoryById(_ id: Int?) -> SubcategoryModel? {
        return self.subcategories.first(where: { $0.id == id })
    }
    
}
