import Foundation
import SwiftUI

public struct ExtendedUIFont {
    var name: String
    var size: CGFloat
    var lineHeight: CGFloat
}

let fontRegular: String = "Satoshi-Regular"
let fontMedium: String = "Satoshi-Medium"
let fontBold: String = "Satoshi-Bold"
let fontBlack: String = "Satoshi-Black"

public extension ExtendedUIFont {
    
    @MainActor
    struct Display {
        /// `This font is in "Bold 48" style`
        public static let huge: ExtendedUIFont = ExtendedUIFont(name: fontBlack, size: 48, lineHeight: 65)
        /// `This font is in "Bold 40" style`
        public static let extraLarge: ExtendedUIFont = ExtendedUIFont(name: fontBold, size: 40, lineHeight: 54)
        /// `This font is in "Bold 36" style`
        public static let large: ExtendedUIFont = ExtendedUIFont(name: fontBold, size: 36, lineHeight: 48.6)
        /// `This font is in "Bold 32" style`
        public static let medium: ExtendedUIFont = ExtendedUIFont(name: fontBold, size: 32, lineHeight: 43.2)
        /// `This font is in "Bold 28" style`
        public static let small: ExtendedUIFont = ExtendedUIFont(name: fontBold, size: 28, lineHeight: 37.8)
        
    }
    
    @MainActor
    struct Title {
        /// `This font is in "Bold 24" style`
        public static let large: ExtendedUIFont = ExtendedUIFont(name: fontBold, size: 24, lineHeight: 32.4)
        /// `This font is in "Medium 20" style`
        public static let medium: ExtendedUIFont = ExtendedUIFont(name: fontMedium, size: 20, lineHeight: 27)
    }
    
    @MainActor
    struct Body {
        /// `This font is in "Bold 18" style`
        public static let large: ExtendedUIFont = ExtendedUIFont(name: fontBold, size: 18, lineHeight: 24.3)
        /// `This font is in "Bold 16" style`
        public static let mediumBold: ExtendedUIFont = ExtendedUIFont(name: fontBold, size: 16, lineHeight: 21.6)
        /// `This font is in "Medium 16" style`
        public static let medium: ExtendedUIFont = ExtendedUIFont(name: fontMedium, size: 16, lineHeight: 21.6)
        /// `This font is in "Medium 14" style`
        public static let small: ExtendedUIFont = ExtendedUIFont(name: fontMedium, size: 14, lineHeight: 18.9)
    }
    
    @MainActor
    struct Label {
        /// `This font is in "Medium 12" style`
        public static let large: ExtendedUIFont = ExtendedUIFont(name: fontMedium, size: 12, lineHeight: 16.2)
        /// `This font is in "Bold 10" style`
        public static let medium: ExtendedUIFont = ExtendedUIFont(name: fontBold, size: 10, lineHeight: 13.5)
        /// `This font is in "Bold 8" style`
        public static let small: ExtendedUIFont = ExtendedUIFont(name: fontBold, size: 8, lineHeight: 10.8)
    }
    
}

// MARK: - Old Fonts
let nameFontBold: String = "PlusJakartaSans-Bold"
let nameFontSemiBold: String = "PlusJakartaSans-SemiBold"
let nameFontMedium: String = "PlusJakartaSans-Medium"
let nameFontRegular: String = "PlusJakartaSans-Regular"

// Regular
public extension Font {
    /// `This font is in "Regular 12"`
    static func regularVerySmall() -> Font {
        return Font.custom(nameFontRegular, size: 12)
    }
    /// `This font is in "Regular 14"`
    static func regularSmall() -> Font {
        return Font.custom(nameFontRegular, size: 14)
    }
    /// `This font is in "Regular 16"`
    static func regularText16() -> Font {
        return Font.custom(nameFontRegular, size: 16)
    }
    /// `This font is in "Regular 18"`
    static func regularText18() -> Font {
        return Font.custom(nameFontRegular, size: 18)
    }
    /// `This font is in "Regular 24"`
    static func regularH3() -> Font {
        return Font.custom(nameFontRegular, size: 24)
    }
    /// `This font is in "Regular 32"`
    static func regularH2() -> Font {
        return Font.custom(nameFontRegular, size: 32)
    }
    /// `This font is in "Regular 36"`
    static func regularH1() -> Font {
        return Font.custom(nameFontRegular, size: 36)
    }
    static func regularCustom(size: CGFloat) -> Font {
        return Font.custom(nameFontRegular, size: size)
    }
}

