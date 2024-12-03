//
//  SyncingView.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import SwiftUI

struct SyncingView: View {
    
    // MARK: -
    var body: some View {
        VStack(spacing: 24) {
            CashFlowLoader()
            Text("Nous sommes entrain de récupérer vos données...") // TBL
                .font(.semiBoldH3())
                .multilineTextAlignment(.center)
        }
        .padding()
    } // body
} // struct

// MARK: - Preview
#Preview {
    SyncingView()
}
