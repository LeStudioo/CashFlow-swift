//
//  UserModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

import Foundation

struct UserModel: Codable, Identifiable {
    var id: Int?
    var firstName: String?
    var lastName: String?
    var email: String?
    var token: String?
    var refreshToken: String?

    // Initialiseur
    init(id: Int? = nil, firstName: String? = nil, lastName: String? = nil, email: String? = nil, token: String? = nil, refreshToken: String? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.token = token
        self.refreshToken = refreshToken
    }

    // Enumération pour les clés de codage/décodage
    private enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, email, token, refreshToken
    }

    // Implémentation de Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        token = try container.decodeIfPresent(String.self, forKey: .token)
        refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
    }

    // Implémentation de Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(lastName, forKey: .lastName)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(token, forKey: .token)
        try container.encodeIfPresent(refreshToken, forKey: .refreshToken)
    }
}
