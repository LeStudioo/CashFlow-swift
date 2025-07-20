//
//  FrequencyPicker.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/11/2024.
//

import SwiftUI
import TheoKit
import DesignSystemModule
import CoreModule

struct FrequencyPicker: View {
    
    @Binding var selected: SubscriptionFrequency
        
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(Word.Classic.frequency)
                .padding(.leading, 8)
                .font(.system(size: 12, weight: .regular))
            
            HStack(spacing: 0) {
                Spacer()
                Picker(selection: $selected) {
                    ForEach(SubscriptionFrequency.allCases, id: \.self) { type in
                        Text(type.name).tag(type)
                    }
                } label: {
                    Text(selected.name)
                }
                .tint(themeManager.theme.color)
                .padding(8)
            }
            .roundedRectangleBorder(
                TKDesignSystem.Colors.Background.Theme.bg100,
                radius: CornerRadius.medium,
                lineWidth: 1,
                strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
            )
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    FrequencyPicker(selected: .constant(.monthly))
}
