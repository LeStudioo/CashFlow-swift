//
//  SavingsPlanModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 12/11/2024.
//

import Foundation

struct SavingsPlanModel: Codable, Identifiable, Equatable, Hashable {
    var id: Int?
    var name: String?
    var emoji: String?
    var startDateString: String?
    var endDateString: String?
    var currentAmount: Double?
    var goalAmount: Double?
    var note: String?
    var isArchived: Bool?

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

    init(from decoder: Decoder) throws {
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
}

extension SavingsPlanModel {
    
    var amountToTheGoal: Double {
        guard let goalAmount, let currentAmount else { return 0 }
        return goalAmount - currentAmount
    }
    
    var startDate: Date {
        return self.startDateString?.toDate() ?? .now
    }
    
    var endDate: Date? {
        return self.endDateString?.toDate()
    }
    
    var percentageComplete: Double {
        guard let goalAmount, let currentAmount else { return 0 }        
        if currentAmount / goalAmount >= 0.96 {
            return 0.96
        } else {
            return currentAmount / goalAmount
        }
    }
    
}
