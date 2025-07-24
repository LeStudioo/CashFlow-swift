//
//  AppManager.swift
//  CoreModule
//
//  Created by Theo Sementa on 24/07/2025.
//

import Foundation

public final class AppManager: ObservableObject {
    @MainActor public static let shared = AppManager()
    
    @Published public var appState: ApplicationState = .idle
    
    @Published public var selectedTab: Int = 0
    @Published public var isMenuPresented: Bool = false
    
    @Published public var isStartDataLoaded: Bool = false
    @Published public var isRoutersRegistered: Bool = false
}
