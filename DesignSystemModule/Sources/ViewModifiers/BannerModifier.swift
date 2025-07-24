//
//  BannerModifier.swift
//  DesignSystemModule
//
//  Created by Theo Sementa on 24/07/2025.
//

import SwiftUI
import CoreModule

struct BannerModifier: ViewModifier {
    
    // Builder
    @Binding var banner: Banner?
    @State private var workItem: DispatchWorkItem?
    
    // MARK: - body
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                ZStack {
                    mainBannerView()
                        .offset(y: 30)
                }
                .animation(.spring(), value: banner)
            }
            .onChange(of: banner) { _ in
                showBanner()
            }
    } // End body

    // MARK: ViewBuilder
    @ViewBuilder
    func mainBannerView() -> some View {
        if let banner = banner {
            VStack {
                BannerView(title: banner.title, style: banner.style) {
                    dismissBanner()
                }
                Spacer()
            }
            .transition(.move(edge: .top))
        }
    }

    // MARK: Functions
    private func showBanner() {
        guard let banner = banner else { return }

        if banner.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissBanner()
            }

            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + banner.duration, execute: task)
        }
    }
    
    private func dismissBanner() {
        withAnimation { banner = nil }

        workItem?.cancel()
        workItem = nil
    }
} // End struct Modifier

extension View {
    func bannerView(banner: Binding<Banner?>) -> some View {
        self.modifier(BannerModifier(banner: banner))
    }
}

struct BannerView: View {

    var title: String
    var style: BannerStyle
    var onCancelTapped: (() -> Void)
    
    var body: some View {
        Text(title)
//            .font(.Body.mediu) // TODO: ICI
            .foregroundStyle(style == .error ? Color.white : Color(uiColor: .systemBackground))
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(style == .error ? Color.red : Color.text)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .onTapGesture {
                onCancelTapped()
            }
            .padding(.horizontal)
    }
}
