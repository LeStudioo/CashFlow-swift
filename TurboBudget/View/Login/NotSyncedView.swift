//
//  NotSyncedView.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import SwiftUI

struct NotSyncedView: View {
    
    @EnvironmentObject private var appManager: AppManager
    
    // MARK: -
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("Désolé, nous n'avons pas pu récupérer vos données...") // TBL
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
                    Text("Reesayer") // TBL
                        .foregroundStyle(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            Capsule()
                                .fill(ThemeManager.theme.color)
                        }
                }
                
                Button {
                    PersistenceController.clearOldDatabase()
                    appManager.viewState = .success
                } label: {
                    Text("Continuer sans mes données") // TBL
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
