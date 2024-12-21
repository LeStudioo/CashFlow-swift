//
//  StatisticsCell.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/12/2024.
//

import SwiftUI

struct StatisticsCell: View {
    
    let title: String
    let statistics: [Statistics]
    
    // MARK: -
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.Body.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 6) {
                ForEach(statistics) { statistic in
                    StatisticsRow(text: statistic.text, value: statistic.value.toCurrency())
                }
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        StatisticsCell(title: "Dépenses et revenus totaux", statistics: [
            .init(text: "Dépense cette semaine", value: 45.2),
            .init(text: "Dépense la semaine dernière", value: 754)
        ])
    }
    .padding()
    .background(Color.background)
}
