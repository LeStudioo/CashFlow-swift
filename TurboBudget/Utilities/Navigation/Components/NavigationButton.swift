//
//  NavigationButton.swift
//  NavigationTemplate
//
//  Created by Theo Sementa on 23/07/2024.
//

import SwiftUI

struct NavigationButton<Label: View>: View {
    private let action: () -> Void
    private let label: () -> Label

    private init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }

    var body: some View {
        Button(action: action, label: label)
    }
}

// MARK: - Push
extension NavigationButton {
    
    public init(
        push: @escaping @autoclosure () -> Void,
        action: (() -> Void)? = nil,
        @ViewBuilder label: @escaping () -> Label) {
            self.init(action: {
                action?()
                push()
            }, label: label)
        }
    
}

// MARK: - Present
extension NavigationButton {
    
    public init(
        present: @escaping @autoclosure () -> Void,
        action: (() -> Void)? = nil,
        @ViewBuilder label: @escaping () -> Label) {
            self.init(action: {
                action?()
                present()
            }, label: label)
        }
    
}
