//
//  CategoryModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/11/2024.
//

import Foundation
import SwiftUI

class CategoryModel: Codable, Identifiable, Equatable, ObservableObject, Hashable {
    @Published var id: Int?
    @Published var name: String?
    @Published var icon: String?
    @Published var colorString: String?
    @Published var subcategories: [SubcategoryModel]?

    // Initialisateur
    init(
        id: Int? = nil,
        name: String? = nil,
        icon: String? = nil,
        colorString: String? = nil,
        subcategories: [SubcategoryModel]? = nil
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.colorString = colorString
        self.subcategories = subcategories
    }

    // Conformance au protocole Codable
    private enum CodingKeys: String, CodingKey {
        case id, name, icon, subcategories
        case colorString = "color"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        icon = try container.decodeIfPresent(String.self, forKey: .icon)
        colorString = try container.decodeIfPresent(String.self, forKey: .colorString)
        subcategories = try container.decodeIfPresent([SubcategoryModel].self, forKey: .subcategories)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(icon, forKey: .icon)
        try container.encodeIfPresent(colorString, forKey: .colorString)
        try container.encodeIfPresent(subcategories, forKey: .subcategories)
    }

    // Conformance au protocole Equatable
    static func == (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.icon == rhs.icon &&
               lhs.colorString == rhs.colorString &&
               lhs.subcategories == rhs.subcategories
    }

    // Conformance au protocole Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(icon)
        hasher.combine(colorString)
        hasher.combine(subcategories)
    }
}

extension CategoryModel {
    
    var color: Color {
        switch self.id {
        case 0: return .gray
        case 1: return .green
        case 2: return .red
        case 3: return .orange
        case 4: return .yellow
        case 5: return .green
        case 6: return .mint
        case 7: return .teal
        case 8: return .cyan
        case 9: return .blue
        case 10: return .indigo
        case 11: return .purple
        case 12: return .pink
        case 13: return .brown
        default: return .gray
        }
    }
    
    static var revenue: CategoryModel? {
        return CategoryRepository.shared.findCategoryById(1)
    }
    
    static var toCategorized: CategoryModel? {
        return CategoryRepository.shared.findCategoryById(0)
    }
    
    func isRevenue() -> Bool {
        return self.id == 1
    }
    
}
