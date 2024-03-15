//
//  DismissButtonInSheet.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//

import SwiftUI

struct DismissButtonInSheet: View {

    //Custom type

    //Environnements
    @Environment(\.dismiss) private var dismiss

    //State or Binding String

    //State or Binding Int, Float and Double

    //State or Binding Bool

    //Enum
    
    //Computed var

    //MARK: - Body
    var body: some View {
        HStack {
            Spacer()
            Button(action: { dismiss() }, label: {
                Image(systemName: "xmark")
                    .foregroundStyle(Color(uiColor: .label))
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
            })
        }
        .padding(isLittleIphone ? 8 : 12)
        .padding([.top, .trailing], 8)
    }//END body

    //MARK: Fonctions

}//END struct

//MARK: - Preview
struct DismissButtonInSheet_Previews: PreviewProvider {
    static var previews: some View {
        DismissButtonInSheet()
    }
}
