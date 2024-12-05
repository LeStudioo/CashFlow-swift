//
//  TransactionDetailNoteRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 05/12/2024.
//

import SwiftUI

struct TransactionDetailNoteRow: View {
    
    // Builder
    @Binding var note: String
    
    @Environment(\.colorScheme) private var colorScheme
    
    // Enum
    enum Field: CaseIterable {
        case note
    }
    @FocusState var focusedField: Field?
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                CustomOrSystemImage(systemImage: "text.quote", size: 12, color: .white)
                    .padding(6)
                    .background {
                        Circle()
                            .fill(Color.componentInComponent)
                    }
                
                Text("word_note".localized)
                    .font(.mediumText16())
                    .foregroundStyle(Color.label)
                
                Spacer()
            }
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $note)
                    .focused($focusedField, equals: .note)
                    .scrollContentBackground(.hidden)
                    .font(Font.mediumText16())
                
                if note.isEmpty {
                    HStack {
                        Text("transaction_detail_note".localized)
                            .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                            .font(Font.mediumText16())
                        Spacer()
                    }
                    .padding([.leading, .top], 8)
                    .onTapGesture { focusedField = .note }
                }
            }
        }
        .frame(minHeight: 120)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.backgroundComponent)
        }
//        .padding(12)
//        .background(Color.colorCell)
//        
//        .cornerRadius(15)
//        .padding(.horizontal, 12)
//        .padding(.vertical, 8)
    } // body
} // struct

// MARK: - 
#Preview {
    TransactionDetailNoteRow(note: .constant(""))
        .padding()
        .background(Color.background)
}
