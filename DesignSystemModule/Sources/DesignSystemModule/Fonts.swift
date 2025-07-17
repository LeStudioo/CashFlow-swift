import Foundation
import SwiftUI

let satoshiBlack: String = "Satoshi-Black"
let satoshiBold: String = "Satoshi-Bold"
let satoshiMedium: String = "Satoshi-Medium"
let satoshiRegular: String = "Satoshi-Regular"

public extension Font {
    
    struct Display {
        /// `This font is in "Bold 40" style`
        public static let extraLarge: Font = Font.custom(satoshiBold, size: 40)
        /// `This font is in "Bold 36" style`
        public static let large: Font = Font.custom(satoshiBold, size: 36)
        /// `This font is in "Bold 32" style`
        public static let medium: Font = Font.custom(satoshiBold, size: 32)
        /// `This font is in "Bold 28" style`
        public static let small: Font = Font.custom(satoshiBold, size: 28)
    }
    
    struct Title {
        /// `This font is in "Bold 24" style`
        public static let large: Font = Font.custom(satoshiBold, size: 24)
        /// `This font is in "Medium 20" style`
        public static let medium: Font = Font.custom(satoshiMedium, size: 20)
    }
    
    struct Body {
        /// `This font is in "Bold 18" style`
        public static let large: Font = Font.custom(satoshiBold, size: 18)
        /// `This font is in "Bold 16" style`
        public static let mediumBold: Font = Font.custom(satoshiBold, size: 16)
        /// `This font is in "Medium 16" style`
        public static let medium: Font = Font.custom(satoshiMedium, size: 16)
        /// `This font is in "Medium 14" style`
        public static let small: Font = Font.custom(satoshiMedium, size: 14)
    }
    
    struct Label {
        /// `This font is in "Medium 12" style`
        public static let large: Font = Font.custom(satoshiMedium, size: 12)
        /// `This font is in "Bold 10" style`
        public static let medium: Font = Font.custom(satoshiBold, size: 10)
        /// `This font is in "Bold 8" style`
        public static let small: Font = Font.custom(satoshiBold, size: 8)
    }
    
//    struct Title {
//        /// Value `24`
//        static let semibold: Font = Font.custom(nameFontSemiBold, size: 24)
//    }
//    
//    struct Subtitle {
//        /// Value `20`
//        static let medium: Font = Font.custom(nameFontMedium, size: 20)
//    }
//    
//    struct Button {
//        /// Value `18`
//        static let text: Font = Font.custom(nameFontSemiBold, size: 18)
//    }
//    
//    struct Body {
//        /// Value `16`
//        static let bold: Font = Font.custom(nameFontBold, size: 16)
//        /// Value `16`
//        static let semibold: Font = Font.custom(nameFontSemiBold, size: 16)
//    }
//    
//    struct Text {
//        /// Value `14`
//        static let semibold: Font = Font.custom(nameFontSemiBold, size: 14)
//        /// Value `14`
//        static let medium: Font = Font.custom(nameFontMedium, size: 14)
//        /// Value `14`
//        static let regular: Font = Font.custom(nameFontRegular, size: 14)
//    }
//    
//    struct Caption {
//        /// Value `12`
//        static let medium: Font = Font.custom(nameFontMedium, size: 12)
//    }
}
