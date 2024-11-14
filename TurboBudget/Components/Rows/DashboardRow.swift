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
        VStack(alignment: .leading) {
            HStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .frame(width: 50, height: 50)
                    .foregroundStyle(Color.componentInComponent)
                    .overlay {
                        Image(systemName: config.icon)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.label)
                            .shadow(radius: 2, y: 2)
                    }
                Spacer()
                
                if config.num != 0 {
                    Text(config.num.formatted())
                        .font(.semiBoldText16())
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
            }
            
            Spacer(minLength: 0)
            
            Text(config.text)
                .font(.semiBoldText16())
                .multilineTextAlignment(.leading)
                .lineLimit(2)
        }
        .padding()
        .foregroundStyle(Color.label)
        .frame(maxWidth: .infinity)
        .aspectRatio(1.42, contentMode: .fit)
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
        var num: Int
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
                num: 0,
                isLocked: true
            )
        )
        
        DashboardRow(
            config: .init(
                icon: "House.fill",
                text: "Preview 2",
                num: 3
            )
        )
    }
    .padding()
    .background(Color.primary200)
}
