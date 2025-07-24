//
//  AuthAPIRequester.swift
//  Split
//
//  Created by KaayZenn on 29/05/2024.
//

import Foundation
import NetworkKit
import CoreModule

enum AuthAPIRequester: APIRequestBuilder {
    case apple(body: AuthBody)
    case google(body: AuthBody)
    case socket(body: AuthBody)
}

extension AuthAPIRequester {
    var path: String {
        switch self {
        case .apple:    return NetworkPath.Auth.apple
        case .google:   return NetworkPath.Auth.google
        case .socket:   return NetworkPath.Auth.socket
        }
    }
    
    var httpMethod: HTTPMethod {
        return .POST
    }
    
    var parameters: [URLQueryItem]? {
        return nil
    }
    
    var isTokenNeeded: Bool {
        switch self {
        case .apple, .google:   return false
        case .socket:           return true
        }
    }
    
    var body: Data? {
        switch self {
        case .apple(let body):  return try? JSONEncoder().encode(body)
        case .google(let body): return try? JSONEncoder().encode(body)
        case .socket(let body): return try? JSONEncoder().encode(body)
        }
    }
}
