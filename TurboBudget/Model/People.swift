//
//  People.swift
//  CashFlow
//
//  Created by Theo Sementa on 04/12/2024.
//

import Foundation

enum People: Identifiable {
    case theoSementa
    case remiWeil
    
    case serenaDeAraujo
    
    var id: Self { self }
    
    static var founders: [People] {
        return [.theoSementa, .remiWeil]
    }
    
    static var designers: [People] {
        return [.serenaDeAraujo, .theoSementa]
    }
    
    static var designersWithoutTheo: [People] {
        return [.serenaDeAraujo]
    }
}

enum Icon: CaseIterable {
    case mainLight
    case mainDark
    
    case walletGreenLight
    case walletGreenDark
    case walletBlueLight
    case walletBlueDark
    case walletPurpleLight
    case walletPurpleDark
    case walletRedLight
    case walletRedDark
    
    var image: String {
        switch self {
        case .mainLight: return "AppIconMainLight"
        case .mainDark: return "AppIconMainDark"
            
        case .walletGreenLight: return "AppIconWalletGreenLight"
        case .walletGreenDark: return "AppIconWalletGreenDark"
        case .walletBlueLight: return "AppIconWalletBlueLight"
        case .walletBlueDark: return "AppIconWalletBlueDark"
        case .walletPurpleLight: return "AppIconWalletPurpleLight"
        case .walletPurpleDark: return "AppIconWalletPurpleDark"
        case .walletRedLight: return "AppIconWalletRedLight"
        case .walletRedDark: return "AppIconWalletRedDark"
        }
    }
    
    static func findByImage(image: String?) -> Icon? {
        guard let image else { return nil }
        return Icon.allCases.first { $0.image == image }
    }
}

extension People {
    
    var name: String {
        switch self {
        case .theoSementa: return "Theo Sementa"
        case .remiWeil: return "Remi Weil"
        case .serenaDeAraujo: return "Séréna De Araujo"
        }
    }
    
    var job: String {
        switch self {
        case .theoSementa: return "iOS Developer"
        case .remiWeil: return "Backend Developer"
        case .serenaDeAraujo: return "Graphic Designer"
        }
    }
    
    var title: String {
        switch self {
        case .theoSementa: return "Founder"
        case .remiWeil: return "Co-Founder"
        case .serenaDeAraujo: return "Designer"
        }
    }
    
    var image: ImageResource {
        switch self {
        case .theoSementa: return .theosementa
        case .remiWeil: return .theosementa // TODO: EDIT
        case .serenaDeAraujo: return .serenadearaujo
        }
    }
    
    var icons: [Icon] {
        switch self {
        case .theoSementa:
            return [
                .walletGreenLight,
                .walletGreenDark,
                .walletBlueLight,
                .walletBlueDark,
                .walletPurpleLight,
                .walletPurpleDark,
                .walletRedLight,
                .walletRedDark
            ]
        case .serenaDeAraujo:
            return [.mainLight, .mainDark]
        default: return []
        }
    }
    
    var linkedin: URL? {
        switch self {
        case .theoSementa: return URL(string: "https://www.linkedin.com/in/theosementa/")
        default: return nil
        }
    }
    
    var twitter: URL? {
        switch self {
        case .theoSementa: return URL(string: "https://x.com/theosementa")
        default: return nil
        }
    }
    
    var instagram: URL? {
        switch self {
        case .serenaDeAraujo: return URL(string: "https://instagram.com/widesign._x")
        default: return nil
        }
    }
    
}
