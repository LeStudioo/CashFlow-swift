//
//  CustomTextField.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/10/2024.
//

import SwiftUI
import TheoKit
import DesignSystemModule
import CoreModule

enum CustomTextFieldStyle {
    case text
    case amount
}

struct CustomTextField: View {
    
    // Builder
    @Binding var text: String
    var config: Configuration
    
    @FocusState private var isFocused: Bool
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.extraSmall) {
            Text(config.title)
                .padding(.leading, Spacing.small)
                .font(.system(size: 12, weight: .regular))
            
            HStack(spacing: 0) {
                TextField(config.placeholder, text: $text)
                    .focused($isFocused)
                    .keyboardType(config.style == .amount ? .decimalPad : .default)
                    .fontWithLineHeight(.Body.medium)
                    .padding([.vertical, .leading], Padding.regular)
                    .padding(.trailing, config.style == .amount ? 8 : Padding.regular)
                
                if config.style == .amount {
                    Text(UserCurrency.symbol)
                        .padding(.vertical, Padding.regular)
                        .padding(.trailing)
                }
            }
            .roundedRectangleBorder(
                TKDesignSystem.Colors.Background.Theme.bg100,
                radius: CornerRadius.medium,
                lineWidth: 1,
                strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
            isFocused.toggle()
        }
    } // End body
} // End struct

extension CustomTextField {
    struct Configuration {
        var title: String
        var placeholder: String
        var style: CustomTextFieldStyle = .text
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        CustomTextField(
            text: .constant(""),
            config: .init(
                title: "Preview title",
                placeholder: "Preview placeholder",
                style: .text
            )
        )
        CustomTextField(
            text: .constant(""),
            config: .init(
                title: "Preview title",
                placeholder: "Preview placeholder",
                style: .amount
            )
        )
    }
    .padding()
    .background(Color.black.opacity(0.2))
}
