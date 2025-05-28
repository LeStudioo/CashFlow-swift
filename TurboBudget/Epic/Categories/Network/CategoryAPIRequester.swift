//
//  CategoryAPIRequester.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/11/2024.
//

import Foundation
import NetworkKit

enum CategoryAPIRequester: APIRequestBuilder {
    case fetchCategories
}

extension CategoryAPIRequester {
    var path: String {
        return NetworkPath.Category.base
    }
    
    var httpMethod: HTTPMethod {
        return .GET
    }
    
    var parameters: [URLQueryItem]? {
        return nil
    }
    
    var isTokenNeeded: Bool {
        return true
    }
    
    var body: Data? {
        return nil
    }
}
