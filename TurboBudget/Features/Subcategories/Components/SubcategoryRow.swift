//
//  SubcategoryRow.swift
//  TurboBudget
//
//  Created by Théo Sementa on 19/06/2023.
//

import SwiftUI
import TheoKit

struct SubcategoryRow: View {
    
    // Custom type
    var subcategory: SubcategoryModel
    var selectedDate: Date
    
    @EnvironmentObject private var transactionStore: TransactionStore
    
    // Computed var
    var stringAmount: String {
        return transactionStore.getExpenses(for: subcategory, in: selectedDate)
            .compactMap(\.amount)
            .reduce(0, +)
            .toCurrency()
    }
    
    // MARK: -
    var body: some View {
        HStack {
            Circle()
                .foregroundStyle(subcategory.color)
                .frame(width: 36, height: 36)
                .overlay {
                    CustomOrSystemImage(
                        systemImage: subcategory.icon,
                        size: 16
                    )
                }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(subcategory.name)
                    .fontWithLineHeight(DesignSystem.Fonts.Body.mediumBold)
                    .foregroundStyle(Color.label)
                    .lineLimit(1)
                
                Text(stringAmount)
                    .fontWithLineHeight(DesignSystem.Fonts.Body.small)
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                    .lineLimit(1)
            }
            .fullWidth(.leading)
            
            Image(.iconArrowRight)
                .renderingMode(.template)
                .foregroundStyle(Color.white)
        }
        .padding(TKDesignSystem.Padding.medium)
        .roundedRectangleBorder(
            TKDesignSystem.Colors.Background.Theme.bg100,
            radius: TKDesignSystem.Radius.standard,
            lineWidth: 1,
            strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
        )
    } // body
} // struct

// MARK: - Preview
#Preview {
    SubcategoryRow(subcategory: .mock, selectedDate: .now)
}
