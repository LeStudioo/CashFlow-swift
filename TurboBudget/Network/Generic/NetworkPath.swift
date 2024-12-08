//
//  NetworkConstant.swift
//  LifeFlow
//
//  Created by Theo Sementa on 09/03/2024.
//

import Foundation

struct NetworkPath {
    static let baseURL: String = "https://theodev.myftp.org:81"
    
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
        static func cashflow(id: Int, year: Int) -> String {
            return "/account/\(id)/cashflow/\(year)"
        }
    }
    
    struct Transaction {
        static func base(accountID: Int) -> String {
            return "/transaction/\(accountID)"
        }
        static func fetchByPeriod(accountID: Int, startDate: String, endDate: String, type: Int? = nil) -> String {
            if let type {
                return "/transaction/\(accountID)/\(startDate)/\(endDate)/\(type)"
            } else {
                return "/transaction/\(accountID)/\(startDate)/\(endDate)"
            }
        }
        
        /// TransactionID = transaction to exclude of the search
        static func fetchCategory(name: String, transactionID: Int? = nil) -> String {
            if let transactionID {
                return "/transaction/auto-cat/\(name)/\(transactionID)"
            } else {
                return "/transaction/auto-cat/\(name)"
            }
        }
        static func update(id: Int) -> String {
            return "/transaction/\(id)"
        }
        static func delete(id: Int) -> String {
            return "/transaction/\(id)"
        }
    }
    
    struct Transfer {
        static func doTransfer(senderAccountID: Int, receiverAccountID: Int) -> String {
            return "/transaction/transfer/\(senderAccountID)/\(receiverAccountID)"
        }
        static func delete(id: Int) -> String {
            return "/transaction/transfer/\(id)"
        }
    }
    
    struct Subscription {
        static func base(accountID: Int) -> String {
            return "/subscription/\(accountID)"
        }
        static func update(id: Int) -> String {
            return "/subscription/\(id)"
        }
        static func delete(id: Int) -> String {
            return "/subscription/\(id)"
        }
    }
    
    struct SavingsPlan {
        static func base(accountID: Int) -> String {
            return "/savingsplan/\(accountID)"
        }
        static func update(id: Int) -> String {
            return "/savingsplan/\(id)"
        }
        static func delete(id: Int) -> String {
            return "/savingsplan/\(id)"
        }
    }
    
    struct Contribution {
        static func base(savingsplanID: Int) -> String {
            return "/savingsplan/\(savingsplanID)/contribution"
        }
        static func update(savingsplanID: Int, id: Int) -> String {
            return "/savingsplan/\(savingsplanID)/contribution/\(id)"
        }
        static func delete(savingsplanID: Int, id: Int) -> String {
            return "/savingsplan/\(savingsplanID)/contribution/\(id)"
        }
    }
    
    struct Budget {
        static func base(accountID: Int) -> String {
            return "/budget/\(accountID)"
        }
        static func update(id: Int) -> String {
            return "/budget/\(id)"
        }
        static func delete(id: Int) -> String {
            return "/budget/\(id)"
        }
    }
    
    struct CreditCard {
        static func base(accountID: Int) -> String {
            return "/creditcard/\(accountID)"
        }
        static func delete(id: Int) -> String {
            return "/creditcard/\(id)"
        }
    }
    
    struct Category {
        static let base: String = "/category"
    }
    
}
