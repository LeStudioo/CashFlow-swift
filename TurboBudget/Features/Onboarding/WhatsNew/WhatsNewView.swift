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
    @Environment(\.openURL) private var openURL
    
    // MARK: -
    var body: some View {
        VStack(spacing: 64) {
            VStack {
                Text(Word.WhatsNew.title)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("v\(Bundle.main.releaseVersionNumber ?? "")")
                    .fontWeight(.semibold)
            }
            .padding(.top, 32)
            
            VStack(spacing: 24) {
                Button {
                   
                } label: {
                    HStack {
                        Text("whatsnew_features".localized)
                        Spacer()
                        Image(systemName: "arrow.up.right")
                    }
                    .fontWeight(.semibold)
                    .fullWidth()
                    .foregroundStyle(Color.white)
                    .padding()
                    .roundedRectangleBorder(.blue, radius: 16)
                }
                
                Button {
                    preferencesGeneral.isWhatsNewSeen = true
                    dismiss()
                } label: {
                    Text(Word.Classic.continue)
                        .fontWeight(.semibold)
                        .fullWidth()
                        .foregroundStyle(Color.white)
                        .padding()
                        .roundedRectangleBorder(.background200, radius: 16)
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
                .presentationDetents([.medium])
        }
}
