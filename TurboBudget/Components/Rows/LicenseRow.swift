//
//  LicenseRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 04/12/2024.
//

import SwiftUI

struct LicenseRow: View {
    
    // MARK: -
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundStyle(Color.green.opacity(0.3))
                .overlay {
                    Image(systemName: "doc.text.fill")
                        .foregroundStyle(.green)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("setting_credits_licences_title".localized)
                    .font(.semiBoldText18())
                    .foregroundStyle(Color(uiColor: .label))
                Text("setting_credits_licences_desc".localized)
                    .font(Font.mediumSmall())
                    .foregroundStyle(.secondary300)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary300)
        }
        .padding(12)
        .padding(.horizontal, 4)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.colorCustomCell)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    LicenseRow()
        .padding()
        .background(Color.background)
}
