//
//  SelectAppIcon.swift
//  CashFlow
//
//  Created by Theo Sementa on 04/12/2024.
//

import SwiftUI

struct SelectAppIcon: View {
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    @State private var selectedPeople: People = .serenaDeAraujo
    @State private var selectedIcon: Icon = Icon.findByImage(image: UIApplication.shared.alternateIconName) ?? .walletGreenLight
    
    // MARK: -
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                Text(Word.Setting.Appearance.appIcons)
                    .font(Font.mediumText16())
                    .foregroundStyle(Color.customGray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(People.designers) { people in
                            Button(action: { withAnimation { selectedPeople = people } }, label: {
                                Text(people.name)
                                    .foregroundStyle(Color.text)
                                    .font(Font.mediumText16())
                                    .padding()
                                    .background {
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .fill(Color.colorCell)
                                    }
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .stroke(
                                                selectedPeople == people ? themeManager.theme.color : .clear,
                                                lineWidth: 3
                                            )
                                    }
                                    .padding(4)
                            })
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                ForEach(selectedPeople.icons, id: \.self) { icon in
                    Button(action: {
                        if UIApplication.shared.alternateIconName == icon.image {
                            // Already selected
                        } else {
                            withAnimation {
                                UIApplication.shared.setAlternateIconName(icon == .walletGreenLight ? nil : icon.image)
                                selectedIcon = icon == .walletGreenLight ? .walletGreenLight : icon
                            }
                        }
                    }, label: {
                        Image(icon.image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(themeManager.theme.color, lineWidth: 4)
                                    .isDisplayed(selectedIcon == icon)
                            }
                            .overlay(alignment: .topTrailing) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundStyle(Color.white)
                                    .padding(8)
                                    .background {
                                        Circle()
                                            .fill(themeManager.theme.color)
                                    }
                                    .padding(12)
                                    .isDisplayed(selectedIcon == icon)
                            }
                            .padding(8)
                    })
                }
            } // LazyVGrid
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    ScrollView {
        SelectAppIcon()
            .padding()
    }
    .background(Color.background)
    .environmentObject(ThemeManager())
}
