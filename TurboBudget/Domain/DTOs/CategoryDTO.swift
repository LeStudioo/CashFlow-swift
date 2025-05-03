//
//  CategoryDTO.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/05/2025.
//

import Foundation
import SwiftUICore

struct CategoryDTO: Codable, Equatable, Hashable {
    var id: Int?
    var name: String?
    var icon: String?
    var color: String?
    var subcategories: [SubcategoryModel]?
}

extension CategoryDTO {
    
    func toModel() throws -> CategoryModel {
        guard let id,
              let name,
              let icon,
              let color
        else { throw NetworkError.unknown }
        
        var colorColor: Color {
            switch color {
            case "gray":    return .gray.lighter(by: 4)
            case "green":   return .green
            case "red":     return .red
            case "orange":  return .orange
            case "yellow":  return .yellow
            case "mint":    return .mint
            case "teal":    return .teal
            case "cyan":    return .cyan
            case "blue":    return .blue
            case "indigo":  return .indigo
            case "purple":  return .purple
            case "pink":    return .pink
            case "brown":   return .brown
            default:        return .gray.lighter(by: 4)
            }
        }
        
        return .init(
            id: id,
            name: name.localized,
            icon: icon, // ImageResource(name: icon, bundle: .main), // TODO: To Activate
            color: colorColor, // Color(hex: color), // TODO: To Activate
            subcategories: subcategories
        )
    }
}
