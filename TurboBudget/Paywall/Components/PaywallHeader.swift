//
//  PaywallHeader.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/12/2024.
//

import SwiftUI

struct PaywallHeader: View {
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: -
    var body: some View {
        HStack {
            Spacer()
            Text("paywall_title".localized)
                .font(.boldH2())
                .foregroundStyle(
                    LinearGradient(colors: [.primary500, .primary500.darker(by: 30)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
            Spacer()
        }
        .overlay(alignment: .trailing) {
            Button(action: { dismiss() }, label: {
                Circle()
                    .frame(width: 26, height: 26)
                    .foregroundStyle(.colorMaterial)
                    .overlay {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color(uiColor: .label))
                    }
            })
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    PaywallHeader()
}
