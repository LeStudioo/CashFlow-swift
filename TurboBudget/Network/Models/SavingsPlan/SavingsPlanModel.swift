//
//  SavingsPlanModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 12/11/2024.
//

import Foundation

class SavingsPlanModel: Codable, Identifiable, Equatable, ObservableObject, Hashable {
    @Published var id: Int?
    @Published var name: String?
    @Published var emoji: String?
    @Published var startDateString: String?
    @Published var endDateString: String?
    @Published var currentAmount: Double?
    @Published var goalAmount: Double?
    @Published var note: String?
    @Published var isArchived: Bool?

    // Initialiseur
    init(id: Int? = nil, name: String? = nil, emoji: String? = nil, startDateString: String? = nil, endDateString: String? = nil, currentAmount: Double? = nil, goalAmount: Double? = nil, note: String? = nil, isArchived: Bool? = nil) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.startDateString = startDateString
        self.endDateString = endDateString
        self.currentAmount = currentAmount
        self.goalAmount = goalAmount
        self.note = note
        self.isArchived = isArchived
    }
    
    /// Body
    init(
        name: String,
        emoji: String,
        startDate: String,
        endDate: String? = nil,
        currentAmount: Double,
        goalAmount: Double
    ) {
        self.name = name
        self.emoji = emoji
        self.startDateString = startDate
        self.endDateString = endDate
        self.currentAmount = currentAmount
        self.goalAmount = goalAmount
    }

    // Conformance au protocole Codable
    private enum CodingKeys: String, CodingKey {
        case id, name, emoji, currentAmount, goalAmount, note, isArchived
        case startDateString = "startDate"
        case endDateString = "endDate"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        emoji = try container.decodeIfPresent(String.self, forKey: .emoji)
        startDateString = try container.decodeIfPresent(String.self, forKey: .startDateString)
        endDateString = try container.decodeIfPresent(String.self, forKey: .endDateString)
        currentAmount = try container.decodeIfPresent(Double.self, forKey: .currentAmount)
        goalAmount = try container.decodeIfPresent(Double.self, forKey: .goalAmount)
        note = try container.decodeIfPresent(String.self, forKey: .note)
        isArchived = try container.decodeIfPresent(Bool.self, forKey: .isArchived)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(emoji, forKey: .emoji)
        try container.encodeIfPresent(startDateString, forKey: .startDateString)
        try container.encodeIfPresent(endDateString, forKey: .endDateString)
        try container.encodeIfPresent(currentAmount, forKey: .currentAmount)
        try container.encodeIfPresent(goalAmount, forKey: .goalAmount)
        try container.encodeIfPresent(note, forKey: .note)
        try container.encodeIfPresent(isArchived, forKey: .isArchived)
    }

    // Fonction pour le protocole Equatable
    static func == (lhs: SavingsPlanModel, rhs: SavingsPlanModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.emoji == rhs.emoji &&
               lhs.startDateString == rhs.startDateString &&
               lhs.endDateString == rhs.endDateString &&
               lhs.currentAmount == rhs.currentAmount &&
               lhs.goalAmount == rhs.goalAmount &&
               lhs.note == rhs.note &&
               lhs.isArchived == rhs.isArchived
    }

    // Fonction pour le protocole Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(emoji)
        hasher.combine(startDateString)
        hasher.combine(endDateString)
        hasher.combine(currentAmount)
        hasher.combine(goalAmount)
        hasher.combine(note)
        hasher.combine(isArchived)
    }
}

extension SavingsPlanModel {
    
    var amountToTheGoal: Double {
        guard let goalAmount, let currentAmount else { return 0 }
        return goalAmount - currentAmount
    }
    
    var startDate: Date {
        return self.startDateString?.toDate() ?? .now
    }
    
    var endDate: Date {
        return self.endDateString?.toDate() ?? .now
    }
    
}
