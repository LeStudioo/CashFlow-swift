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
                    .format($text, type: .creditCard)
                    .focused($isFocused)
                    .keyboardType(.numberPad)
                    .font(.system(size: 16, weight: .medium))
                    .padding([.vertical, .leading], 14)
                    .padding(.trailing, 14)
                    .background {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.Background.bg200)
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
