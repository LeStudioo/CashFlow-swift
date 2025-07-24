//
//  UserModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

import Foundation

public struct UserModel: Codable, Identifiable {
    public var id: Int?
    public var firstName: String?
    public var lastName: String?
    public var email: String?
    public var token: String?
    public var refreshToken: String?
    public var isPremium: Bool?
    
    public init(
        id: Int? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        email: String? = nil,
        token: String? = nil,
        refreshToken: String? = nil,
        isPremium: Bool? = nil
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.token = token
        self.refreshToken = refreshToken
        self.isPremium = isPremium
    }
}
