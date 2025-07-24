//
//  AuthBody.swift
//  UserModule
//
//  Created by Theo Sementa on 24/07/2025.
//


import Foundation

public struct AuthBody: Codable {
    public var identityToken: String
    
    public init(identityToken: String) {
        self.identityToken = identityToken
    }
}
