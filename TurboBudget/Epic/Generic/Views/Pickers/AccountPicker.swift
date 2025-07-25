//
//  AccountPicker.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/11/2024.
//

import SwiftUI
import TheoKit
import DesignSystemModule
import CoreModule

struct AccountPicker: View {
    
    // Builder
    var title: String
    @Binding var selected: AccountModel?
    
    @EnvironmentObject private var accountStore: AccountStore
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .padding(.leading, 8)
                .font(.system(size: 12, weight: .regular))
            
            Picker(selection: $selected) {
                ForEach(accountStore.allAccounts) { account in
                    Button { } label: {
                        Text(account.name)
                        Text(account.balance.toCurrency())
                    }.tag(account)
                }
            } label: {
                Text(selected?.name ?? "")
            }
            .fullWidth(.trailing)
            .tint(themeManager.theme.color)
            .padding(8)
            .roundedRectangleBorder(
                TKDesignSystem.Colors.Background.Theme.bg100,
                radius: CornerRadius.medium,
                lineWidth: 1,
                strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
            )
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    AccountPicker(title: Word.Classic.senderAccount, selected: .constant(.mockClassicAccount))
}
