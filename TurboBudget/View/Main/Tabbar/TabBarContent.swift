//
//  TabBarContent.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

import SwiftUI

struct TabBarContent: View {
        
    // MARK: -
    var body: some View {
        HStack(alignment: .center, spacing: 100) {
            HStack {
                TabBarItem(
                    icon: "house",
                    title: "word_home".localized,
                    tag: 0
                )
                
                TabBarItem(
                    icon: "chart.bar",
                    title: "word_analytic".localized,
                    tag: 1
                )
            }
            .padding(.bottom, 16)
            .frame(height: 70)
            .frame(maxWidth: .infinity)
            
            HStack {
                TabBarItem(
                    icon: "creditcard",
                    title: "word_account".localized,
                    tag: 3
                )
                
                TabBarItem(
                    icon: "rectangle.stack",
                    title: "word_type".localized,
                    tag: 4
                )
            }
            .padding(.bottom, 16)
            .frame(height: 70)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 4)
        .frame(height: 90)
        .frame(maxWidth: .infinity)
    } // body
} // struct
