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
    var isButton: Bool?
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
                .foregroundStyle(Color.text)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let isLocked, isLocked {
                Image(systemName: "lock.fill")
                    .foregroundStyle(Color.secondary)
            } else if let isButton {
                Image(systemName: isButton ? "arrow.up.forward" : "chevron.right")
                    .foregroundStyle(Color.secondary)
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        SettingRow(
            icon: "person.fill",
            backgroundColor: Color.red,
            text: "Preview",
            isButton: false
        )
        
        SettingRow(
            icon: "person.fill",
            backgroundColor: Color.red,
            text: "Preview",
            isButton: true
        )
        
        SettingRow(
            icon: "person.fill",
            backgroundColor: Color.red,
            text: "Preview"
        )
    }
    .padding()
}
