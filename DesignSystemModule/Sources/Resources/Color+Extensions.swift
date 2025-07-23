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
    
    static var background: Color {
        return Color("background", bundle: BundleHelper.bundle)
    }
    
    static var background200: Color {
        return Color("background200", bundle: BundleHelper.bundle)
    }
    
}

public extension Color {
    
    static var text: Color {
        return Color("text", bundle: BundleHelper.bundle)
    }
    
    
    
    static var customGray: Color {
        return Color("customGray", bundle: BundleHelper.bundle)
    }
    
}
