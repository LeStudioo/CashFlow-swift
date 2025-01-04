//
//  BudgetService.swift
//  CashFlow
//
//  Created by Theo Sementa on 01/01/2025.
//

import Foundation

struct BudgetService {
    
    static func fetchAll(for accountID: Int) async throws -> [BudgetModel] {
        return try await NetworkService.shared.sendRequest(
            apiBuilder: BudgetAPIRequester.fetch(accountID: accountID),
            responseModel: [BudgetModel].self
        )
    }
    
    static func create(accountID: Int, body: BudgetModel) async throws -> BudgetModel {
        return try await NetworkService.shared.sendRequest(
            apiBuilder: BudgetAPIRequester.create(accountID: accountID, body: body),
            responseModel: BudgetModel.self
        )
    }
    
    static func update(budgetID: Int, body: BudgetModel) async throws -> BudgetModel {
        return try await NetworkService.shared.sendRequest(
            apiBuilder: BudgetAPIRequester.update(budgetID: budgetID, body: body),
            responseModel: BudgetModel.self
        )
    }
    
    static func delete(budgetID: Int) async throws {
        try await NetworkService.shared.sendRequest(
            apiBuilder: BudgetAPIRequester.delete(budgetID: budgetID)
        )
    }
    
}
