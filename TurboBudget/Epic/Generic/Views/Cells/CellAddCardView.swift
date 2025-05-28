//
//  CellAddCardView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//

import SwiftUI

struct CellAddCardView: View {

    // Builder
    var textHeader: String
    var placeholder: String
    @Binding var text: String
    
    // Environment
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - body
    var body: some View {
        ZStack {
            ZStack(alignment: .topLeading) {
                Capsule()
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .frame(height: 50)
                
                Text(textHeader)
                    .font(Font.mediumText16())
                    .padding(.horizontal, 8)
                    .background(colorScheme == .light ? Color.primary0 : Color.secondary500)
                    .offset(x: 20, y: -12)
            }
            
            TextField(placeholder, text: $text)
                .font(Font.mediumText16())
                .offset(x: 20)
                .padding(.horizontal, 8)
        }
    } // End body
} // Ens struct

// MARK: - Preview
struct CellAddCardView_Previews: PreviewProvider {
    
    @State static private var textPreview: String = ""
    @State static private var valuePreview: Double = 0.0
    
    static var previews: some View {
        CellAddCardView(
            textHeader: "Preview Header",
            placeholder: "Preview Placeholder",
            text: $textPreview
        )
        .padding()
    }
}
