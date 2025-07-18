//
//  StatisticsSectionView.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/12/2024.
//

import SwiftUI

struct StatisticsSectionView<Content: View>: View {
    
    let title: String
    @ViewBuilder let content: () -> Content
    
    // MARK: -
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.semiBoldH3())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
            
            VStack(spacing: 20) {
                content()
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.background100)
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    StatisticsSectionView(title: "Mois") {
        StatisticsCellView(title: "Dépenses et revenus totaux", statistics: [
            .init(text: "Dépense cette semaine", value: 45.2),
            .init(text: "Dépense la semaine dernière", value: 754)
        ])
    }
    .padding()
    .background(Color.background)
}
