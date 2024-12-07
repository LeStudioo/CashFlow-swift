//
//  CashFlowButton.swift
//  CashFlow
//
//  Created by Theo Sementa on 07/12/2024.
//

import SwiftUI

struct CashFlowButton: View {
    
    // Builder
    var config: Configuration
    var action: () -> Void
    
    // MARK: -
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(config.text)
                    .frame(
                        maxWidth: .infinity,
                        alignment: config.externalLink ? .leading : .center
                    )
                
                if config.externalLink {
                    Image(systemName: "arrow.up.right")
                }
            }
            .font(.semiBoldText18())
            .foregroundStyle(Color.white)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(config.backgroundColor)
            }
        }
    } // body
} // struct

// MARK: - Configuration
extension CashFlowButton {
    struct Configuration {
        var text: String
        var backgroundColor: Color = ThemeManager.shared.theme.color
        var externalLink: Bool = false
    }
}

// MARK: - Preview
#Preview {
    CashFlowButton(
        config: .init(text: "Cash Flow"),
        action: { }
    )
    .padding()
}
