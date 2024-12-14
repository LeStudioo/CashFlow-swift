//
//  CategoryMock.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/11/2024.
//

import Foundation

extension CategoryModel {
    static let mock = CategoryModel(
        id: 1,
        name: "category1_name".localized,
        icon: "cart.fill",
        colorString: "red",
        subcategories: [
            SubcategoryModel.mock
        ]
    )
}
