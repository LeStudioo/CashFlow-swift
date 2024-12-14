//
//  AsyncButton.swift
//  NetworkTemplate
//
//  Created by Theo Sementa on 03/10/2024.
//

import SwiftUI

struct AsyncButton<Label: View>: View {
    
    // Builder
    let action: () async -> Void
    let label: () -> Label
    
    @State private var isLoading = false
    
    // init
    init(action: @escaping () async -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }
    
    // MARK: -
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
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    AsyncButton(action: {}) {
        Text("COUCOU")
    }
}
