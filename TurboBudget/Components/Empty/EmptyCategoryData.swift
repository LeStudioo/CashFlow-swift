//
//  EmptyCategoryData.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import SwiftUI

struct EmptyCategoryData: View {
    
    @EnvironmentObject private var categoryRepository: CategoryRepository
    
    // MARK: -
    var body: some View {
        VStack(spacing: 16) {
            Image("NoSpend\(ThemeManager.theme.nameNotLocalized)")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 64)
            
            Text("error_message_no_data_month".localized)
                .font(Font.mediumText16())
                .multilineTextAlignment(.center)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.colorCell)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    EmptyCategoryData()
        .padding()
        .background(Color.primary100)
}
