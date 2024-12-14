//
//  IntTextField.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/12/2024.
//

import SwiftUI

struct IntTextField: View {
    
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
                    .keyboardType(.numberPad)
                    .font(.system(size: 16, weight: .medium))
                    .padding([.vertical, .leading], 14)
                    .padding(.trailing, 14)
                    .background {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.backgroundComponentSheet)
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
            isFocused.toggle()
        }
    } // body
} // struct

extension IntTextField {
    struct Configuration {
        var title: String
        var placeholder: String
    }
}

// MARK: - Preview
#Preview {
    IntTextField(
        text: .constant(""),
        config: .init(
            title: "Title",
            placeholder: "Placeholder"
        )
    )
}
