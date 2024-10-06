//
//  CustomIntPicker.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/10/2024.
//

import SwiftUI

struct CustomIntPicker: View {
    
    // Builder
    var title: String
    @Binding var number: Int
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .padding(.leading, 8)
                .font(.system(size: 12, weight: .regular))
            
            HStack {
                Spacer()
                Picker("", selection: $number, content: {
                    ForEach(1..<32) { i in
                        Text("\(i)").tag(i)
                    }
                })
                .background {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.componentInComponent)
                }
                .padding(8)
            }
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.backgroundComponentSheet)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CustomIntPicker(
        title: "Preview title",
        number: .constant(1)
    )
    .padding()
}
