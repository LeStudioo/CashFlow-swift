//
//  ModalManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 07/12/2024.
//

import Foundation
import SwiftUICore

final class ModalManager: ObservableObject {
    static let shared = ModalManager()
    
    @Published var isPresented: Bool = false
    @Published var currentHeight: CGFloat = 0
    
    @Published var content: (any View)?
}

extension ModalManager {
    
    func present(_ content: (any View)) {
        self.content = content
        isPresented = true
    }
    
}

extension ModalManager {
    
    func presentTipApplePayShortcut() {
        present(TipApplePayShortcutView())
    }
    
}
