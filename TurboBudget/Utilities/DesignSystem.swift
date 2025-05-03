//
//  DesignSystem.swift
//  CashFlow
//
//  Created by Theo Sementa on 19/04/2025.
//
// swiftlint:disable nesting

import Foundation
import SwiftUICore

struct DesignSystem {
    
    static var fontRegular: String = "Satoshi-Regular"
    static var fontMedium: String = "Satoshi-Medium"
    static var fontBold: String = "Satoshi-Bold"
    
}

// MARK: - Fonts
extension DesignSystem {
    
    struct Fonts {
        public struct Display {
            /// `This font is in "Bold 40" style`
            public static let extraLarge: Font = Font.custom(fontBold, size: 40)
            /// `This font is in "Bold 36" style`
            public static let large: Font = Font.custom(fontBold, size: 36)
            /// `This font is in "Bold 32" style`
            public static let medium: Font = Font.custom(fontBold, size: 32)
            /// `This font is in "Bold 28" style`
            public static let small: Font = Font.custom(fontBold, size: 28)
        }
        public struct Title {
            /// `This font is in "Bold 24" style`
            public static let large: Font = Font.custom(fontBold, size: 24)
            /// `This font is in "Medium 20" style`
            public static let medium: Font = Font.custom(fontMedium, size: 20)
        }
        public struct Body {
            /// `This font is in "Bold 18" style`
            public static let large: Font = Font.custom(fontBold, size: 18)
            /// `This font is in "Bold 16" style`
            public static let mediumBold: Font = Font.custom(fontBold, size: 16)
            /// `This font is in "Medium 16" style`
            public static let medium: Font = Font.custom(fontMedium, size: 16)
            /// `This font is in "Medium 14" style`
            public static let small: Font = Font.custom(fontMedium, size: 14)
        }
        public struct Label {
            /// `This font is in "Medium 12" style`
            public static let large: Font = Font.custom(fontMedium, size: 12)
            /// `This font is in "Bold 10" style`
            public static let medium: Font = Font.custom(fontBold, size: 10)
            /// `This font is in "Bold 8" style`
            public static let small: Font = Font.custom(fontBold, size: 8)
        }
    }
    
    struct FontDS {
        struct Title {
            /// `This font is in "SemiBold 24"`
            static let semibold: Font = Font.custom(nameFontSemiBold, size: 24)
        }
        struct Subtitle {
            /// `This font is in "Medium 20"`
            static let medium: Font = Font.custom(nameFontMedium, size: 20)
        }
        struct Button {
            /// `This font is in "Semibold 18"`
            static let text: Font = Font.custom(nameFontSemiBold, size: 18)
        }
        struct Body {
            /// `This font is in "Bold 16"`
            static let bold: Font = Font.custom(nameFontBold, size: 16)
            /// `This font is in "Semibold 16"`
            static let semibold: Font = Font.custom(nameFontSemiBold, size: 16)
        }
        struct Text {
            /// `This font is in "Semibold 14"`
            static let semibold: Font = Font.custom(nameFontSemiBold, size: 14)
            /// `This font is in "Medium 14"`
            static let medium: Font = Font.custom(nameFontMedium, size: 14)
            /// `This font is in "Regular 14"`
            static let regular: Font = Font.custom(nameFontRegular, size: 14)
        }
        struct Caption {
            /// `This font is in "Medium 12"`
            static let medium: Font = Font.custom(nameFontMedium, size: 12)
        }
    }
}

// MARK: - Padding
extension DesignSystem {
    struct Padding {
        /// `Value = 4`
        static let extraSmall: CGFloat = 4
        /// `Value = 8`
        static let small: CGFloat = 8
        /// `Value = 12`
        static let medium: CGFloat = 12
        /// `Value = 16`
        static let standard: CGFloat = 16
        /// `Value = 24`
        static let large: CGFloat = 24
        /// `Value = 32`
        static let extraLarge: CGFloat = 32
    }
}

// MARK: - Spacing
extension DesignSystem {
    struct Spacing {
        /// `Value = 4`
        static let extraSmall: CGFloat = 4
        /// `Value = 8`
        static let small: CGFloat = 8
        /// `Value = 12`
        static let medium: CGFloat = 12
        /// `Value = 16`
        static let standard: CGFloat = 16
        /// `Value = 24`
        static let large: CGFloat = 24
        /// `Value = 32`
        static let extraLarge: CGFloat = 32
    }
}

// MARK: - Corner Radius
extension DesignSystem {
    struct CornerRadius {
        /// `Value = 8`
        static let small: CGFloat = 8
        /// `Value = 12`
        static let medium: CGFloat = 12
        /// `Value = 16`
        static let standard: CGFloat = 16
        /// `Value = 24`
        static let large: CGFloat = 24
        /// `Value = 32`
        static let extraLarge: CGFloat = 32
    }
}
