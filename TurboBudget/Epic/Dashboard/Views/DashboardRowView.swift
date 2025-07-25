//
//  DashboardRowView.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

import SwiftUI
import TheoKit
import DesignSystemModule

struct DashboardRowView: View {
    
    // builder
    var config: Configuration
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.large) {
            HStack {
                Image(config.icon)
                    .renderingMode(.template)
                    .foregroundStyle(Color.label)
                    .padding(Padding.small)
                    .roundedRectangleBorder(
                        TKDesignSystem.Colors.Background.Theme.bg200,
                        radius: CornerRadius.small
                    )
                
                Spacer()
                
                Image(.iconArrowRight)
                    .renderingMode(.template)
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
            }
            
            Text(config.text)
                .fontWithLineHeight(.Body.medium)
                .foregroundStyle(Color.label)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
        }
        .padding(Padding.standard)
        .roundedRectangleBorder(
            TKDesignSystem.Colors.Background.Theme.bg100,
            radius: CornerRadius.standard,
            lineWidth: 1,
            strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
        )
        .opacity(config.isLocked ? 0.4 : 1)
        .overlay {
            if config.isLocked {
                Image(.iconDoorLocked)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.label)
                    .frame(width: 40, height: 40)
            }
        }
    } // body
} // struct

// MARK: - Configuration
extension DashboardRowView {
    struct Configuration {
        var icon: ImageResource
        var text: String
        var isLocked: Bool = false
    }
}

// MARK: - Preview
#Preview {
    HStack(spacing: 8) {
        DashboardRowView(
            config: .init(
                icon: .iconPiggyBank,
                text: "Preview 1",
                isLocked: true
            )
        )
        
        DashboardRowView(
            config: .init(
                icon: .iconClockRepeat,
                text: "Preview 2"
            )
        )
    }
    .padding()
    .background(Color.primary200)
}
