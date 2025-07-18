//
//  StatisticsRowView.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/12/2024.
//

import SwiftUI

struct StatisticsRowView: View {
    
    // Builder
    var text: String
    var value: String
    
    // MARK: -
    var body: some View {
        HStack(spacing: 8) {
            Text(text)
                .font(.regularSmall())
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(value)
                .font(.semiBoldText16())
                .fixedSize(horizontal: false, vertical: false)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        StatisticsRowView(text: "Dépense cette semaine", value: 134.toCurrency())
    }
    .padding()
    .background(Color.background)
}
