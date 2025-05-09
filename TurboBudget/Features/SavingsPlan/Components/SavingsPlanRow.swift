//
//  SavingsPlanRow.swift
//  CashFlow
//
//  Created by Théo Sementa on 24/06/2023.
//

import SwiftUI
import TheoKit

struct SavingsPlanRow: View {

    // Custom type
    var savingsPlan: SavingsPlanModel

    // Environnement
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var savingsPlanStore: SavingsPlanStore
    
    var currentSavingsPlan: SavingsPlanModel {
        return savingsPlanStore.savingsPlans.first { $0.id == savingsPlan.id } ?? savingsPlan
    }

    // MARK: -
    var body: some View {
        VStack {
            HStack {
                Rectangle()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg200)
                    .cornerRadius(TKDesignSystem.Radius.small)
                    .overlay {
                        Text(currentSavingsPlan.emoji ?? "")
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                    }
                
                Spacer()
                
                Image(.iconArrowRight)
                    .renderingMode(.template)
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
            }
                        
            VStack(spacing: 0) {
                Text("\((savingsPlan.currentAmount ?? 0).toCurrency())")
                    .fontWithLineHeight(DesignSystem.Fonts.Title.large)
                    .foregroundStyle(Color.label)
                Text("/ \((savingsPlan.goalAmount ?? 0).toCurrency())")
                    .fontWithLineHeight(DesignSystem.Fonts.Label.large)
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
            }
            .frame(maxHeight: .infinity)
                                   
            Text(currentSavingsPlan.name ?? "")
                .fontWithLineHeight(DesignSystem.Fonts.Body.medium)
                .foregroundStyle(Color.label)
                .lineLimit(1)                  
        }
        .padding(TKDesignSystem.Padding.standard)
        .aspectRatio(1, contentMode: .fit)
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
    SavingsPlanRow(savingsPlan: .mockClassicSavingsPlan)
        .environmentObject(ThemeManager())
        .environmentObject(SavingsPlanStore())
        .frame(width: 180)
        .padding()
        .background(Color.background)
}
