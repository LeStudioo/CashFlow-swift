//
//  IsDisplayed.swift
//  CashFlow
//
//  Created by Theo Sementa on 13/08/2024.
//

import SwiftUI

struct IsDisplayedViewModifier: ViewModifier {
    
    // MARK: Dependencies
    var isDisplayed: Bool
    
    // MARK: - View
    func body(content: Content) -> some View {
        if isDisplayed {
            content
        }
    }
}

// MARK: - View Extension
extension View {
    public func isDisplayed(_ isDisplayed: Bool) -> some View {
        return modifier(IsDisplayedViewModifier(isDisplayed: isDisplayed))
    }
}
