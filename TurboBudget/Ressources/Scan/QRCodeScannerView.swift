//
//  QRCodeScannerView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/07/2023.
//

import SwiftUI

struct QRCodeScannerView: View {
    
    // Builder
    @Binding var identityToken: String
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        ZStack {
            QRScanner(result: $identityToken)
            
            ZStack {
                Rectangle()
                    .fill(Color.black.opacity(0.6))
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .frame(width: 200, height: 200)
                        .blendMode(.destinationOut)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(themeManager.theme.color, lineWidth: 4)
                        }
                    
                    Text("TBL Scan QR Code")
                }
            }
            .compositingGroup()
        }
        .onChange(of: identityToken) { _ in
            Task {
                do {
                    try await NetworkService.shared.sendRequest(
                        apiBuilder: AuthAPIRequester.socket(body: .init(identityToken: identityToken))
                    )
                    dismiss()
                } catch {}
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    QRCodeScannerView(identityToken: .constant(""))
}
