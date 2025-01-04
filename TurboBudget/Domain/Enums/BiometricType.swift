//
//  BiometricType.swift
//  CashFlow
//
//  Created by Theo Sementa on 04/01/2025.
//

import Foundation

enum BiometricType {
    case none
    case touch
    case face
    
    var name: String {
        switch self {
        case .none: return "fail"
        case .touch: return "TouchID"
        case .face: return "FaceID"
        }
    }
}
