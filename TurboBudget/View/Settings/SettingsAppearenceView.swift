//
//  SettingsAppearenceView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/02/2024.
//

import SwiftUI

struct PeopleIcon: Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String
    var icons: [String]
}

let iconsOfAli: PeopleIcon = PeopleIcon(name: "Ali Husni Majid", icons: ["AppIconWalletGreen", "AppIconWalletGreenDark", "AppIconWalletBlue", "AppIconWalletBlueDark", "AppIconWalletPurple", "AppIconWalletPurpleDark", "AppIconWalletRed", "AppIconWalletRedDark"])
let iconsOfSerena: PeopleIcon = PeopleIcon(name: "Séréna De Araujo", icons: ["AppIconMainLight", "AppIconMainDark"])
let iconsOfRyan: PeopleIcon = PeopleIcon(name: "Ryan Delépine", icons: ["AppIconCFLight", "AppIconCFDark"])
let allPeopleWithIcons: [PeopleIcon] = [iconsOfSerena, iconsOfRyan, iconsOfAli]

struct SettingsAppearenceView: View {
    
    // Custom
    @State private var selectedPeople: PeopleIcon = iconsOfSerena
        
    // EnvironmentsObject
    @EnvironmentObject var csManager: ColorSchemeManager
    
    // Preferences
    @Preference(\.colorSelected) private var colorSelected

