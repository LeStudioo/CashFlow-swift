//
//  SettingRow.swift
//  CashFlow
//
//  Created by KaayZenn on 24/02/2024.
//

import SwiftUI

struct SettingRow: View {
    
    // Builder
    var icon: String
    var backgroundColor: Color
    var text: String
    var isButton: Bool
    var isLocked: Bool?
    
    // MARK: - body
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.white)
                .font(.footnote)
                .frame(width: 28, height: 28)
                .background(backgroundColor)
                .cornerRadius(6)
            
            Text(text)
                .foregroundStyle(Color(uiColor: .label))
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let isLocked, isLocked {
                Image(systemName: "lock.fill")
                    .foregroundStyle(Color.secondary)
            } else {
                Image(systemName: isButton ? "arrow.up.forward" : "chevron.right")
                    .foregroundStyle(Color.secondary)
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    SettingRow(
        icon: "person.fill",
        backgroundColor: Color.red,
        text: "Preview",
        isButton: false
    )
}

//Button(action: action) {
//    HStack(spacing: horizontalSpacing) {
//        if let icon {
//            SettingIconView(icon: icon)
//        }
//
//        Text(title)
//            .fixedSize(horizontal: false, vertical: true)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(.vertical, verticalPadding)
//
//        if let indicator {
//            Image(systemName: indicator)
//                .foregroundStyle(settingSecondaryColor)
//        }
//    }
//    .padding(.horizontal, horizontalPadding)
//    .accessibilityElement(children: .combine)
//}
//.buttonStyle(.row)
