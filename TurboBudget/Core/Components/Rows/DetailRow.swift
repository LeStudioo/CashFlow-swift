//
//  DetailRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 05/12/2024.
//

import SwiftUI

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
                    size: 12,
                    color: text == nil ? .black : Color.text
                )
                .padding(6)
                .background {
                    Circle()
                        .fill(iconBackgroundColor)
                }
                if let text {
                    Text(text)
                        .font(.mediumText16())
                        .foregroundStyle(Color.text)
                        .lineLimit(1)
//                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: true, vertical: true)
                }
                
                Text(value)
                    .font(.semiBoldText16())
                    .foregroundStyle(Color.text)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.background100)
            }
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
