//
//  BannerManager.swift
//  Essential
//
//  Created by KaayZenn on 11/03/2024.
//

import Foundation

public class BannerManager: ObservableObject {
    public static let shared = BannerManager()
    
    @Published public var banner: Banner?
}
