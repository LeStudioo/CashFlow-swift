//
//  ToolbarDismissKeyboardButtonView.swift
//  CashFlow
//
//  Created by KaayZenn on 27/02/2024.
//

import SwiftUI

struct ToolbarDismissKeyboardButtonView: ToolbarContent {
    
    // MARK: - body
    var body: some ToolbarContent {
        ToolbarItem(placement: .keyboard) {
            HStack {
                EmptyView()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }, label: {
                    Image(systemName: "keyboard.chevron.compact.down.fill")
                        .foregroundColor(HelperManager().getAppTheme().color)
                })
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    } // End body
} // End struct
