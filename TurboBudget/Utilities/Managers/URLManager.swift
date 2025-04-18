//
//  URLManager.swift
//  CashFlow
//
//  Created by KaayZenn on 24/02/2024.
//
// swiftlint:disable nesting

import Foundation
import UIKit

final class URLManager {
    
    static func openURL(url: String) {
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    enum PredefinedURL {
        enum Setting: String {
            case bugReport = "https://docs.google.com/forms/d/1Y7hJEwy3oNWfs1udHR8e9AsifMuCOfsiWoZLMLBDwlY/"
            case featureSuggest = "https://docs.google.com/forms/u/3/d/1LPAvhoByojEFjCbkHd_dzGBDFEigJGeqQD9ZSwhbNvk/"
            case developerAccount = "https://apps.apple.com/fr/developer/theo-sementa/id1608409500"
            case termsAndConditions = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
            
            enum Credits: String {
                case chatGPT = "https://chat.openai.com/"
                case deepl = "https://www.deepl.com/translator"
                
                case swipeActions = "https://github.com/aheze/SwipeActions"
                case swiftUIConfetti = "https://github.com/simibac/ConfettiSwiftUI"
                case storySet = "https://storyset.com/"
            }
        }
        enum Tutos: String {
            case importFromApplePay = "https://lazyy.fr/cashflow/tutos/import-from-applepay"
        }
    }

    // MARK: Setting
    struct Setting {
        static func writeReview() {
            if let langCode = Locale.current.language.languageCode {
                URLManager.openURL(url: "https://itunes.apple.com/app/https://apps.apple.com/\(langCode.identifier)/app/cashflow-tracker/id6450913423?action=write-review")
            }
        }
        
        static func reportBug() {
            URLManager.openURL(url: PredefinedURL.Setting.bugReport.rawValue)
        }
        
        static func suggestFeature() {
            URLManager.openURL(url: PredefinedURL.Setting.featureSuggest.rawValue)
        }
        
        static func showDeveloperAccount() {
            URLManager.openURL(url: PredefinedURL.Setting.developerAccount.rawValue)
        }
        
        static func showTermsAndConditions() {
            URLManager.openURL(url: PredefinedURL.Setting.termsAndConditions.rawValue)
        }
        
        struct Credits {
            static func showChatGPT() {
                URLManager.openURL(url: PredefinedURL.Setting.Credits.chatGPT.rawValue)
            }
            
            static func showDeepl() {
                URLManager.openURL(url: PredefinedURL.Setting.Credits.deepl.rawValue)
            }
            
            static func showSwipeActions() {
                URLManager.openURL(url: PredefinedURL.Setting.Credits.swipeActions.rawValue)
            }
            
            static func showSwiftUIConfetti() {
                URLManager.openURL(url: PredefinedURL.Setting.Credits.swiftUIConfetti.rawValue)
            }
            
            static func showStorySet() {
                URLManager.openURL(url: PredefinedURL.Setting.Credits.storySet.rawValue)
            }
        }
    }
}
