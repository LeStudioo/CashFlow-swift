//
//  SavingsPlanModel.swift
//  FixBounce
//
//  Created by Theo Sementa on 12/11/2024.
//

import Foundation

class SavingsPlanModel: Codable, Identifiable, Equatable, ObservableObject, Hashable {
    @Published var id: Int?
    @Published var name: String?
    @Published var emoji: String?
    @Published var startDate: String?
    @Published var endDate: String?
    @Published var currentAmount: Double?
    @Published var goalAmount: Double?
    @Published var note: String?

    // Initialiseur
    init(id: Int? = nil, name: String? = nil, emoji: String? = nil, startDate: String? = nil, endDate: String? = nil, currentAmount: Double? = nil, goalAmount: Double? = nil, note: String? = nil) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.startDate = startDate
        self.endDate = endDate
        self.currentAmount = currentAmount
        self.goalAmount = goalAmount
        self.note = note
    }

    // Conformance au protocole Codable
    private enum CodingKeys: String, CodingKey {
        case id, name, emoji, startDate, endDate, currentAmount, goalAmount, note
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        emoji = try container.decodeIfPresent(String.self, forKey: .emoji)
        startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
        endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
        currentAmount = try container.decodeIfPresent(Double.self, forKey: .currentAmount)
        goalAmount = try container.decodeIfPresent(Double.self, forKey: .goalAmount)
        note = try container.decodeIfPresent(String.self, forKey: .note)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(emoji, forKey: .emoji)
        try container.encodeIfPresent(startDate, forKey: .startDate)
        try container.encodeIfPresent(endDate, forKey: .endDate)
        try container.encodeIfPresent(currentAmount, forKey: .currentAmount)
        try container.encodeIfPresent(goalAmount, forKey: .goalAmount)
        try container.encodeIfPresent(note, forKey: .note)
    }

    // Fonction pour le protocole Equatable
    static func == (lhs: SavingsPlanModel, rhs: SavingsPlanModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.emoji == rhs.emoji &&
               lhs.startDate == rhs.startDate &&
               lhs.endDate == rhs.endDate &&
               lhs.currentAmount == rhs.currentAmount &&
               lhs.goalAmount == rhs.goalAmount &&
               lhs.note == rhs.note
    }

    // Fonction pour le protocole Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(emoji)
        hasher.combine(startDate)
        hasher.combine(endDate)
        hasher.combine(currentAmount)
        hasher.combine(goalAmount)
        hasher.combine(note)
    }
}

