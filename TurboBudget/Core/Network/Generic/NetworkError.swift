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
