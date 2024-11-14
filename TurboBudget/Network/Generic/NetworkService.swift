//
//  NetworkService.swift
//  LifeFlow
//
//  Created by Theo Sementa on 09/03/2024.
//

import Foundation

// Protocole
public protocol NetworkServiceProtocol {
    func sendRequest<T: Decodable>(apiBuilder: APIRequestBuilder, responseModel: T.Type) async throws -> T
    func sendRequest(apiBuilder: APIRequestBuilder) async throws
}

// Implémentation du service de réseau
public class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private var retryCount = 0
    private let maxRetries = 2
}

extension NetworkService {
    
    public func sendRequest<T: Decodable>(apiBuilder: APIRequestBuilder, responseModel: T.Type) async throws -> T {
        do {
            return try await self.sendRequest(apiBuilder: apiBuilder, responseModel: responseModel, retryCount: 0)
        } catch {
            self.retryCount = 0
            throw error
        }
    }
    
    private func sendRequest<T: Decodable>(apiBuilder: APIRequestBuilder, responseModel: T.Type, retryCount: Int) async throws -> T {
        do {
            guard let urlRequest = apiBuilder.urlRequest else {
                throw NetworkError.badRequest
            }
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let dataToDecode = try mapResponse(response: (data, response, urlRequest.httpMethod)) else {
                throw NetworkError.parsingError
            }
            
            self.retryCount = 0
            
            return try decodeResponse(dataToDecode: dataToDecode, responseModel: responseModel)
        } catch let error as NetworkError {
            if error == .unauthorized {
                if self.retryCount < maxRetries {
                    self.retryCount += 1
                    try await TokenManager.shared.refreshToken()
                    return try await self.sendRequest(apiBuilder: apiBuilder, responseModel: responseModel, retryCount: self.retryCount)
                } else {
                    self.retryCount = 0
                    throw NetworkError.refreshTokenFailed
                }
            } else {
                throw error
            }
        }
    }
    
    private func decodeResponse<T: Decodable>(dataToDecode: Data, responseModel: T.Type) throws -> T {
        do {
            let results = try JSONDecoder().decode(responseModel, from: dataToDecode)
            return results
        } catch {
            print("⚠️ PARSING ERROR : \(error.localizedDescription)")
            throw NetworkError.parsingError
        }
    }
    
}

// MARK: - Without response
extension NetworkService {
    
    public func sendRequest(apiBuilder: APIRequestBuilder) async throws {
        do {
            return try await self.sendRequest(apiBuilder: apiBuilder, retryCount: 0)
        } catch {
            self.retryCount = 0
            throw error
        }
    }
    
    private func sendRequest(apiBuilder: APIRequestBuilder, retryCount: Int) async throws {
        do {
            guard let urlRequest = apiBuilder.urlRequest else { throw NetworkError.badRequest }
            let (_, response) = try await URLSession.shared.data(for: urlRequest)
            let _ = try mapResponse(response: (nil, response, urlRequest.httpMethod))
            self.retryCount = 0
        } catch let error as NetworkError {
            if error == .unauthorized {
                if self.retryCount < maxRetries {
                    self.retryCount += 1
                    try await TokenManager.shared.refreshToken()
                    
                    return try await self.sendRequest(apiBuilder: apiBuilder, retryCount: self.retryCount)
                } else {
                    self.retryCount = 0
                    throw NetworkError.refreshTokenFailed
                }
            } else {
                throw error
            }
        }
    }
    
}

extension NetworkService {
    
    @MainActor
    static func handleError(error: Error) {
        if let error = error as? NetworkError {
            BannerManager.shared.banner = error.banner
        }
    }
    
}
