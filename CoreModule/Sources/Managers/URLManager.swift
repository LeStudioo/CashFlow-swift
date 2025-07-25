//
//  URLManager.swift
//  CoreModule
//
//  Created by Theo Sementa on 20/07/2025.
//
// swiftlint:disable nesting

import Foundation
import UIKit

@MainActor
public final class URLManager {
    
    public static func openURL(url: String) {
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    public enum PredefinedURL {
        public enum Setting: String {
            case bugReport = "https://docs.google.com/forms/d/1Y7hJEwy3oNWfs1udHR8e9AsifMuCOfsiWoZLMLBDwlY/"
            case featureSuggest = "https://docs.google.com/forms/u/3/d/1LPAvhoByojEFjCbkHd_dzGBDFEigJGeqQD9ZSwhbNvk/"
            case developerAccount = "https://apps.apple.com/fr/developer/theo-sementa/id1608409500"
            case termsAndConditions = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
            
            public enum Credits: String {
                case chatGPT = "https://chat.openai.com/"
                case deepl = "https://www.deepl.com/translator"
                
                case swipeActions = "https://github.com/aheze/SwipeActions"
                case swiftUIConfetti = "https://github.com/simibac/ConfettiSwiftUI"
                case storySet = "https://storyset.com/"
            }
        }
        public enum Tutos: String {
            case importFromApplePay = "https://lazyy.fr/cashflow/tutos/import-from-applepay"
        }
    }

    // MARK: Setting
    @MainActor
    public struct Setting {
        public static func writeReview() {
            if let langCode = Locale.current.language.languageCode {
                URLManager.openURL(url: "https://itunes.apple.com/app/https://apps.apple.com/\(langCode.identifier)/app/cashflow-tracker/id6450913423?action=write-review")
            }
        }
        
        public static func reportBug() {
            URLManager.openURL(url: PredefinedURL.Setting.bugReport.rawValue)
        }
        
        public static func suggestFeature() {
            URLManager.openURL(url: PredefinedURL.Setting.featureSuggest.rawValue)
        }
        
        public static func showDeveloperAccount() {
            URLManager.openURL(url: PredefinedURL.Setting.developerAccount.rawValue)
        }
        
        public static func showTermsAndConditions() {
            URLManager.openURL(url: PredefinedURL.Setting.termsAndConditions.rawValue)
        }
        
        @MainActor
        public struct Credits {
            public static func showChatGPT() {
                URLManager.openURL(url: PredefinedURL.Setting.Credits.chatGPT.rawValue)
            }
            
            public static func showDeepl() {
                URLManager.openURL(url: PredefinedURL.Setting.Credits.deepl.rawValue)
            }
            
            public static func showSwipeActions() {
                URLManager.openURL(url: PredefinedURL.Setting.Credits.swipeActions.rawValue)
            }
            
            public static func showSwiftUIConfetti() {
                URLManager.openURL(url: PredefinedURL.Setting.Credits.swiftUIConfetti.rawValue)
            }
            
            public static func showStorySet() {
                URLManager.openURL(url: PredefinedURL.Setting.Credits.storySet.rawValue)
            }
        }
    }
}
