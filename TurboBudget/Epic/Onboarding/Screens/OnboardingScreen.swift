//
//  OnboardingScreen.swift
//  CashFlow
//
//  Created by KaayZenn on 10/09/2023.
//
// Localizations 30/09/2023

import SwiftUI
import CloudKit

struct OnboardingScreen: View {
    
    // Environnement
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    // Repo
    @EnvironmentObject private var accountStore: AccountStore

    @State private var actualPage: Int = 1
    
    // Preferences
    @StateObject private var preferencesGeneral: PreferencesGeneral = .shared
	
	// Computed var
    var sizeTitleOnboarding: CGFloat {
        if UIDevice.isLittleIphone {
            return 26
        } else if UIDevice.isIpad {
            return 30
        } else { return 28 }
    }

    var sizeDescOnboarding: CGFloat {
        if UIDevice.isLittleIphone {
            return 16
        } else if UIDevice.isIpad {
            return 20
        } else { return 18 }
    }

    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $actualPage) {
                onboardingPage(
                    image: "TutorialPage1",
                    title: "onboarding_page1_title".localized,
                    desc: "onboarding_page1_desc".localized
                ).tag(1)
                
                onboardingPage(
                    image: "TutorialPage2",
                    title: "onboarding_page2_title".localized,
                    desc: "onboarding_page2_desc".localized
                ).tag(2)
                
                onboardingPage(
                    image: "TutorialPage3",
                    title: "onboarding_page3_title".localized,
                    desc: "onboarding_page3_desc".localized
                ).tag(3)
                
                onboardingPage(
                    image: "TutorialPage4",
                    title: "onboarding_page4_title".localized,
                    desc: "onboarding_page4_desc".localized
                ).tag(4)
                
                CreateAccountScreen(type: .classic) {
                    actualPage += 1
                    await accountStore.fetchAccounts()
                    preferencesGeneral.isAlreadyOpen = true
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }.tag(5)
                
                PaywallScreen(isXmarkPresented: false)
                    .tag(6)
                    .overlay(alignment: .topTrailing) {
                        Button(action: { dismiss() }, label: {
                            Circle()
                                .frame(width: 26, height: 26)
                                .foregroundStyle(.background200)
                                .overlay {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundStyle(Color.text)
                                }
                        })
                        .padding()
                    }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .interactiveDismissDisabled(actualPage < 6)
            
            if actualPage < 5 {
                Button {
                    withAnimation { actualPage += 1 }
                } label: {
                    Capsule()
                        .foregroundStyle(.primary400)
                        .frame(height: 60)
                        .overlay {
                            Text(actualPage == 5 ? "onboarding_button_start".localized : "onboarding_button_next".localized)
                                .font(.semiBoldCustom(size: 22))
                                .foregroundStyle(.primary0)
                        }
                        .padding()
                        .padding(.horizontal)
                }
            }
        }
    } // body
    
    // MARK: - ViewBuilder
    @ViewBuilder
    func onboardingPage(image: String, title: String, desc: String) -> some View {
        ZStack(alignment: .bottom) {
            VStack {
                Spacer()
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 60)
                Spacer()
                Spacer()
            }
            
            VStack {
                Spacer()
                ZStack(alignment: .top) {
                    CustomShapeOnboarding()
                        .frame(height: UIScreen.main.bounds.height / 2 - 30)
                        .foregroundStyle(colorScheme == .light ? .primary0 : .secondary500)
                    
                    VStack(spacing: UIDevice.isLittleIphone ? 20 : 40) {
                        Text(title)
                            .font(.boldCustom(size: sizeTitleOnboarding))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.text)
                        
                        Text(desc)
                            .foregroundStyle(.secondary400)
                            .font(.mediumCustom(size: sizeDescOnboarding))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 70)
                    .padding(.horizontal)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(Gradient(colors: [.primary600, .primary800]))
    }
} // struct

// MARK: - Preview
#Preview {
    OnboardingScreen()
}

// MARK: - Extra
private struct CustomShapeOnboarding: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: .zero)
            
            path.addCurve(to: CGPoint(x: UIScreen.main.bounds.width, y: 0),
                                      control1: CGPoint(x: 100, y: 40),
                                      control2: CGPoint(x: UIScreen.main.bounds.width - 100, y: 40))
            
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 0))
            
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height / 2 - 30))
            path.addLine(to: CGPoint(x: 0, y: UIScreen.main.bounds.height / 2 - 30))
            
            path.closeSubpath()
        }
    }
}
