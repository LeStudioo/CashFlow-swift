//
//  URLManager.swift
//  CashFlow
//
//  Created by KaayZenn on 24/02/2024.
//

import Foundation
import UIKit

class URLManager {
    
    static private func openURL(url: String) {
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
                case theoSementa = "https://x.com/theosementa?s=21&t=mHfvIyj-lTkunAAdI8h8Ww"
                case serenaDeAraujo = "https://instagram.com/widesign._x?igshid=MzRlODBiNWFlZA=="
                case ryanDelepine = "https://x.com/ryan_ssc?s=21&t=mHfvIyj-lTkunAAdI8h8Ww"
                case aliHusniMajid = "https://www.linkedin.com/in/alihusnimajid/"
                case yvesCharpentier = "https://apps.apple.com/fr/developer/yves-charpentier/id1654705165"
                case noemieRosenkranz = "https://fr.linkedin.com/in/noemie-rosenkranz-a109b3219"
                case julineDigne = "https://www.linkedin.com/in/juline-digne/"
                case theoDahlem = "http://portfolio-td.framer.website"
                case chatGPT = "https://chat.openai.com/"
                case deepl = "https://www.deepl.com/translator"
                
                case swipeActions = "https://github.com/aheze/SwipeActions"
                case swiftUIConfetti = "https://github.com/simibac/ConfettiSwiftUI"
                case storySet = "https://storyset.com/"
            }
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
            static func showTheoSementa() {
                URLManager.openURL(url: PredefinedURL.Setting.Credits.theoSementa.rawValue)
            }
            
            static func showSerenaDeAraujo() {
                URLManager.openURL(url: PredefinedURL.Setting.Credits.serenaDeAraujo.rawValue)
            }
            
            static func showRyanDelepine() {
                URLManager.openURL(url: PredefinedURL.Setting.Credits.ryanDelepine.rawValue)
            }
            
            static func showAliHusniMajid() {
                URLManager.openURL(url: PredefinedURL.Setting.Credits.aliHusniMajid.rawValue)
            }
            
            static func showYvesCharpentier() {
                URLManager.openURL(url: PredefinedURL.Setting.Credits.yvesCharpentier.rawValue)
            }
            
            static func showNoemieRosenkranz() {
                URLManager.openURL(url: PredefinedURL.Setting.Credits.noemieRosenkranz.rawValue)
            }
            
            static func showJulineDigne() {
                URLManager.openURL(url: PredefinedURL.Setting.Credits.julineDigne.rawValue)
            }
            
            static func showTheoDahlem() {
                URLManager.openURL(url: PredefinedURL.Setting.Credits.theoDahlem.rawValue)
            }
            
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
