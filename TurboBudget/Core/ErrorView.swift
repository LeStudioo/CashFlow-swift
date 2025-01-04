//
//  ErrorView.swift
//  CashFlow
//
//  Created by KaayZenn on 26/09/2023.
//
// Localizations 01/10/2023

import SwiftUI

// TODO: Delete use the new empty
struct ErrorView: View {
    
    // Builder
    var searchResultsCount: Int
    var searchText: String
    var image: String
    var text: String
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Body
    var body: some View {
        if searchResultsCount == 0 && !searchText.isEmpty {
            VStack(spacing: 20) {
                Image("NoResults\(themeManager.theme.nameNotLocalized.capitalized)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 4, y: 4)
                    .frame(width: UIDevice.isIpad
                           ? UIScreen.main.bounds.width / 3
                           : UIScreen.main.bounds.width / 1.5
                    )
                
                if !searchText.isEmpty {
                    Text("word_no_results".localized + " '\(searchText)'")
                        .font(Font.mediumText16())
                        .multilineTextAlignment(.center)
                }
            }
            .offset(y: -20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            VStack(spacing: 20) {
                Image(image + themeManager.theme.nameNotLocalized.capitalized)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 4, y: 4)
                    .frame(width: UIDevice.isIpad
                           ? UIScreen.main.bounds.width / 3
                           : UIScreen.main.bounds.width / 1.5
                    )
                
                Text(text)
                    .font(Font.mediumText16())
                    .multilineTextAlignment(.center)
            }
            .offset(y: -20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    ErrorView(
        searchResultsCount: 0,
        searchText: "Test",
        image: "NoAutomation",
        text: "Error"
    )
}
