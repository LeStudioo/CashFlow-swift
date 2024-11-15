//
//  DataForServer.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

import Foundation

// Helper type to wrap any Encodable
struct AnyEncodable: Encodable {
    private let encodeClosure: (Encoder) throws -> Void
    
    init<T: Encodable>(_ wrapped: T) {
        encodeClosure = wrapped.encode
    }
    
    func encode(to encoder: Encoder) throws {
        try encodeClosure(encoder)
    }
}

final class DataForServer: ObservableObject {
    static var shared = DataForServer()
    
    var accountJSON: String = ""
    var transactionJSON: String = ""
    var automationJSON: String = ""
    var savingsPlanJSON: String = ""
    var budgetsJSON: String = ""
    
    var json: String {
        return "{\(accountJSON),\(transactionJSON),\(automationJSON),\(savingsPlanJSON),\(budgetsJSON)}"
    }
    
    func syncOldDataToServer() async throws {
        guard let url = URL(string: NetworkPath.baseURL + "/sync/old") else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = json.data(using: .utf8)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(TokenManager.shared.token)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        let _ = try mapResponse(response: (nil, response, urlRequest.httpMethod))
    }
}