// Medium
public extension Font {
    /// `This font is in "Medium 12"`
    static func mediumVerySmall() -> Font {
        return Font.custom(nameFontMedium, size: 12)
    }
    /// `This font is in "Medium 14"`
    static func mediumSmall() -> Font {
        return Font.custom(nameFontMedium, size: 14)
    }
    /// `This font is in "Medium 16"`
    static func mediumText16() -> Font {
        return Font.custom(nameFontMedium, size: 16)
    }
    /// `This font is in "Medium 18"`
    static func mediumText18() -> Font {
        return Font.custom(nameFontMedium, size: 18)
    }
    /// `This font is in "Medium 24"`
    static func mediumH3() -> Font {
        return Font.custom(nameFontMedium, size: 24)
    }
    /// `This font is in "Medium 32"`
    static func mediumH2() -> Font {
        return Font.custom(nameFontMedium, size: 32)
    }
    /// `This font is in "Medium 36"`
    static func mediumH1() -> Font {
        return Font.custom(nameFontMedium, size: 36)
    }
    static func mediumCustom(size: CGFloat) -> Font {
        return Font.custom(nameFontMedium, size: size)
    }
}

// Semibold
public extension Font {
    /// `This font is in "SemiBold 12"`
    static func semiBoldVerySmall() -> Font {
        return Font.custom(nameFontSemiBold, size: 12)
    }
    /// `This font is in "SemiBold 14"`
    static func semiBoldSmall() -> Font {
        return Font.custom(nameFontSemiBold, size: 14)
    }
    /// `This font is in "SemiBold 16"`
    static func semiBoldText16() -> Font {
        return Font.custom(nameFontSemiBold, size: 16)
    }
    /// `This font is in "SemiBold 18"`
    static func semiBoldText18() -> Font {
        return Font.custom(nameFontSemiBold, size: 18)
    }
    /// `This font is in "SemiBold 24"`
    static func semiBoldH3() -> Font {
        return Font.custom(nameFontSemiBold, size: 24)
    }
    /// `This font is in "SemiBold 32"`
    static func semiBoldH2() -> Font {
        return Font.custom(nameFontSemiBold, size: 32)
    }
    /// `This font is in "SemiBold 36"`
    static func semiBoldH1() -> Font {
        return Font.custom(nameFontSemiBold, size: 36)
    }
    static func semiBoldCustom(size: CGFloat) -> Font {
        return Font.custom(nameFontSemiBold, size: size)
    }
}

// Bold
public extension Font {
    /// `This font is in "Bold 12"`
    static func boldVerySmall() -> Font {
        return Font.custom(nameFontBold, size: 12)
    }
    /// `This font is in "Bold 14"`
    static func boldSmall() -> Font {
        return Font.custom(nameFontBold, size: 14)
    }
    /// `This font is in "Bold 16"`
    static func boldText16() -> Font {
        return Font.custom(nameFontBold, size: 16)
    }
    /// `This font is in "Bold 18"`
    static func boldText18() -> Font {
        return Font.custom(nameFontBold, size: 18)
    }
    /// `This font is in "Bold 24`
    static func boldH3() -> Font {
        return Font.custom(nameFontBold, size: 24)
    }
    /// `This font is in "Bold 32"`
    static func boldH2() -> Font {
        return Font.custom(nameFontBold, size: 32)
    }
    /// `This font is in "Bold 36"`
    static func boldH1() -> Font {
        return Font.custom(nameFontBold, size: 36)
    }
    static func boldCustom(size: CGFloat) -> Font {
        return Font.custom(nameFontBold, size: size)
    }
}
