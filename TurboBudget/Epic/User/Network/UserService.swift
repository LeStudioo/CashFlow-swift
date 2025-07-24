////
////  UserService.swift
////  CashFlow
////
////  Created by Theo Sementa on 29/04/2025.
////
//
//import Foundation
//import NetworkKit
//
//struct UserService {
//    
//    static func update(body: UserModel) async throws -> UserModel {
//        return try await NetworkService.sendRequest(
//            apiBuilder: UserAPIRequester.update(body: body),
//            responseModel: UserModel.self
//        )
//    }
//    
//}
