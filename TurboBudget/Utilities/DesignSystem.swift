//
//  DesignSystem.swift
//  CashFlow
//
//  Created by Theo Sementa on 19/04/2025.
//
// swiftlint:disable nesting

import Foundation
import SwiftUICore

struct DesignSystem { }

// MARK: - Fonts
extension DesignSystem {
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
        static let extraSmall: CGFloat = 8
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
