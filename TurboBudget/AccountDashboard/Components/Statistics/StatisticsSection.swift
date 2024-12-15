//
//  StatisticsSection.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/12/2024.
//

import SwiftUI

struct StatisticsSection<Content: View>: View {
    
    let title: String
    @ViewBuilder let content: () -> Content
    
    // MARK: -
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.Title.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
            
            content()
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    StatisticsSection(title: "Mois") {
        StatisticsCell(title: "Dépenses et revenus totaux", statistics: [
            .init(text: "Dépense cette semaine", value: 45.2),
            .init(text: "Dépense la semaine dernière", value: 754)
        ])
    }
    .padding()
    .background(Color.background)
}
