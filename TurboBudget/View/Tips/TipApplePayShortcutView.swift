//
//  TipApplePayShortcutView.swift
//  CashFlow
//
//  Created by Theo Sementa on 07/12/2024.
//

import SwiftUI

struct TipApplePayShortcutView: View {
    
    @StateObject private var preferencesGeneral: PreferencesGeneral = .shared
    
    // MARK: -
    var body: some View {
        VStack(spacing: 24) {
            Image(.applePayIllustration)
                .resizable()
                .scaledToFit()
            
            Text(Word.Tips.ApplePay.descOne)
                .font(.mediumText18())
                .multilineTextAlignment(.center)
            
            Text(Word.Tips.ApplePay.descTwo)
                .font(.mediumText18())
                .multilineTextAlignment(.center)
            
            CashFlowButton(
                config: .init(text: Word.Tips.howToDo, externalLink: true),
                action: {
                    preferencesGeneral.isApplePayEnabled = true
                    // TODO: Add url to website
                }
            )
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    TipApplePayShortcutView()
}
