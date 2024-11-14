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
}
