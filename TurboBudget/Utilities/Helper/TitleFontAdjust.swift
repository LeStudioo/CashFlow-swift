//
//  Title Font Adjust.swift
//  CashFlow
//
//  Created by Théo Sementa on 02/07/2023.
//

import Foundation
import SwiftUI

struct Title: ViewModifier { // TODO: Need to be deleted
    
    var sizeTitle: CGFloat {
        if UIDevice.isIpad {  }
        
        if UIScreen.main.bounds.width < 390 {
            return 24
        } else {
            return 28
        }
    }
    
    func body(content: Content) -> some View {
        content
            .font(.custom("PlusJakartaSans-Bold", size: sizeTitle))
        
    }
}

extension View {
    func titleAdjustSize() -> some View {
        modifier(Title())
    }
}
