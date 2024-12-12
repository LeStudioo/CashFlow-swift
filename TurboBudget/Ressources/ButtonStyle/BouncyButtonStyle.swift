//
//  BouncyButtonStyle.swift
//  CashFlow
//
//  Created by Theo Sementa on 11/12/2024.
//

import SwiftUI

struct BouncyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .bounceSymbolEffect(value: configuration.isPressed)
    }
}

extension View {
    @ViewBuilder
    func bounceSymbolEffect<T: Equatable>(value: T) -> some View {
        if #available(iOS 17.0, *) {
            self.symbolEffect(.bounce, value: value)
        } else {
            self
        }
    }
}
