//
//  CashFlowLoader.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import SwiftUI

struct CashFlowLoader: View {
    
    // MARK: -
    var body: some View {
        ProgressView()
            .tint(Color.white)
            .padding()
            .background(
                Circle()
                    .fill(ThemeManager.theme.color)
            )
    } // body
} // struct

// MARK: - Preview
#Preview {
    CashFlowLoader()
}
