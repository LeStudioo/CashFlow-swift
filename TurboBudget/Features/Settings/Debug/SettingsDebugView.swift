//
//  SettingsDebugView.swift
//  CashFlow
//
//  Created by Theo Sementa on 07/12/2024.
//

import SwiftUI
import NavigationKit

struct SettingsDebugView: View {
    
    @State private var showOnboarding: Bool = false
    @EnvironmentObject private var router: Router<AppDestination>
    
    // MARK: -
    var body: some View {
        Form {
            Section {
                Button {
                    KeychainManager.shared.setItemToKeychain(id: KeychainService.refreshToken.rawValue, data: "")
                } label: {
                    Text("Reset refresh token")
                }
            }
            
            Section {
                Button {
                    showOnboarding.toggle()
                } label: {
                    Text("Show onboarding")
                }
                Button {
                    router.present(route: .modalFitContent, .tips(.applePayShortcut))
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
