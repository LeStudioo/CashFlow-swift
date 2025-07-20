//
//  Appearance.swift
//  CoreModule
//
//  Created by Theo Sementa on 20/07/2025.
//

import Foundation
import SwiftUI

// https://medium.com/@nayananp/swiftui-toggle-between-dark-light-system-across-whole-app-e29c7d9d25b3

public class AppearanceManager: ObservableObject {
    @AppStorage("appearance") public var appearance: Appearance = .system
    
    public init() { }
}

public enum Appearance: Int, CaseIterable, Identifiable {
    case system
    case light
    case dark
    
    public var id: Int { self.rawValue }
    
    public var name: String {
        switch self {
        case .system:   return Word.Classic.system
        case .light:    return Word.Classic.light
        case .dark:     return Word.Classic.dark
        }
    }
    
    public var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
}
