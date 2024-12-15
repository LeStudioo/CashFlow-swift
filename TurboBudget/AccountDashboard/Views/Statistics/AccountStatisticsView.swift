//
//  AccountStatisticsView.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/12/2024.
//

import SwiftUI

struct AccountStatisticsView: View {
    
    // MARK: -
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                StatisticsSection(title: Word.Temporality.week) {
                    StatisticsCell(
                        title: "TBL Dépenses et Revenus totaux",
                        statistics: [
                            
                        ]
                    )
                }
                
                StatisticsSection(title: Word.Temporality.month) {
                    StatisticsCell(
                        title: "TBL Dépenses et Revenus totaux",
                        statistics: [
                            
                        ]
                    )
                }
                
                StatisticsSection(title: Word.Temporality.year) {
                    VStack(spacing: 16) {
                        StatisticsCell(
                            title: "TBL Dépenses et Revenus totaux",
                            statistics: [
                                
                            ]
                        )
                        StatisticsCell(
                            title: "TBL Moyenne par mois",
                            statistics: [
                                
                            ]
                        )
                        StatisticsCell(
                            title: "TBL Moyenne par semaine",
                            statistics: [
                                
                            ]
                        )
                    }
                }
            }
        } // ScrollView
    } // body
} // struct

// MARK: - Preview
#Preview {
    AccountStatisticsView()
}
