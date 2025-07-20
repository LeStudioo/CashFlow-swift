//
//  AppearanceManager.swift
//  CashFlow
//
//  Created by Théo Sementa on 05/07/2023.
//

import Foundation
import SwiftUI
import CoreModule

// https://medium.com/@nayananp/swiftui-toggle-between-dark-light-system-across-whole-app-e29c7d9d25b3

enum Appearance: Int, CaseIterable, Identifiable {
    case system
    case light
    case dark
    
    var id: Int { self.rawValue }
    
    var name: String {
        switch self {
        case .system:   return Word.Classic.system
        case .light:    return Word.Classic.light
        case .dark:     return Word.Classic.dark
        }
    }
    
    var colorScheme: ColorScheme? {
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

class AppearanceManager: ObservableObject {
    @AppStorage("appearance") var appearance: Appearance = .system
}
