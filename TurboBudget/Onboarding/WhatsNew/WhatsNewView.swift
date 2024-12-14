//
//  WhatsNewView.swift
//  CashFlow
//
//  Created by Theo Sementa on 05/12/2024.
//

import SwiftUI

struct WhatsNewView: View {
    
    @StateObject private var preferencesGeneral: PreferencesGeneral = .shared
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: -
    var body: some View {
        VStack(spacing: 32) {
            VStack {
                Text(Word.WhatsNew.title)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("v\(Bundle.main.releaseVersionNumber ?? "")")
                    .fontWeight(.semibold)
            }
            .padding(.top, 32)
            
            ScrollView {
                VStack(spacing: 24) {
                    WhatsNewRow(
                        icon: "building.columns.fill",
                        iconColor: Color.primary500,
                        title: Word.Main.savingsAccounts,
                        message: Word.WhatsNew.savingsAccounts
                    )
                    
                    WhatsNewRow(
                        icon: "arrow.left.arrow.right",
                        iconColor: Color.blue,
                        title: Word.Main.transfers,
                        message:Word.WhatsNew.transfers
                    )
                    
                    WhatsNewRow(
                        icon: "lock.fill",
                        iconColor: Color.blue,
                        title: Word.WhatsNew.securityTitle,
                        message: Word.WhatsNew.security
                    )
                    
                    WhatsNewRow(
                        icon: "sparkles",
                        iconColor: Color.purple,
                        title: Word.WhatsNew.userInterfaceTitle,
                        message: Word.WhatsNew.userInterface
                    )
                    
                    WhatsNewRow(
                        icon: "pencil",
                        iconColor: Color.red,
                        title: Word.WhatsNew.editTitle,
                        message: Word.WhatsNew.edit
                    )
                }
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal, 24)
            
            Button {
                preferencesGeneral.isWhatsNewSeen = true
                dismiss()
            } label: {
                Text(Word.Classic.continue)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.white)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                    }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    Text("")
        .sheet(isPresented: .constant(true)) {
            WhatsNewView()
                .preferredColorScheme(.dark)
        }
}
