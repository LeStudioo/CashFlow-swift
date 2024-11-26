//
//  CategoryRepository.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/11/2024.
//

import Foundation

final class CategoryRepository: ObservableObject {
    static let shared = CategoryRepository()
    
    @Published var categories: [CategoryModel] = []
    @Published var subcategories: [SubcategoryModel] = []
}

extension CategoryRepository {
    
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

// MARK: - Utils
extension CategoryRepository {

    func findCategoryById(_ id: Int?) -> CategoryModel? {
        return self.categories.first(where: { $0.id == id })
    }
    
    func findSubcategoryById(_ id: Int?) -> SubcategoryModel? {
        return self.subcategories.first(where: { $0.id == id })
    }
    
}
