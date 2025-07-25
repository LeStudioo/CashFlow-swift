//
//  NetworkConstant.swift
//  LifeFlow
//
//  Created by Theo Sementa on 09/03/2024.
//

import Foundation

public struct NetworkPath {
    public static let baseURL: String = "https://cashflow.lazyy.fr"
    
    public struct Auth {
        public static let apple: String = "/auth/apple"
        public static let google: String = "/auth/google"
        public static let socket: String = "/auth/socket"
    }
    
    public struct User {
        public static let base: String = "/user"
        public static let me: String = "/user/me"
        public static let login: String = "/user/login"
        public static let register: String = "/user/register"
        public static func refreshToken(refreshToken: String) -> String {
            return "/user/refresh-token/\(refreshToken)"
        }
    }
    
    public struct Account {
        public static let base: String = "/account"
        public static func update(id: Int) -> String {
            return "/account/\(id)"
        }
        public static func delete(id: Int) -> String {
            return "/account/\(id)"
        }
        public static func cashflow(id: Int, year: Int) -> String {
            return "/account/\(id)/cashflow/\(year)"
        }
        public static func stats(id: Int, withSavings: Bool) -> String {
            return "/account/\(id)/stats/\(withSavings ? "1" : "0")"
        }
    }
    
    public struct Transaction {
        public static func base(accountID: Int) -> String {
            return "/transaction/\(accountID)"
        }
        public static func fetchByPeriod(accountID: Int, startDate: String, endDate: String, type: Int? = nil) -> String {
            if let type {
                return "/transaction/\(accountID)/\(startDate)/\(endDate)/\(type)"
            } else {
                return "/transaction/\(accountID)/\(startDate)/\(endDate)"
            }
        }
        
        /// TransactionID = transaction to exclude of the search
        public static func fetchCategory(name: String, transactionID: Int? = nil) -> String {
            if let transactionID {
                return "/transaction/auto-cat/\(name)/\(transactionID)"
            } else {
                return "/transaction/auto-cat/\(name)"
            }
        }
        public static func update(id: Int) -> String {
            return "/transaction/\(id)"
        }
        public static func delete(id: Int) -> String {
            return "/transaction/\(id)"
        }
    }
    
    public struct Transfer {
        public static func doTransfer(senderAccountID: Int, receiverAccountID: Int) -> String {
            return "/transaction/transfer/\(senderAccountID)/\(receiverAccountID)"
        }
        public static func delete(id: Int) -> String {
            return "/transaction/transfer/\(id)"
        }
    }
    
    public struct Subscription {
        public static func base(accountID: Int) -> String {
            return "/subscription/\(accountID)"
        }
        public static func update(id: Int) -> String {
            return "/subscription/\(id)"
        }
        public static func delete(id: Int) -> String {
            return "/subscription/\(id)"
        }
    }
    
    public struct SavingsPlan {
        public static func base(accountID: Int) -> String {
            return "/savingsplan/\(accountID)"
        }
        public static func update(id: Int) -> String {
            return "/savingsplan/\(id)"
        }
        public static func delete(id: Int) -> String {
            return "/savingsplan/\(id)"
        }
    }
    
    public struct Contribution {
        public static func base(savingsplanID: Int) -> String {
            return "/savingsplan/\(savingsplanID)/contribution"
        }
        public static func update(savingsplanID: Int, id: Int) -> String {
            return "/savingsplan/\(savingsplanID)/contribution/\(id)"
        }
        public static func delete(savingsplanID: Int, id: Int) -> String {
            return "/savingsplan/\(savingsplanID)/contribution/\(id)"
        }
    }
    
    public struct Budget {
        public static func base(accountID: Int) -> String {
            return "/budget/\(accountID)"
        }
        public static func update(id: Int) -> String {
            return "/budget/\(id)"
        }
        public static func delete(id: Int) -> String {
            return "/budget/\(id)"
        }
    }
    
    public struct CreditCard {
        public static func base(accountID: Int) -> String {
            return "/creditcard/\(accountID)"
        }
        public static func delete(accountID: Int, creditCardID: UUID) -> String {
            return "/creditcard/\(accountID)/\(creditCardID.uuidString)"
        }
    }
    
    public struct Category {
        public static let base: String = "/category"
    }
    
}
