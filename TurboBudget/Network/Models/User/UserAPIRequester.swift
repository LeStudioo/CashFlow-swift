//
//  UserAPIRequester.swift
//  HappyEat_iOS
//
//  Created by Theo Sementa on 09/03/2024.
//

import Foundation

enum UserAPIRequester: APIRequestBuilder {
    case me
    case register(body: UserModel)
    case refreshToken(refreshToken: String)
}

extension UserAPIRequester {
    var path: String {
        switch self {
        case .me:                               return NetworkPath.User.me
        case .register:                         return NetworkPath.User.register
        case .refreshToken(let refreshToken):   return NetworkPath.User.refreshToken(refreshToken: refreshToken)
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .me:           return .GET
        case .register:     return .POST
        case .refreshToken: return .GET
        }
    }
    
    var parameters: [URLQueryItem]? { return nil }
    
    var isTokenNeeded: Bool {
        switch self {
        case .me:           return true
        case .register:     return false
        case .refreshToken: return false
        }
    }
    
    var body: Data? {
        switch self {
        case .register(let body):   return try? JSONEncoder().encode(body)
        default:                    return nil
        }
    }
    
}
