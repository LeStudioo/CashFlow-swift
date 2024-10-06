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
    var title: String
    var placeholder: String
    @Binding var text: String
    var style: CustomTextFieldStyle = .text
    
    @FocusState private var isFocused: Bool
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .padding(.leading, 8)
                .font(.system(size: 12, weight: .regular))
            
            HStack(spacing: 0) {
                TextField(placeholder, text: $text)
                    .focused($isFocused)
                    .keyboardType(style == .amount ? .decimalPad : .default)
                    .font(.system(size: 16, weight: .medium))
                    .padding([.vertical, .leading], 14)
                    .padding(.trailing, style == .amount ? 8 : 14)
                    .background {
                        UnevenRoundedRectangle(
                            topLeadingRadius: 16,
                            bottomLeadingRadius: 16,
                            bottomTrailingRadius: style == .amount ? 0 :16,
                            topTrailingRadius: style == .amount ? 0 : 16,
                            style: .continuous
                        )
                        .fill(Color.backgroundComponentSheet)
                    }
                
                if style == .amount {
                    Text(Locale.userLocale.currencySymbol ?? "")
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
                            .fill(Color.backgroundComponentSheet)
                        }
                }
            }
            .onTapGesture {
                isFocused.toggle()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        CustomTextField(
            title: "Preview title",
            placeholder: "Preview placeholder",
            text: .constant(""),
            style: .text
        )
        CustomTextField(
            title: "Preview title",
            placeholder: "Preview placeholder",
            text: .constant(""),
            style: .amount
        )
    }
    .padding()
    .background(Color.background)
}
