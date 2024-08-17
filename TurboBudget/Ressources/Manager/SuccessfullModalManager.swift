//
//  SuccessfullModalManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/08/2024.
//

import SwiftUI

final class SuccessfullModalManager: ObservableObject {
    static let shared = SuccessfullModalManager()
    
    @Published var isPresenting: Bool = false
    
    @Published var title: String = ""
    @Published var subtitle: String = ""
    @Published var content: any View = EmptyView()
    
}

extension SuccessfullModalManager {
    
    func resetData() {
        self.title = ""
        self.subtitle = ""
        self.content = EmptyView()
    }
    
}
