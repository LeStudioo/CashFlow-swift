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
    var isPremium: Bool?
}
