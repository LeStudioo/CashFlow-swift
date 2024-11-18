//
//  AppManager.swift
//  CarKit
//
//  Created by Theo Sementa on 30/10/2024.
//

import Foundation

final class AppManager: ObservableObject {
    static let shared = AppManager()
    
    @Published var viewState: ViewState = .idle
    
    @Published var selectedTab: Int = 0
    @Published var menuIsPresented: Bool = false
}
