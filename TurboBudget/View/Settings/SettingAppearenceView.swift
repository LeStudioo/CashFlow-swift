//
//  SettingAppearenceView.swift
//  CashFlow
//
//  Created by KaayZenn on 10/09/2023.
//
// Localizations 01/10/2023

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

struct SettingAppearenceView: View {

    //Custom type
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared

    //Environnements
    @Environment(\.colorScheme) private var colorScheme
    
    //EnvironmentsObject
    @EnvironmentObject var csManager: ColorSchemeManager

    //State or Binding String
    @Binding var colorSelected: String
    @State private var selectedPeople: PeopleIcon = iconsOfSerena

    //State or Binding Int, Float and Double

    //State or Binding Bool
    @Binding var update: Bool

	//Enum
	
	//Computed var

    //MARK: - Body
    var body: some View {
        VStack(spacing: 32) {
            //Theme
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
            
            //Tint color
            VStack(spacing: 2) {
                HStack {
                    Text(NSLocalizedString("setting_appearence_tint_color", comment: ""))
                        .font(Font.mediumText16())
                        .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                    Spacer()
                }
                .padding(.leading)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(themes) { theme in
                            VStack {
                                Circle()
                                    .frame(width: 30)
                                    .foregroundColor(theme.color)
                                Text(theme.name)
                                    .font(Font.mediumText16())
                                    .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
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
                                            .foregroundColor(theme.color)
                                            .padding(4)
                                    }
                                }
                            }
                            .onTapGesture {
                                colorSelected = theme.idUnique
                                userDefaultsManager.colorSelected = colorSelected
                                update.toggle()
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            //Alternate Icon
            VStack {
                VStack(spacing: -1) {
                    HStack {
                        Text(NSLocalizedString("setting_appearence_app_icon", comment: ""))
                            .font(Font.mediumText16())
                            .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                        Spacer()
                    }
                    .padding(.leading)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(allPeopleWithIcons) { people in
                                Button(action: { withAnimation { selectedPeople = people } }, label: {
                                    Text(people.name)
                                        .foregroundColor(.colorLabel)
                                        .font(Font.mediumText16())
                                        .padding(16)
                                        .background(Color.colorCell)
                                        .cornerRadius(12)
                                        .overlay {
                                            if selectedPeople == people {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(style: StrokeStyle(lineWidth: 3))
                                                    .foregroundColor(HelperManager().getAppTheme().color)
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
                                update.toggle()
                            } else {
                                UIApplication.shared.setAlternateIconName(iconName) { error in
                                    if let error { print("⚠️ Error for change alternate icon : \(error.localizedDescription)") } else {
                                        update.toggle()
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
                                    .foregroundColor(HelperManager().getAppTheme().color)
                            } else if iconName == "AppIconMainLight" && UIApplication.shared.alternateIconName == nil {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                                    .foregroundColor(HelperManager().getAppTheme().color)
                            }
                        }
                        .foregroundColor(.colorLabel)
                        .padding(12)
                        .background(Color.colorCell)
                        .cornerRadius(15)
                        .padding(.top, 8)
                    })
                }
            }
            .padding(update ? 0 : 0)
            .padding()
            
            Spacer()
        }
    }//END body
    
    //MARK: ViewBuilder
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
                                    .stroke(Color.colorLabel, lineWidth: 1)
                            }
                        }
                    )
                Text(NSLocalizedString("setting_appearence_system", comment: ""))
                    .font(.semiBoldText16())
                    .foregroundColor(.colorLabel)
            }
        })
    }
    
    @ViewBuilder
    func cellForThemeLight() -> some View {
        Button(action: { csManager.colorScheme = .light }, label: {
            VStack {
                Rectangle()
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .cornerRadius(15)
                    .overlay(
                        VStack {
                            if csManager.colorScheme == .light {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(HelperManager().getAppTheme().color, lineWidth: 3)
                            } else {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.colorLabel, lineWidth: 1)
                            }
                        }
                    )
                    .overlay {
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundColor(.black)
                    }
                Text(NSLocalizedString("word_light", comment: ""))
                    .font(.semiBoldText16())
                    .foregroundColor(.colorLabel)
            }
        })
    }
    
    @ViewBuilder
    func cellForThemeDark() -> some View {
        Button(action: { csManager.colorScheme = .dark }, label: {
            VStack {
                Rectangle()
                    .foregroundColor(.black)
                    .frame(height: 50)
                    .cornerRadius(15)
                    .overlay(
                        VStack {
                            if csManager.colorScheme == .dark {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(HelperManager().getAppTheme().color, lineWidth: 3)
                            } else {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.colorLabel, lineWidth: 1)
                            }
                        }
                    )
                    .overlay {
                        Image(systemName: "moon.fill")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                    }
                Text(NSLocalizedString("word_dark", comment: ""))
                    .font(.semiBoldText16())
                    .foregroundColor(.colorLabel)
            }
        })
    }

    //MARK: Fonctions
    func textDisplay(iconName: String) -> String {
        if iconName == "AppIconMainLight" {
            return NSLocalizedString("setting_appearence_original", comment: "")
            
        } else if iconName == "AppIconMainDark" {
            return NSLocalizedString("word_dark", comment: "")
            
        } else if iconName.contains("AppIconWallet") && iconName.contains("Dark") {
            let iconNameWithoutAppIconWallet = iconName.replacingOccurrences(of: "AppIconWallet", with: "")
            let iconNameWithoutDark = iconNameWithoutAppIconWallet.replacingOccurrences(of: "Dark", with: "")
            return iconNameWithoutDark + " " + NSLocalizedString("setting_appearence_dark_wallet", comment: "")
            
        } else if iconName.contains("AppIconWallet") && !iconName.contains("Dark") {
            let iconNameWithoutAppIconWallet = iconName.replacingOccurrences(of: "AppIconWallet", with: "")
            return iconNameWithoutAppIconWallet + " " + NSLocalizedString("setting_appearence_wallet", comment: "")
            
        } else if iconName == "AppIconCFLight" {
            return NSLocalizedString("setting_appearence_CF_light", comment: "")
            
        } else if iconName == "AppIconCFDark" {
            return NSLocalizedString("setting_appearence_CF_dark", comment: "")
        }
        
        return ""
    }

}//END struct

//MARK: - Preview
struct SettingAppearenceView_Previews: PreviewProvider {
    
    @State static var previewColor: String = ""
    @State static var updatePreview: Bool = false
    
    static var previews: some View {
        SettingAppearenceView(colorSelected: $previewColor, update: $updatePreview)
    }
}
