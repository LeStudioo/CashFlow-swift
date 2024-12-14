//
//  SettingsDebugView.swift
//  CashFlow
//
//  Created by Theo Sementa on 07/12/2024.
//

import SwiftUI

struct SettingsDebugView: View {
    
    @State private var showOnboarding: Bool = false
    
    // MARK: -
    var body: some View {
        Form {
            Section {
                Button {
                    KeychainManager.shared.setItemToKeychain(id: KeychainService.refreshToken.rawValue, data: "")
                } label: {
                    Text("Reset refresh token")
                }
                Button {
                    PersistenceController.clearOldDatabase()
                } label: {
                    Text("Clear local DB")
                }
            }
            
            Section {
                Button {
                    showOnboarding.toggle()
                } label: {
                    Text("Show onboarding")
                }
                Button {
                    ModalManager.shared.present(TipApplePayShortcutView())
                } label: {
                    Text("Show tip Apple Pay")
                }
            }
        }
        .navigationTitle("Debug")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showOnboarding, content: { OnboardingView().interactiveDismissDisabled() })
    } // body
} // struct

// MARK: -
#Preview {
    SettingsDebugView()
}
