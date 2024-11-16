//
//  NetworkError.swift
//  LifeFlow
//
//  Created by Theo Sementa on 09/03/2024.
//

import Foundation

public enum NetworkError: Error, LocalizedError, Equatable, CaseIterable {
    case notFound
    case unauthorized
    case badRequest
    case parsingError
    case fieldIsIncorrectlyFilled
    case internalError
    case refreshTokenFailed
    case noConnection
    case unknown
    case custom(message: String)
    
    var banner: Banner {
        switch self {
        case .notFound:                 return Banner.NetworkError.notFoundError
        case .unauthorized:             return Banner.NetworkError.unauthorizedError
        case .badRequest:               return Banner.NetworkError.badRequestError
        case .parsingError:             return Banner.NetworkError.parsingError
        case .fieldIsIncorrectlyFilled: return Banner.NetworkError.fieldIsIncorrectlyFilledError
        case .internalError:            return Banner.NetworkError.internalError
        case .refreshTokenFailed:       return Banner.NetworkError.refreshTokenFailedError
        case .noConnection:             return Banner.NetworkError.noConnectionError
        case .unknown:                  return Banner.NetworkError.unknownError
        case .custom(let message):      return Banner(title: message.localized, style: .error)
        }
    }
    
    var statusCode: Int {
        switch self {
        case .notFound:                 return 404
        case .unauthorized:             return 401
        case .badRequest:               return 400
        case .parsingError:             return 422
        case .fieldIsIncorrectlyFilled: return 422
        case .internalError:            return 500
        case .refreshTokenFailed:       return 401
        case .noConnection:             return 503
        case .unknown:                  return 520
        case .custom:                   return 400
        }
    }
    
    public static var allCases: [NetworkError] {
        return [.notFound, .unauthorized, .badRequest, .parsingError, .fieldIsIncorrectlyFilled,
                .internalError, .refreshTokenFailed, .noConnection, .unknown]
    }
    
}

func processResponse(response: URLResponse, method: String?) throws -> HTTPURLResponse {
    guard let httpResponse = response as? HTTPURLResponse else {
        throw NetworkError.internalError
    }
    
    #if DEBUG
    if let url = httpResponse.url {
        print("🛜 \(method ?? "") | \(httpResponse.statusCode) -> \(url)")
    }
    #endif
    
    return httpResponse
}

func mapResponse(response: (data: Data?, response: URLResponse, method: String?)) throws -> Data? {
    let httpResponse = try processResponse(response: response.response, method: response.method)
    
    #if DEBUG
    if let data = response.data {
        print("🛜 DATA : \(String(data: data, encoding: .utf8))")
    }
    #endif
    
    return try handleStatusCode(httpResponse.statusCode, data: response.data)
}

func handleStatusCode(_ statusCode: Int, data: Data? = nil) throws -> Data? {
    if (200..<300).contains(statusCode) {
        return data
    }

    for case let error in NetworkError.allCases where error.statusCode == statusCode {
        throw error
    }

    throw NetworkError.unknown
}
