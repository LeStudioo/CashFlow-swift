//
//  SubcategoryRowView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 19/06/2023.
//

import SwiftUI
import TheoKit
import DesignSystemModule

struct SubcategoryRowView: View {
    
    // MARK: Dependencies
    var subcategory: SubcategoryModel
    var selectedDate: Date
    
    // MARK: Environments
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
                    IconSVG(icon: subcategory.icon, value: .medium)
                        .foregroundStyle(Color.white)
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
            
            IconSVG(icon: .iconArrowRight, value: .large)
                .foregroundStyle(Color.label)
        }
        .padding(Padding.medium)
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
    SubcategoryRowView(subcategory: .mock, selectedDate: .now)
}
