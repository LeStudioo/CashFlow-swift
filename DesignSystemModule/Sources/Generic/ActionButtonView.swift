//
//  SwiftUIView.swift
//  DesignSystemModule
//
//  Created by Theo Sementa on 24/07/2025.
//

import SwiftUI
import TheoKit
import CoreModule

public enum ActionButtonStyle {
    case plain
    
    public var backgroundColor: AnyShapeStyle {
        switch self {
        case .plain:
            return AnyShapeStyle(LinearGradient(
                colors: [Color.primary500, Color.primary500.darker(by: 15)],
                startPoint: .top,
                endPoint: .bottom
            ))
        }
    }
}

public struct ActionButtonView: View {
    
    // MARK: Dependencies
    let style: ActionButtonStyle
    let title: String
    let action: () async -> Void
    
    // MARK: Init
    public init(
        style: ActionButtonStyle = .plain,
        title: String,
        action: @escaping () async -> Void
    ) {
        self.style = style
        self.title = title
        self.action = action
    }
    
    // MARK: - View
    public var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            Text(title)
                .fontWithLineHeight(.Body.mediumBold)
                .foregroundStyle(Color.white)
                .fullWidth(.center)
                .padding(Padding.standard)
                .background(style.backgroundColor, in: .rect(cornerRadius: CornerRadius.large, style: .continuous))
        }
    }
}

// MARK: - Preview
#Preview {
    ActionButtonView(style: .plain, title: "Preview") { }
}
