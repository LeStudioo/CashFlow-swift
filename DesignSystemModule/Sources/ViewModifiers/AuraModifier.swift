//
//  File.swift
//  DesignSystemModule
//
//  Created by Theo Sementa on 24/07/2025.
//

import Foundation
import SwiftUI
import TheoKit

struct AuraModifier: ViewModifier {
    
    // MARK: Dependencies
    let color: Color
    let radius: CGFloat
    let alignment: Alignment
    let offsetY: CGFloat
    let padding: CGFloat
    
    @State private var contentWidth: CGFloat = 0
    
    // MARK: - View
    func body(content: Content) -> some View {
        content
            .background(alignment: alignment) {
                Ellipse()
                    .fill(color)
                    .getSize { contentWidth = $0.height }
                    .frame(width: contentWidth + padding, height: 120)
                    .blur(radius: radius)
                    .offset(y: offsetY)
            }
    }
    
}

// MARK: - View extension
public extension View {
    func auraEffect(
        color: Color = .primary500,
        radius: CGFloat = 140,
        alignment: Alignment = .top,
        offsetY: CGFloat = 20,
        padding: CGFloat = 64
    ) -> some View {
        self.modifier(
            AuraModifier(
                color: color,
                radius: radius,
                alignment: alignment,
                offsetY: offsetY,
                padding: padding
            )
        )
    }
}
