//
//  CategoryStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/11/2024.
//

import Foundation

final class CategoryStore: ObservableObject {
    static let shared = CategoryStore()
    
    @Published var categories: [CategoryModel] = []
    @Published var subcategories: [SubcategoryModel] = []
}

extension CategoryStore {
    
    @MainActor
    func fetchCategories() async {
        do {
            let categories = try await NetworkService.shared.sendRequest(
                apiBuilder: CategoryAPIRequester.fetchCategories,
                responseModel: [CategoryModel].self
            )
            self.categories = categories
            self.subcategories = categories.flatMap { $0.subcategories ?? [] }
        } catch { NetworkService.handleError(error: error) }
    }
    
}

extension CategoryStore {
    
    var categoriesWithTransactions: [CategoryModel] {
        var array: [CategoryModel] = []
        let filterManager = FilterManager.shared
        
        for category in self.categories {
            let transactionsFiltered = category.transactions
                .filter {
                    Calendar.current.isDate(
                        $0.date,
                        equalTo: filterManager.date,
                        toGranularity: .month
                    )
                }
            if transactionsFiltered.count != 0 {
                array.append(category)
            }
        }
        
        return array
            .sorted { $0.name < $1.name }
    }
    
    var categoriesSlices: [PieSliceData] {
        var array: [PieSliceData] = []
        
        for category in self.categoriesWithTransactions.filter({ $0.id != 1 }) {
            guard let categoryID = category.id else { continue }
            array.append(
                .init(
                    categoryID: categoryID,
                    iconName: category.icon,
                    value: category.transactionsFiltered
                        .map { $0.amount ?? 0 }
                        .reduce(0, +),
                    color: category.color
                )
            )
        }
        
        return array
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
    
    var currentMonthExpenses: [TransactionModel] {
        return categories.flatMap { $0.currentMonthExpenses }
    }
    
    var currentMonthIncomes: [TransactionModel] {
        return categories.flatMap { $0.currentMonthIncomes }
    }
}
