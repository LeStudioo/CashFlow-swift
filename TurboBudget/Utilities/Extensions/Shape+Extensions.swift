//
//  Shape+Extensions.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/12/2024.
//

import Foundation
import SwiftUICore

extension Shape {
    func withBorder(color: Color, lineWidth: CGFloat) -> some View {
        self
            .overlay {
                self.stroke(color, lineWidth: lineWidth)
            }
    }
}
