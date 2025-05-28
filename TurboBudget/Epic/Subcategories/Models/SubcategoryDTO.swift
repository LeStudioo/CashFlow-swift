//
//  SubcategoryDTO.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/05/2025.
//

import Foundation
import SwiftUICore

struct SubcategoryDTO: Codable, Equatable, Hashable {
    var id: Int?
    var name: String?
    var icon: String?
    var color: String?
    var isVisible: Bool?
}

extension SubcategoryDTO {

    func toModel() throws -> SubcategoryModel {
        guard let id,
              let name,
              let icon,
              let color,
              let isVisible
        else { throw NetworkError.parsingError }
        
        return SubcategoryModel(
            id: id,
            name: name.localized,
            icon: ImageResource(name: icon, bundle: .main),
            color: Color(hex: color),
            isVisible: isVisible
        )
    }
    
}
    
