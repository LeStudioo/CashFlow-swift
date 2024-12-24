//
//  AccountPicker.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/11/2024.
//

import SwiftUI

struct AccountPicker: View {
    
    // Builder
    var title: String
    @Binding var selected: AccountModel?
    
    @EnvironmentObject private var accountRepository: AccountStore
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .padding(.leading, 8)
                .font(.system(size: 12, weight: .regular))
            
            Menu(content: {
                ForEach(accountRepository.allAccounts) { account in
                    Button { selected = account } label: {
                        Text(account.name)
                    }
                }
            }, label: {
                Text(selected?.name ?? "")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding()
            })
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .foregroundStyle(Color.background200)
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    AccountPicker(title: Word.Classic.senderAccount, selected: .constant(.mockClassicAccount))
}
