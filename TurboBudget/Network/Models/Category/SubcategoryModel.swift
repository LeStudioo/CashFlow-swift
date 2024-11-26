//
//  SubcategoryModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/11/2024.
//

import Foundation

class SubcategoryModel: Codable, Identifiable, Equatable, ObservableObject, Hashable {
    @Published var id: Int?
    @Published var name: String?
    @Published var icon: String?
    @Published var colorString: String?

    // Initialisateur
    init(
        id: Int? = nil,
        name: String? = nil,
        icon: String? = nil,
        colorString: String? = nil
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.colorString = colorString
    }

    // Conformance au protocole Codable
    private enum CodingKeys: String, CodingKey {
        case id, name, icon
        case colorString = "color"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        icon = try container.decodeIfPresent(String.self, forKey: .icon)
        colorString = try container.decodeIfPresent(String.self, forKey: .colorString)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(icon, forKey: .icon)
        try container.encodeIfPresent(colorString, forKey: .colorString)
    }

    // Conformance au protocole Equatable
    static func == (lhs: SubcategoryModel, rhs: SubcategoryModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.icon == rhs.icon &&
               lhs.colorString == rhs.colorString
    }

    // Conformance au protocole Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(icon)
        hasher.combine(colorString)
    }
}
