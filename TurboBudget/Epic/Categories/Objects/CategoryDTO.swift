//
//  CategoryDTO.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/05/2025.
//

import Foundation
import SwiftUICore
import CoreModule

struct CategoryDTO: Codable, Equatable, Hashable {
    var id: Int?
    var name: String?
    var icon: String?
    var color: String?
    var subcategories: [SubcategoryDTO]?
}

extension CategoryDTO {
    
    func toModel() throws -> CategoryModel {
        guard let id,
              let name,
              let icon,
              let color
        else { throw NetworkError.parsingError }
        
        return .init(
            id: id,
            name: name.localized,
            icon: ImageResource(name: icon, bundle: .main),
            color: Color(hex: color),
            subcategories: try subcategories?.map { try $0.toModel() } ?? []
        )
    }
}
