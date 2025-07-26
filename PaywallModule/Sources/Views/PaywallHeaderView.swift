//
//  PaywallHeaderView.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/12/2024.
//

import SwiftUI
import DesignSystemModule

struct PaywallHeaderView: View {
    
    // MARK: Environments
    @Environment(\.dismiss) private var dismiss
    
    @State private var seconds: CGFloat = 0
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
    // MARK: - View
    var body: some View {
        HStack {
            Spacer()
            Text("paywall_title".localized)
                .font(.boldH2())
                .foregroundStyle(
                    LinearGradient(colors: [.primary500, .primary500.darker(by: 30)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
            Spacer()
        }
        .overlay(alignment: .trailing) {
            Button(action: { dismiss() }, label: {
                GeometryReader { proxy in
                    Circle()
                        .inset(by: proxy.size.width / 4)
                        .trim(from: 0, to: seconds / 4)
                        .stroke(Color.Background.bg400.opacity(0.6), style: StrokeStyle(lineWidth: proxy.size.width / 2))
                        .rotationEffect(.radians(-.pi/2))
                        .animation(.linear, value: seconds)
                        .frame(width: 26, height: 26)
                        .foregroundStyle(Color.Background.bg200)
                        .overlay {
                            Image(systemName: "xmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(Color.text)
                        }
                }
                .frame(width: 26, height: 26)
            })
            .disabled(seconds <= 3)
        }
        .onReceive(timer) { _ in
                seconds += 1
        }
    }
}

// MARK: - Preview
#Preview {
    PaywallHeaderView()
        .background(Color.red)
}
