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
            HStack(spacing: 40) {
                TabBarItem(
                    icon: .iconHouse,
                    title: "word_home".localized,
                    tag: 0
                )
                
                TabBarItem(
                    icon: .iconLineChart,
                    title: "word_analytic".localized,
                    tag: 1
                )
            }
            .padding(.bottom, 16)
            .padding(.trailing, 24)
            .frame(height: 70)
            .fullWidth(.trailing)
            
            HStack(spacing: 40) {
                TabBarItem(
                    icon: .iconCreditCard,
                    title: "word_account".localized,
                    tag: 2
                )
                
                TabBarItem(
                    icon: .iconPackage,
                    title: "word_type".localized,
                    tag: 3
                )
            }
            .padding(.bottom, 16)
            .padding(.leading, 24)
            .frame(height: 70)
            .fullWidth(.leading)
        }
        .padding(.horizontal, 4)
        .frame(height: 90)
        .frame(maxWidth: .infinity)
    } // body
} // struct
