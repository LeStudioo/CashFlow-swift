//
//  CreditCardTextField.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/12/2024.
//

import SwiftUI

struct CreditCardTextField: View {
    
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
                    .keyboardType(.decimalPad)
                    .font(.system(size: 16, weight: .medium))
                    .padding([.vertical, .leading], 14)
                    .padding(.trailing, 14)
                    .background {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.backgroundComponentSheet)
                    }
                    .onChange(of: text) { newValue in
                        text = newValue
                            .replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                            .prefix(16)
                            .enumerated()
                            .map { $0.offset % 4 == 0 && $0.offset > 0 ? " " + String($0.element) : String($0.element) }
                            .joined()
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
            isFocused.toggle()
        }
    } // body
} // struct

extension CreditCardTextField {
    struct Configuration {
        var title: String
        var placeholder: String
    }
}

// MARK: - Preview
#Preview {
    CreditCardTextField(
        text: .constant(""),
        config: .init(
            title: "Preview title",
            placeholder: "Preview placeholder"
        )
    )
}
