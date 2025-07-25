//
//  TipApplePayShortcutScreen.swift
//  CashFlow
//
//  Created by Theo Sementa on 07/12/2024.
//

import SwiftUI
import CoreModule
import PreferencesModule

struct TipApplePayShortcutScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var preferencesGeneral: PreferencesGeneral = .shared
    
    // MARK: -
    var body: some View {
        VStack(spacing: 24) {
            Image(.applePayIllustration)
                .resizable()
                .scaledToFit()
                .padding(.horizontal)
            
            Text(Word.Tips.ApplePay.descOne)
                .font(.mediumText18())
                .multilineTextAlignment(.center)
            
            Text(Word.Tips.ApplePay.descTwo)
                .font(.mediumText18())
                .multilineTextAlignment(.center)
            
            VStack(spacing: 16) {
                CashFlowButton(
                    config: .init(text: Word.Tips.howToDo, externalLink: true),
                    action: {
                        preferencesGeneral.isApplePayEnabled = true
                        dismiss()
                        URLManager.openURL(url: URLManager.PredefinedURL.Tutos.importFromApplePay.rawValue)
                    }
                )
                
                Button {
                    preferencesGeneral.isApplePayEnabled = true
                    dismiss()
                } label: {
                    Text(Word.Tips.alreadyHaveShortcut)
                }
            }
        }
        .padding(24)
    } // body
} // struct

// MARK: - Preview
#Preview {
    TipApplePayShortcutScreen()
}