    //MARK: - Body
    var body: some View {
        ScrollView {
            // Theme
            HStack {
                Spacer()
                cellForThemeSystem()
                Spacer()
                cellForThemeLight()
                Spacer()
                cellForThemeDark()
                Spacer()
            }
            .padding()
            
            // Tint color
            VStack(spacing: 4) {
                HStack {
                    Text("setting_appearence_tint_color".localized)
                        .font(Font.mediumText16())
                        .foregroundStyle(Color.customGray)
                    Spacer()
                }
                .padding(.leading)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(themes) { theme in
                            VStack {
                                Circle()
                                    .frame(width: 30)
                                    .foregroundStyle(theme.color)
                                Text(theme.name)
                                    .font(Font.mediumText16())
                                    .foregroundStyle(Color.customGray)
                            }
                            .padding()
                            .frame(width: 90, height: 90)
                            .background(Color.colorCell)
                            .cornerRadius(15)
                            .shadow(radius: 2, x: -2, y: 2)
                            .padding(4)
                            .overlay {
                                VStack {
                                    if colorSelected == theme.idUnique {
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(style: StrokeStyle(lineWidth: 3))
                                            .foregroundStyle(theme.color)
                                            .padding(4)
                                    }
                                }
                            }
                            .onTapGesture {
                                colorSelected = theme.idUnique
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            //Alternate Icon
            VStack {
                VStack(spacing: 4) {
                    HStack {
                        Text("setting_appearence_app_icon".localized)
                            .font(Font.mediumText16())
                            .foregroundStyle(Color.customGray)
                        Spacer()
                    }
                    .padding(.leading)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(allPeopleWithIcons) { people in
                                Button(action: { withAnimation { selectedPeople = people } }, label: {
                                    Text(people.name)
                                        .foregroundStyle(Color(uiColor: .label))
                                        .font(Font.mediumText16())
                                        .padding(16)
                                        .background(Color.colorCell)
                                        .cornerRadius(12)
                                        .overlay {
                                            if selectedPeople == people {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(style: StrokeStyle(lineWidth: 3))
                                                    .foregroundStyle(HelperManager().getAppTheme().color)
                                            }
                                        }
                                        .padding(4)
                                })
                            }
                        }
                    }
                }
                
                ForEach(selectedPeople.icons, id: \.self) { iconName in
                    Button(action: {
                        if UIApplication.shared.alternateIconName == iconName { print("🔥 LOGO already selected") } else {
                            if iconName == "AppIconMainLight" {
                                UIApplication.shared.setAlternateIconName(nil)
                            } else {
                                UIApplication.shared.setAlternateIconName(iconName) { error in
                                    if let error { print("⚠️ Error for change alternate icon : \(error.localizedDescription)") } else {
                                    }
                                }
                            }
                        }
                    }, label: {
                        HStack(spacing: 20) {
                            ZStack {
                                Image(uiImage: UIImage(named: iconName) ?? UIImage())
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(15)
                                
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(style: StrokeStyle(lineWidth: 2))
                                    .frame(width: 70, height: 70)
                            }
                            
                            Text(textDisplay(iconName: iconName))
                                .font(.mediumCustom(size: 22))
                            
                            Spacer()
                            
                            if iconName == UIApplication.shared.alternateIconName {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                                    .foregroundStyle(HelperManager().getAppTheme().color)
                            } else if iconName == "AppIconMainLight" && UIApplication.shared.alternateIconName == nil {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                                    .foregroundStyle(HelperManager().getAppTheme().color)
                            }
                        }
                        .foregroundStyle(Color(uiColor: .label))
                        .padding(12)
                        .background(Color.colorCell)
                        .cornerRadius(15)
                        .padding(.top, 8)
                    })
                }
            }
            .padding()
            
        } // End ScrollView
        .scrollIndicators(.hidden)
        .navigationBarTitleDisplayMode(.inline)
    } // End body
    
    //MARK: - ViewBuilder
    @ViewBuilder
    func cellForThemeSystem() -> some View {
        Button(action: { csManager.colorScheme = .unspecified }, label: {
            VStack {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                Gradient.Stop(color: .white, location: 0.5),
                                Gradient.Stop(color: .black, location: 0.5)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing))
                    .frame(height: 50)
                    .cornerRadius(15)
                    .overlay(
                        VStack {
                            if csManager.colorScheme == .unspecified {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(HelperManager().getAppTheme().color, lineWidth: 3)
                            } else {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(uiColor: .label), lineWidth: 1)
                            }
                        }
                    )
                Text("setting_appearence_system".localized)
                    .font(.semiBoldText16())
                    .foregroundStyle(Color(uiColor: .label))
            }
        })
    }
    
    @ViewBuilder
    func cellForThemeLight() -> some View {
        Button(action: { csManager.colorScheme = .light }, label: {
            VStack {
                Rectangle()
                    .foregroundStyle(.white)
                    .frame(height: 50)
                    .cornerRadius(15)
                    .overlay(
                        VStack {
                            if csManager.colorScheme == .light {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(HelperManager().getAppTheme().color, lineWidth: 3)
                            } else {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(uiColor: .label), lineWidth: 1)
                            }
                        }
                    )
                    .overlay {
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundStyle(.black)
                    }
                Text("word_light".localized)
                    .font(.semiBoldText16())
                    .foregroundStyle(Color(uiColor: .label))
            }
        })
    }
    
    @ViewBuilder
    func cellForThemeDark() -> some View {
        Button(action: { csManager.colorScheme = .dark }, label: {
            VStack {
                Rectangle()
                    .foregroundStyle(.black)
                    .frame(height: 50)
                    .cornerRadius(15)
                    .overlay(
                        VStack {
                            if csManager.colorScheme == .dark {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(HelperManager().getAppTheme().color, lineWidth: 3)
                            } else {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(uiColor: .label), lineWidth: 1)
                            }
                        }
                    )
                    .overlay {
                        Image(systemName: "moon.fill")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                Text("word_dark".localized)
                    .font(.semiBoldText16())
                    .foregroundStyle(Color(uiColor: .label))
            }
        })
    }

    // MARK: - Functions
    func textDisplay(iconName: String) -> String {
        if iconName == "AppIconMainLight" {
            return "setting_appearence_original".localized
            
        } else if iconName == "AppIconMainDark" {
            return "word_dark".localized
            
        } else if iconName.contains("AppIconWallet") && iconName.contains("Dark") {
            let iconNameWithoutAppIconWallet = iconName.replacingOccurrences(of: "AppIconWallet", with: "")
            let iconNameWithoutDark = iconNameWithoutAppIconWallet.replacingOccurrences(of: "Dark", with: "")
            return iconNameWithoutDark + " " + "setting_appearence_dark_wallet".localized
            
        } else if iconName.contains("AppIconWallet") && !iconName.contains("Dark") {
            let iconNameWithoutAppIconWallet = iconName.replacingOccurrences(of: "AppIconWallet", with: "")
            return iconNameWithoutAppIconWallet + " " + "setting_appearence_wallet".localized
            
        } else if iconName == "AppIconCFLight" {
            return "setting_appearence_CF_light".localized
            
        } else if iconName == "AppIconCFDark" {
            return "setting_appearence_CF_dark".localized
        }
        
        return ""
    }
} // End struct

// MARK: - Preview
#Preview {
    SettingsAppearenceView()
}
