//
//  CreditCardShape.swift
//  CashFlow
//
//  Created by Theo Sementa on 13/12/2024.
//

import SwiftUI

struct CreditCardShape: View {
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(themeManager.theme.color)
            .aspectRatio(1.58, contentMode: .fit)
            .overlay(alignment: .leading) {
                GeometryReader { geo in
                    UnevenRoundedRectangle(
                        topLeadingRadius: 16,
                        bottomLeadingRadius: 16,
                        bottomTrailingRadius: 200,
                        topTrailingRadius: 200,
                        style: .continuous
                    )
                    .fill(themeManager.theme.color.darker(by: 10))
                    .frame(width: geo.size.width * 0.85)
                }
            }
            .overlay(alignment: .leading) {
                GeometryReader { geo in
                    UnevenRoundedRectangle(
                        topLeadingRadius: 16,
                        bottomLeadingRadius: 16,
                        bottomTrailingRadius: 200,
                        topTrailingRadius: 200,
                        style: .continuous
                    )
                    .fill(themeManager.theme.color.darker(by: 20))
                    .frame(width: geo.size.width * 0.65)
                }
            }
    } // body
} // struct

// MARK: - Preview
#Preview {
    CreditCardShape()
        .environmentObject(ThemeManager())
        .padding()
}
