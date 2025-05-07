//
//  DetailRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 05/12/2024.
//

import SwiftUI
import TheoKit

struct DetailRow: View {
    
    // Builder
    var icon: String
    var text: String?
    var value: String
    var iconBackgroundColor: Color = .background200
    var action: (() -> Void)?
    
    // MARK: -
    var body: some View {
        Button {
            if let action { action() }
        } label: {
            HStack(spacing: 8) {
                CustomOrSystemImage(
                    systemImage: icon,
                    size: 10,
                    color: text == nil ? .black : Color.text
                )
                .padding(6)
                .background {
                    Circle()
                        .fill(iconBackgroundColor)
                }
                if let text {
                    Text(text)
                        .fontWithLineHeight(DesignSystem.Fonts.Body.small)
                        .foregroundStyle(Color.label)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: true)
                }
                
                Text(value)
                    .fontWithLineHeight(DesignSystem.Fonts.Body.medium)
                    .foregroundStyle(Color.label)
                    .multilineTextAlignment(.trailing)
                    .fullWidth(.trailing)
            }
            .padding()
            .roundedRectangleBorder(
                TKDesignSystem.Colors.Background.Theme.bg100,
                radius: TKDesignSystem.Radius.standard,
                lineWidth: 1,
                strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
            )
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        DetailRow(
            icon: "tshirt.fill",
            value: "Vêtements, Chaussures, Accessoires",
            iconBackgroundColor: Color.red
        )
        
        DetailRow(
            icon: "tshirt.fill",
            text: "Date",
            value: "Vêtements, Chaussures, Accessoires",
            iconBackgroundColor: Color.red
        )
    }
    .padding()
    .background(Color.background)
}
