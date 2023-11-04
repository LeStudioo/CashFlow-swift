//
//  Conditional Modifier.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//

import Foundation
import SwiftUI

// https://www.avanderlee.com/swiftui/conditional-view-modifier/
extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
