//
//  DelayedButton.swift
//  CashFlow
//
//  Created by Theo Sementa on 30/12/2024.
//

import SwiftUI

struct DelayedButton<Label: View>: View {
    let action: () -> Void
    let label: () -> Label
    let delay: TimeInterval
    
    @State private var isEnabled = true
    
    init(delay: TimeInterval = 0.5, action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
        self.delay = delay
    }
    
    var body: some View {
        Button {
            if isEnabled {
                isEnabled = false
                action()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    isEnabled = true
                }
            }
        } label: {
            label()
                .opacity(isEnabled ? 1 : 0.5)
        }
        .disabled(!isEnabled)
    }
}
