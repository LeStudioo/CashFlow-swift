//
//  PageControlView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/07/2023.
//

import Foundation
import SwiftUI

struct PageControl: UIViewRepresentable {
    
    @Environment(\.colorScheme) private var colorScheme

    var maxPages: Int
    var currentPage: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        
        let control = UIPageControl()
        control.backgroundStyle = .minimal
        control.pageIndicatorTintColor = UIColor(Color.colorCell)
        control.currentPageIndicatorTintColor = UIColor(ThemeManager.theme.color)
        control.numberOfPages = maxPages
        control.currentPage = currentPage
        
        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        
        // updating current Page...
        uiView.currentPage = currentPage
    }
}
