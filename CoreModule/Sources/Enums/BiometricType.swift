//
//  BiometricType.swift
//  CoreModule
//
//  Created by Theo Sementa on 20/07/2025.
//

import Foundation

public enum BiometricType {
    case none
    case touch
    case face
    
    public var name: String {
        switch self {
        case .none: return "fail"
        case .touch: return "TouchID"
        case .face: return "FaceID"
        }
    }
}
