//
//  ValidateButton.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct ValidateButton: View {

    var action: () -> Void
    var validate: Bool

    //MARK: - Body
    var body: some View {
        Button(action: action, label: {
            ZStack {
                Capsule()
                    .foregroundStyle(ThemeManager.theme.color)
                    .frame(height: isLittleIphone ? 50 : 60)
                    .if(validate, transform: { view in
                        view.shadow(color: ThemeManager.theme.color, radius: 8)
                    })
                HStack {
                    Spacer()
                    Text("word_validate".localized)
                        .font(.semiBoldCustom(size: 20))
                        .foregroundStyle(.primary0)
                    Spacer()
                }
            }
        })
        .disabled(!validate)
        .opacity(validate ? 1 : 0.4)
        .padding(.horizontal, 8)
    }//END body

    //MARK: Fonctions

}//END struct

//MARK: - Preview
struct ValidateButton_Previews: PreviewProvider {
    static var previews: some View {
        ValidateButton(action: { }, validate: true)
    }
}
