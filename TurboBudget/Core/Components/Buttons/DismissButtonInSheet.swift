//
//  DismissButtonInSheet.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//

import SwiftUI

struct DismissButtonInSheet: View {

    // Environnements
    @Environment(\.dismiss) private var dismiss

    // MARK: -
    var body: some View {
        HStack {
            Spacer()
            Button(action: { dismiss() }, label: {
                Image(systemName: "xmark")
                    .foregroundStyle(Color.text)
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
            })
        }
        .padding(UIDevice.isLittleIphone ? 8 : 12)
        .padding([.top, .trailing], 8)
    } // body
} // struct

// MARK: - Preview
#Preview {
    DismissButtonInSheet()
}
