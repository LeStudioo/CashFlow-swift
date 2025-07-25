//
//  File.swift
//  DesignSystemModule
//
//  Created by Theo Sementa on 23/07/2025.
//

import Foundation
import SwiftUICore

public extension Color {
    
    static var primary500: Color {
        return Color("Primary500", bundle: BundleHelper.bundle)
    }
    
}

public extension Color {
    
    struct Background {
        public static var bg50: Color {
            return Color("background50", bundle: BundleHelper.bundle)
        }
        
        public static var bg100: Color {
            return Color("background100", bundle: BundleHelper.bundle)
        }
        
        public static var bg200: Color {
            return Color("background200", bundle: BundleHelper.bundle)
        }
        
        public static var bg300: Color {
            return Color("background300", bundle: BundleHelper.bundle)
        }
        
        public static var bg400: Color {
            return Color("background400", bundle: BundleHelper.bundle)
        }
        
        public static var bg500: Color {
            return Color("background500", bundle: BundleHelper.bundle)
        }
        
        public static var bg600: Color {
            return Color("background600", bundle: BundleHelper.bundle)
        }
    }
    
}

public extension Color {
    
    static var text: Color {
        return Color("text", bundle: BundleHelper.bundle)
    }
    
    static var textReversed: Color {
        return Color("textReversed", bundle: BundleHelper.bundle)
    }
    
    static var customGray: Color {
        return Color("customGray", bundle: BundleHelper.bundle)
    }
    
}
