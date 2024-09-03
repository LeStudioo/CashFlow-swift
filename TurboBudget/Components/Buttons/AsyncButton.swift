//
//  AsyncButton.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/09/2024.
//

import SwiftUI

struct AsyncButton<Label: View>: View {
    let action: () async -> Void
    let label: () -> Label
    
    @State private var isLoading = false
    
    init(action: @escaping () async -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }
    
    var body: some View {
        Button {
            Task {
                isLoading = true
                await action()
                isLoading = false
            }
        } label: {
            label()
        }
        .disabled(isLoading)
    }
}
