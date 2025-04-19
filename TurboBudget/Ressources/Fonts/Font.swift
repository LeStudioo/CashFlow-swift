//
//  Fonts.swift
//  CashFlow
//
//  Created by Théo Sementa on 24/06/2023.
//

import Foundation
import SwiftUI

var nameFontBold: String = "PlusJakartaSans-Bold"
var nameFontSemiBold: String = "PlusJakartaSans-SemiBold"
var nameFontMedium: String = "PlusJakartaSans-Medium"
var nameFontRegular: String = "PlusJakartaSans-Regular"

extension Font {
    struct Title {
        static let semibold: Font = Font.custom(nameFontSemiBold, size: 24)
    }
    struct Subtitle {
        static let medium: Font = Font.custom(nameFontMedium, size: 20)
    }
    struct Button {
        static let text: Font = Font.custom(nameFontSemiBold, size: 18)
    }
    struct Body {
        static let bold: Font = Font.custom(nameFontBold, size: 16)
        static let semibold: Font = Font.custom(nameFontSemiBold, size: 16)
    }
    struct Text {
        static let semibold: Font = Font.custom(nameFontSemiBold, size: 14)
        static let medium: Font = Font.custom(nameFontMedium, size: 14)
        static let regular: Font = Font.custom(nameFontRegular, size: 14)
    }
    struct Caption {
        static let medium: Font = Font.custom(nameFontMedium, size: 12)
    }
}

// Regular
extension Font {
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
extension Font {
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
extension Font {
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
extension Font {
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
