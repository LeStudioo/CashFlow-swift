//
//  CustomTextField.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/10/2024.
//

import SwiftUI

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
        VStack(alignment: .leading, spacing: 6) {
            Text(config.title)
                .padding(.leading, 8)
                .font(.system(size: 12, weight: .regular))
            
            HStack(spacing: 0) {
                TextField(config.placeholder, text: $text)
                    .focused($isFocused)
                    .keyboardType(config.style == .amount ? .decimalPad : .default)
                    .font(.system(size: 16, weight: .medium))
                    .padding([.vertical, .leading], 14)
                    .padding(.trailing, config.style == .amount ? 8 : 14)
                    .background {
                        UnevenRoundedRectangle(
                            topLeadingRadius: 16,
                            bottomLeadingRadius: 16,
                            bottomTrailingRadius: config.style == .amount ? 0 :16,
                            topTrailingRadius: config.style == .amount ? 0 : 16,
                            style: .continuous
                        )
                        .fill(Color.background200)
                    }
                
                if config.style == .amount {
                    Text(UserCurrency.symbol)
                        .padding(.vertical, 14)
                        .padding(.trailing)
                        .background {
                            UnevenRoundedRectangle(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 16,
                                topTrailingRadius: 16,
                                style: .continuous
                            )
                            .fill(Color.background200)
                        }
                }
            }
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
