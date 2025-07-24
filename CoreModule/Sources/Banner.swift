//
//  Banner.swift
//  Split
//
//  Created by KaayZenn on 19/05/2024.
//
// TODO: Change place
import SwiftUI

public enum BannerStyle {
    case neutral
    case error
}

public struct Banner: Equatable {
    public var title: String
    public var style: BannerStyle = .neutral
    public var duration: Double = 3
    
    public init(title: String, style: BannerStyle = .neutral, duration: Double = 3) {
        self.title = title
        self.style = style
        self.duration = duration
    }
}
