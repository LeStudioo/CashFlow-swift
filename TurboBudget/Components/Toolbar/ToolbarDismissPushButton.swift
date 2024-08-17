//
//  ToolbarDismissPushButton.swift
//  CashFlow
//
//  Created by Theo Sementa on 13/08/2024.
//

import SwiftUI

struct ToolbarDismissPushButton: ToolbarContent {
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: -
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: { dismiss() }, label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(uiColor: .label))
            })
        }
    } // End body
} // End struct
