//
//  PageControlView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/07/2023.
//

import SwiftUI

struct PageControl: View {
    
    // Builder
    var maxPages: Int
    var currentPage: Int
    
    // MARK: -
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0...(min(1, maxPages)), id: \.self) { index in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(index == currentPage ? ThemeManager.theme.color : Color.colorCell)
            }
        }
    }
}
