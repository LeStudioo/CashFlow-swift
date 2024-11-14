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
}
