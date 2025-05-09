//
//  SearchBarView.swift
//  CashFlow
//
//  Created by Theo Sementa on 09/05/2025.
//

import SwiftUI
import TheoKit

struct SearchBarView: View {
    
    // MARK: Dependencies
    var placeholder: String
    @Binding var searchText: String
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    @FocusState private var isFocused: Bool
    
    // MARK: init
    init(_ placeholder: String, searchText: Binding<String>) {
        self.placeholder = placeholder
        self._searchText = searchText
    }
    
    var isSearching: Bool {
        return !searchText.isEmpty
    }
    
    // MARK: - View
    var body: some View {
        HStack(spacing: 8) {
            Image(.iconSearch)
                .resizable()
                .renderingMode(.template)
                .frame(width: 20, height: 20)
                .foregroundStyle(isSearching ? themeManager.theme.color : TKDesignSystem.Colors.Background.Theme.bg500)
            
            TextField(placeholder, text: $searchText)
                .focused($isFocused)
                .fontWithLineHeight(DesignSystem.Fonts.Body.medium)
                .foregroundStyle(isSearching ? Color.label : TKDesignSystem.Colors.Background.Theme.bg500)
            
            if isSearching {
                Button {
                    searchText = ""
                } label: {
                    Image(.iconXmarkCircle)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color.label)
                }
            }
        }
        .padding(TKDesignSystem.Padding.regular)
        .roundedRectangleBorder(
            TKDesignSystem.Colors.Background.Theme.bg100,
            radius: TKDesignSystem.Radius.medium,
            lineWidth: 1,
            strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
        )
        .onTapGesture {
            isFocused = true
        }
    }
}

// MARK: - Preview
#Preview {
    SearchBarView("kn", searchText: .constant("kn"))
        .padding()
        .background(Color.blue)
        .environmentObject(ThemeManager())
}
