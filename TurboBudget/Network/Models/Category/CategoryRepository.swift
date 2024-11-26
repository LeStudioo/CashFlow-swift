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
        } catch { NetworkService.handleError(error: error) }
    }
}
