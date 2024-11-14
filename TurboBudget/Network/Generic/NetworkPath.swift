//
//  NetworkConstant.swift
//  LifeFlow
//
//  Created by Theo Sementa on 09/03/2024.
//

import Foundation

struct NetworkPath {
    static let baseURL: String = "https://theodev.myftp.org:86"
    
    struct Auth {
        static let apple: String = "/auth/apple"
        static let google: String = "/auth/google"
    }
    
    struct User {
        static let me: String = "/user/me"
        static let register: String = "/user/register"
        static func refreshToken(refreshToken: String) -> String {
            return "/user/refresh-token/\(refreshToken)"
        }
    }
    
    struct Account {
        static let base: String = "/account"
        static func update(id: Int) -> String {
            return "/account/\(id)"
        }
        static func delete(id: Int) -> String {
            return "/account/\(id)"
        }
    }
    
    struct Transaction {
        static let base: String = "/transaction"
        static func update(id: Int) -> String {
            return "/transaction/\(id)"
        }
        static func delete(id: Int) -> String {
            return "/transaction/\(id)"
        }
    }
    
}
