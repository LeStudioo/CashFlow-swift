//
//  PeopleRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 04/12/2024.
//

import SwiftUI

struct PeopleRow: View {
    
    // Builder
    var people: People
    
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: -
    var body: some View {
        Button(action: {
//            URLManager.openURL(url: people.url) // TODO: People detail
        }, label: {
            HStack(spacing: 12) {
                Image(people.image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(people.name)
                        .font(.semiBoldText18())
                        .foregroundStyle(Color(uiColor: .label))
                    Text(people.job)
                        .font(Font.mediumSmall())
                        .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
            }
            .padding(12)
            .padding(.horizontal, 4)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.colorCustomCell)
            }
        })
    } // body
} // struct

// MARK: - Preview
#Preview {
    PeopleRow(people: .theoSementa)
        .padding()
        .background(Color.background)
}
