//
//  DashboardRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

import SwiftUI

struct DashboardRow: View {
    
    // builder
    var config: Configuration
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            HStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .frame(width: 50, height: 50)
                    .foregroundStyle(Color.componentInComponent)
                    .overlay {
                        Image(systemName: config.icon)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.text)
                            .shadow(radius: 2, y: 2)
                    }
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
            }
                        
            Text(config.text)
                .font(.semiBoldText16())
                .multilineTextAlignment(.leading)
                .lineLimit(2)
        }
        .padding()
        .foregroundStyle(Color.text)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.colorCell)
        }
        .opacity(config.isLocked ? 0.4 : 1)
        .overlay {
            if config.isLocked {
                Image(systemName: "lock.fill")
                    .font(.system(size: 32, weight: .semibold))
            }
        }
    } // body
} // struct

// MARK: - Configuration
extension DashboardRow {
    struct Configuration {
        var icon: String
        var text: String
        var isLocked: Bool = false
    }
}

// MARK: - Preview
#Preview {
    HStack(spacing: 8) {
        DashboardRow(
            config: .init(
                icon: "person.fill",
                text: "Preview 1",
                isLocked: true
            )
        )
        
        DashboardRow(
            config: .init(
                icon: "House.fill",
                text: "Preview 2"
            )
        )
    }
    .padding()
    .background(Color.primary200)
}
