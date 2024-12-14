//
//  TransactionTypePicker.swift
//  CashFlow
//
//  Created by Theo Sementa on 19/11/2024.
//

import SwiftUI

struct TransactionTypePicker: View {
    
    // builder
    @Binding var selected: TransactionType
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(Word.Classic.typeOfTransaction)
                .padding(.leading, 8)
                .font(.system(size: 12, weight: .regular))
            
            HStack(spacing: 0) {
                ForEach([TransactionType.expense, TransactionType.income], id: \.self) { type in
                    Button {
                        withAnimation { selected = type }
                    } label: {
                        Text(type.name)
                            .lineLimit(1)
                            .foregroundStyle(Color.text)
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                }
            }
            .background {
                GeometryReader { geo in
                    let itemSize = (geo.size.width / 2)
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .foregroundStyle(Color.backgroundComponentSheet)
                        .overlay(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .foregroundStyle(themeManager.theme.color)
                                .frame(width: itemSize)
                                .offset(x: itemSize * CGFloat(selected.rawValue))
                                .animation(.smooth, value: selected)
                        }
                }
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    TransactionTypePicker(selected: .constant(.expense))
}
