//
//  Colors.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//

import Foundation
import SwiftUI

//extension Color {
//    //Reusable
//    static let colorLabel = Color("ColorLabel")
//    static let colorLabelInverse = Color("ColorLabelInverse")
//    static let colorBackground = Color("ColorBackground")
//    static let colorBackgroundSheet = Color("ColorBackgroundSheet")
//    static let colorBackgroundLight = Color("ColorBackgroundLight")
//    static let colorTextFieldBackground = Color("ColorTexFieldBackground")
//    static let colorPlaceholder = Color("ColorPlaceholder")
//    static let colorMaterial = Color("ColorMaterial")
//    static let colorRed = Color("ColorRed")
//    static let colorBlue = Color("ColorBlue")
//    static let colorGreen = Color("ColorGreen")
//    static let colorCustomCell = Color("ColorCustomCell")
//    static let colorCustomToggle = Color("ColorCustomToggle")
//    static let colorCustomCellSheet = Color("ColorCustomCellSheet")
//    
//    //COLOR APP FIGMA
//    
//    //Primary
//    static let primary900 = Color("Primary900")
//    static let primary800 = Color("Primary800")
//    static let primary700 = Color("Primary700")
//    static let primary600 = Color("Primary600")
//    static let primary500 = Color("Primary500")
//    static let primary400 = Color("Primary400")
//    static let primary300 = Color("Primary300")
//    static let primary200 = Color("Primary200")
//    static let primary100 = Color("Primary100")
//    static let primary0 = Color("Primary0")
//    
//    //Success
//    static let success900 = Color("Success900")
//    static let success800 = Color("Success800")
//    static let success700 = Color("Success700")
//    static let success600 = Color("Success600")
//    static let success500 = Color("Success500")
//    static let success400 = Color("Success400")
//    static let success300 = Color("Success300")
//    static let success200 = Color("Success200")
//    static let success100 = Color("Success100")
//    
//    //Error
//    static let error900 = Color("Error900")
//    static let error800 = Color("Error800")
//    static let error700 = Color("Error700")
//    static let error600 = Color("Error600")
//    static let error500 = Color("Error500")
//    static let error400 = Color("Error400")
//    static let error300 = Color("Error300")
//    static let error200 = Color("Error200")
//    static let error100 = Color("Error100")
//    
//    //Warning
//    static let warning900 = Color("Warning900")
//    static let warning800 = Color("Warning800")
//    static let warning700 = Color("Warning700")
//    static let warning600 = Color("Warning600")
//    static let warning500 = Color("Warning500")
//    static let warning400 = Color("Warning400")
//    static let warning300 = Color("Warning300")
//    static let warning200 = Color("Warning200")
//    static let warning100 = Color("Warning100")
//    
//    //Information
//    static let information900 = Color("Information900")
//    static let information800 = Color("Information800")
//    static let information700 = Color("Information700")
//    static let information600 = Color("Information600")
//    static let information500 = Color("Information500")
//    static let information400 = Color("Information400")
//    static let information300 = Color("Information300")
//    static let information200 = Color("Information200")
//    static let information100 = Color("Information100")
//    
//    //Secondary
//    static let secondary900 = Color("Secondary900")
//    static let secondary800 = Color("Secondary800")
//    static let secondary700 = Color("Secondary700")
//    static let secondary600 = Color("Secondary600")
//    static let secondary500 = Color("Secondary500")
//    static let secondary400 = Color("Secondary400")
//    static let secondary300 = Color("Secondary300")
//    static let secondary200 = Color("Secondary200")
//    static let secondary100 = Color("Secondary100")
//    
//    //COLOR APP
//    static let color1Apple = Color("Color1Apple")
//    static let color2Apple = Color("Color2Apple")
//    static let color2AppleInverse = Color("Color2AppleInverse")
//    static let color3Apple = Color("Color3Apple")
//    static let color3AppleInverse = Color("Color3AppleInverse")
//    static let color4Apple = Color("Color4Apple")
//    static let color5Apple = Color("Color5Apple")
//    
//    static let colorCell = Color("ColorCell")
//}

//Color to Hex
extension Color {
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

//Hex to Color
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

//Darker / Lighter
extension Color {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            return (0, 0, 0, 0)
        }
        return (r, g, b, o)
    }
    
    func lighter(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> Color {
        return Color(red: min(Double(self.components.red + percentage/100), 1.0),
                     green: min(Double(self.components.green + percentage/100), 1.0),
                     blue: min(Double(self.components.blue + percentage/100), 1.0),
                     opacity: Double(self.components.opacity))
    }
}
