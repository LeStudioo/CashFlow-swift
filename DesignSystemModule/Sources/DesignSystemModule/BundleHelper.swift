//
//  File.swift
//  DesignSystemModule
//
//  Created by Theo Sementa on 18/07/2025.
//

import Foundation

struct BundleHelper {
    static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    static var bundle: Bundle {
        return isPreview ? Bundle.module : Bundle.main
    }
}
