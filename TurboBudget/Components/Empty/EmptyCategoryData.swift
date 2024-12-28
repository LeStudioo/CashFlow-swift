//
//  EmptyCategoryData.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import SwiftUI

struct EmptyCategoryData: View {
    
    @EnvironmentObject private var categoryRepository: CategoryStore
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        VStack(spacing: 16) {
            Image("NoSpend\(themeManager.theme.nameNotLocalized)")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 64)
            
            Text("error_message_no_data_month".localized)
                .font(Font.mediumText16())
                .multilineTextAlignment(.center)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    EmptyCategoryData()
        .padding()
        .background(Color.primary100)
}
