//
//  SplashScreenView.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        Image(isIPad ? "LaunchScreenIPad" : "LaunchScreen")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea([.bottom, .top])
    }
}

#Preview {
    SplashScreenView()
}
