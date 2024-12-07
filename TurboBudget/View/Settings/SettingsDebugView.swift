//
//  SettingsDebugView.swift
//  CashFlow
//
//  Created by Theo Sementa on 07/12/2024.
//

import SwiftUI

struct SettingsDebugView: View {
    
    // MARK: -
    var body: some View {
        Form {
            Section {
                Button {
                    KeychainManager.shared.setItemToKeychain(id: KeychainService.refreshToken.rawValue, data: "")
                } label: {
                    Text("Reset Refresh Token")
                }
                Button {
                    PersistenceController.clearOldDatabase()
                } label: {
                    Text("Clear local DB")
                }
            }
            
            Section {
                Button {
                    ModalManager.shared.present(TipApplePayShortcutView())
                } label: {
                    Text("Test modal manager")
                }
            }
        }
        .navigationTitle("Debug")
        .navigationBarTitleDisplayMode(.inline)
    } // body
} // struct

// MARK: -
#Preview {
    SettingsDebugView()
}
