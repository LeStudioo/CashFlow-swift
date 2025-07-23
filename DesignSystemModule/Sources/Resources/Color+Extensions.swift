//
//  File.swift
//  DesignSystemModule
//
//  Created by Theo Sementa on 23/07/2025.
//

import Foundation
import SwiftUICore

public extension Color {
    
    static var text: Color {
        return Color("text", bundle: BundleHelper.bundle)
    }
    
    static var background: Color {
        return Color("background", bundle: BundleHelper.bundle)
    }
    
    static var customGray: Color {
        return Color("customGray", bundle: BundleHelper.bundle)
    }
    
}
