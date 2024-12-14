//
//  NotSyncedView.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import SwiftUI

struct NotSyncedView: View {
    
    @EnvironmentObject private var appManager: AppManager
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text(Word.Sync.sorryMessage)
                .font(.semiBoldH3())
                .multilineTextAlignment(.center)
            Spacer()
            VStack(spacing: 16) {
                AsyncButton {
                    appManager.viewState = .syncing
                    do {
                        try await DataForServer.shared.syncOldDataToServer()
                        PersistenceController.clearOldDatabase()
                        appManager.viewState = .success
                    } catch {
                        appManager.viewState = .notSynced
                    }
                } label: {
                    Text(Word.Classic.retry)
                        .foregroundStyle(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            Capsule()
                                .fill(themeManager.theme.color)
                        }
                }
                
                Button {
                    PersistenceController.clearOldDatabase()
                    appManager.viewState = .success
                } label: {
                    Text(Word.Sync.continueWithoutData)
                        .foregroundStyle(Color.blue)
                }
            }
        }
        .padding()
    } // body
} // struct

// MARK: - Preview
#Preview {
    NotSyncedView()
        .environmentObject(AppManager())
}
