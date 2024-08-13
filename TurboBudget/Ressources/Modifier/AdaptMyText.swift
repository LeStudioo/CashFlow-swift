//
//  AdaptMyText.swift
//  CashFlow
//
//  Created by KaayZenn on 10/09/2023.
//

import Foundation
import SwiftUI

struct AdaptMyText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaledToFill()
            .minimumScaleFactor(0.01)
            .lineLimit(1)
    }
}

extension View {
    func adaptText() -> some View {
        modifier(AdaptMyText())
    }
}

