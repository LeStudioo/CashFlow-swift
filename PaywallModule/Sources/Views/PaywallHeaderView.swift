//
//  PaywallHeaderView.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/12/2024.
//

import SwiftUI
import DesignSystemModule

struct PaywallHeaderView: View {
    
    // MARK: Environments
    @Environment(\.dismiss) private var dismiss
    
    // MARK: States
    var isXmarkPresented: Bool = true
    
    // MARK: - View
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
            if isXmarkPresented {
                Button(action: { dismiss() }, label: {
                    Circle()
                        .frame(width: 26, height: 26)
                        .foregroundStyle(Color.background200)
                        .overlay {
                            Image(systemName: "xmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(Color.text)
                        }
                })
            }
        }
    }
}

// MARK: - Preview
#Preview {
    PaywallHeaderView()
}
