//
//  CreateButton.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct CreateButton: View {

    var action: () -> Void
    var validate: Bool

    //MARK: - Body
    var body: some View {
        Button(action: action, label: {
            ZStack {
                Capsule()
                    .foregroundColor(HelperManager().getAppTheme().color)
                    .frame(height: isLittleIphone ? 50 : 60)
                    .if(validate, transform: { view in
                        view.shadow(color: HelperManager().getAppTheme().color, radius: 8)
                    })
                HStack {
                    Spacer()
                    Text("word_create".localized)
                        .font(.semiBoldCustom(size: 20))
                        .foregroundColor(.primary0)
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
struct CreateButton_Previews: PreviewProvider {
    
    static private var validate: Bool = false
    
    static var previews: some View {
        CreateButton(action: {}, validate: validate)
    }
}
