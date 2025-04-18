//
//  WhatsNewRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 05/12/2024.
//

import SwiftUI

struct WhatsNewRow: View {
    
    // Builder
    var icon: String
    var iconColor: Color
    var title: String
    var message: String
    
    // MARK: -
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .frame(width: 50)
                .foregroundStyle(iconColor)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(message)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    VStack(spacing: 24) {
        WhatsNewRow(
            icon: "swift",
            iconColor: .orange,
            title: "Showcase your new App Features",
            message: "Present your latest App Features to your users just like Apple."
        )
        
        WhatsNewRow(
            icon: "pencil",
            iconColor: .red,
            title: "Showcase your new App Features",
            message: "Present your latest App Features to your users just like Apple."
        )
    }
    .padding(24)
    .background(Color.background)
}
