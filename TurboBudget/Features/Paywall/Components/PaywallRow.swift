//
//  PaywallRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/12/2024.
//

import SwiftUI

struct PaywallRow: View {
    
    // Builder
    var systemName: String
    var title: String
    var text: String
    var color: Color
    var isDetailed: Bool
    
    // MARK: -
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .frame(width: 50)
                .foregroundStyle(color.opacity(0.3))
                .overlay {
                    Image(systemName: systemName)
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundStyle(color)
                }
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.semiBoldText16())
                    .lineLimit(1)
                    .foregroundStyle(Color.text)
                Text(text)
                    .font(Font.mediumSmall())
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .foregroundStyle(Color.customGray)
            }
            .padding(.leading, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if isDetailed {
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.text)
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    PaywallRow(
        systemName: "chart.pie.fill",
        title: "word_budgets".localized,
        text: "paywall_budgets_desc".localized,
        color: .purple,
        isDetailed: true
    )
    .padding(24)
    .background(Color.background)
}
