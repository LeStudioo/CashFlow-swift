//
//  CustomEmptyView.swift
//  CashFlow
//
//  Created by Theo Sementa on 22/10/2024.
//

import SwiftUI

struct CustomEmptyView: View {
    
    // builder
    var imageName: String
    var description: String
    
    // MARK: -
    var body: some View {
        VStack(spacing: 16) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .shadow(radius: 4, y: 4)
                .frame(width:  UIScreen.main.bounds.width / (isIPad ? 3 : 1.5))
            
            Text(description)
                .font(.semiBoldText16())
                .multilineTextAlignment(.center)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    } // body
} // struct

// MARK: - Preview
#Preview {
    CustomEmptyView(
        imageName: "NoAccount\(ThemeManager.theme.nameNotLocalized)",
        description: "Preview description"
    )
}
