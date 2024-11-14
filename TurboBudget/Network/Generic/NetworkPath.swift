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
    
    struct Subscription {
        static let base: String = "/subscription"
        static func update(id: Int) -> String {
            return "/subscription/\(id)"
        }
        static func delete(id: Int) -> String {
            return "/subscription/\(id)"
        }
    }
    
    struct SavingsPlan {
        static let base: String = "/savingsplan"
        static func update(id: Int) -> String {
            return "/savingsplan/\(id)"
        }
        static func delete(id: Int) -> String {
            return "/savingsplan/\(id)"
        }
    }
    
    struct Contribution {
        static let base: String = "/contribution"
        static func update(id: Int) -> String {
            return "/contribution/\(id)"
        }
        static func delete(id: Int) -> String {
            return "/contribution/\(id)"
        }
    }
    
    struct Budget {
        static let base: String = "/budget"
        static func update(id: Int) -> String {
            return "/budget/\(id)"
        }
        static func delete(id: Int) -> String {
            return "/budget/\(id)"
        }
    }
    
    struct CreditCard {
        static let base: String = "/creditcard"
        static func delete(id: Int) -> String {
            return "/creditcard/\(id)"
        }
    }
    
}
