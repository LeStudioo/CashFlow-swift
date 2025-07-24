//
//  BaseAPIRequester.swift
//  NetworkBestPracticesSwiftUI
//
//  Created by Theo Sementa on 03/02/2025.
//

import Foundation
import NetworkKit
import CoreModule

extension APIRequestBuilder {
    
    var headers: [(key: String, value: String)]? {
        
        var stylesVersion: Int {
            let versionCleaned: String = Bundle.main.releaseVersionNumber?.replacingOccurrences(of: ".", with: "") ?? ""
            return (Int(versionCleaned) ?? 0) <= 204 ? 1 : 2
        }
        
        var header = [(String, String)]()
        header.append(("Content-Type", "application/json"))
        header.append(("Language", Locale.current.identifier))
        header.append(("x-style-version", "\(stylesVersion)"))
        #if DEBUG
        header.append(("Environment", "debug"))
        #else
        header.append(("Environment", "prod"))
        #endif
        if isTokenNeeded {
            if TokenManager.shared.token.isEmpty {
                let token = KeychainManager.shared.retrieveItemFromKeychain(id: KeychainService.token.rawValue, type: String.self) ?? ""
                header.append(("Authorization", "Bearer \(token)"))
            } else {
                header.append(("Authorization", "Bearer \(TokenManager.shared.token)"))
            }
        }
        return header
    }
    
    var urlRequest: URLRequest? {
        let urlString = NetworkPath.baseURL + path

        var components = URLComponents(string: urlString)
        if let parameters {
            components?.queryItems = parameters
        }

        guard let url = components?.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        if let headers {
            headers.forEach {
                request.addValue($0.value, forHTTPHeaderField: $0.key)
            }
        }

        if let body {
            request.httpBody = body
        }

        return request
    }
    
}
