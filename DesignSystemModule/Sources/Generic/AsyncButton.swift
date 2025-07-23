//
//  AsyncButton.swift
//  NetworkTemplate
//
//  Created by Theo Sementa on 03/10/2024.
//

import SwiftUI

public struct AsyncButton<Label: View>: View {
    
    // MARK: Dependencies
    let action: () async -> Void
    let label: () -> Label
    
    // MARK: States
    @State private var isLoading = false
    
    // MARK: init
    public init(action: @escaping () async -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }
    
    // MARK: - View
    public var body: some View {
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

// MARK: - Preview
#Preview {
    AsyncButton {} label: {
        Text("COUCOU")
    }
}
