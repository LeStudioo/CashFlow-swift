//
//  FontWithLineHeight.swift
//  CashFlow
//
//  Created by Theo Sementa on 07/05/2025.
//

import SwiftUI

struct FontWithLineHeightViewModifier: ViewModifier {
    let font: ExtendedUIFont
    
    var uiFont: UIFont {
        return UIFont(name: font.name, size: font.size) ?? UIFont.systemFont(ofSize: font.size)
    }

    func body(content: Content) -> some View {
        content
            .font(Font(uiFont))
            .lineSpacing(font.lineHeight - uiFont.lineHeight)
            .padding(.vertical, (font.lineHeight - uiFont.lineHeight) / 2)
    }
}

extension View {
    func fontWithLineHeight(_ font: ExtendedUIFont) -> some View {
        return modifier(FontWithLineHeightViewModifier(font: font))
    }
}
