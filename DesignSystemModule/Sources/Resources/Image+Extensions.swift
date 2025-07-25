//
//  File.swift
//  DesignSystemModule
//
//  Created by Theo Sementa on 24/07/2025.
//

import Foundation
import SwiftUICore

public extension Image {
    
    static var logoCashFlow: Image {
        return Image("LogoWalletCashFlow", bundle: BundleHelper.bundle)
    }
    
    struct Onboarding {
        
        public static var illustrationOne: Image {
            return Image("onboardingPage1", bundle: BundleHelper.bundle)
        }
        
        public static var illustrationTwo: Image {
            return Image("onboardingPage2", bundle: BundleHelper.bundle)
        }
        
        public static var illustrationThree: Image {
            return Image("onboardingPage3", bundle: BundleHelper.bundle)
        }
        
    }
    
    struct Brand {
        
        public static var apple: Image {
            return Image("AppleLogo", bundle: BundleHelper.bundle)
        }
        
        public static var google: Image {
            return Image("GoogleLogo", bundle: BundleHelper.bundle)
        }
        
    }
    
}
