//
//  TransactionDetailNoteRowView.swift
//  CashFlow
//
//  Created by Theo Sementa on 05/12/2024.
//

import SwiftUI

struct TransactionDetailNoteRowView: View {
    
    // Builder
    @Binding var note: String
        
    // Enum
    enum Field: CaseIterable {
        case note
    }
    @FocusState var focusedField: Field?
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text(Word.Classic.note)
                    .font(.mediumText16())
                    .foregroundStyle(Color.text)
                
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
                            .foregroundStyle(Color.customGray)
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
                .fill(Color.background100)
        }
    } // body
} // struct

// MARK: - 
#Preview {
    TransactionDetailNoteRowView(note: .constant(""))
        .padding()
        .background(Color.background)
}
