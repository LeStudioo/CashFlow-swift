//
//  CircleWithCheckmark.swift
//  CashFlow
//
//  Created by KaayZenn on 13/08/2023.
//

import SwiftUI

struct CircleWithCheckmark: View {

    //Custom type

    //Environnements

    //State or Binding String

    //State or Binding Int, Float and Double
    @State private var scaleCheckmark: CGFloat = 0

    //State or Binding Bool

	//Enum
	
	//Computed var

    //MARK: - Body
    var body: some View {
        Circle()
            .frame(width: 100, height: 100)
            .foregroundStyle(HelperManager().getAppTheme().color)
            .overlay {
                Image(systemName: "checkmark")
                    .foregroundStyle(.primary0)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .scaleEffect(scaleCheckmark)
            }
            .onAppear {
                withAnimation(.interpolatingSpring(stiffness: 170, damping: 5).delay(0.3)) { scaleCheckmark = 1.2 }
            }
    }//END body

    //MARK: Fonctions

}//END struct

//MARK: - Preview
struct CircleWithCheckmark_Previews: PreviewProvider {
    static var previews: some View {
        CircleWithCheckmark()
    }
}
