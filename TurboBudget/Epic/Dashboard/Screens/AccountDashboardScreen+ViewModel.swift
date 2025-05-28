//
//  AccountDashboardViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 20/11/2024.
//

import Foundation
import SwiftUI

extension AccountDashboardScreen {
    
    final class ViewModel: ObservableObject {
        
        @Published var accountName: String = ""
        @Published var accountNameForDeleting: String = ""
        
        @Published var isDeleting: Bool = false
        @Published var isEditingAccountName: Bool = false
        
        // Computed var
        var columns: [GridItem] {
            if UIDevice.isIpad {
                return [GridItem(spacing: 16), GridItem(spacing: 16), GridItem(spacing: 16), GridItem(spacing: 16)]
            } else {
                return [GridItem(spacing: 16), GridItem(spacing: 16)]
            }
        }
        
    }
    
}
