//
//  IsDisplayed.swift
//  CashFlow
//
//  Created by Theo Sementa on 13/08/2024.
//

import SwiftUI

struct IsDisplayed: ViewModifier {
    
    // Builder
    var isDisplayed: Bool
    
    // MARK: -
    func body(content: Content) -> some View {
        if isDisplayed {
            content
        }
    } // End body
    
} // End struct

extension View {
    
    func isDisplayed(_ isDisplayed: Bool) -> some View {
        return modifier(IsDisplayed(isDisplayed: isDisplayed))
    }
    
}
