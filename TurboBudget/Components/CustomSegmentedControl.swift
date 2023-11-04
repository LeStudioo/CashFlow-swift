//
//  CustomSegmentedControl.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//

import SwiftUI

struct CustomSegmentedControl: View {

    @Binding var selection: ExpenseOrIncome

    //Custom type
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared

    //Environnements
    @Environment(\.colorScheme) private var colorScheme

    //State or Binding String
    var textLeft: String
    var textRight: String

    //State or Binding Int, Float and Double
    var height: CGFloat
    @State private var newX: CGFloat = 0

    //State or Binding Bool

    //Enum

    //Computed var
    
    //Other

    //MARK: - Body
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .frame(height: height)
                    .foregroundColor(Color.color3Apple)
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundColor(HelperManager().getAppTheme().color)
                            .frame(width: (geo.size.width / 2))
                            .padding(2)
                            .offset(x: newX)
                        
                        Text(textLeft)
                            .font(.semiBoldText18())
                            .foregroundColor(selection == .expense ? .white : (colorScheme == .light ? .secondary400 : .secondary300) )
                    }
                
                Text(textRight)
                    .font(.semiBoldText18())
                    .foregroundColor(selection == .income ? .white : (colorScheme == .light ? .secondary400 : .secondary300) )
                    .offset(x: geo.size.width / 4)
            }
            .onTapGesture {
                withAnimation(.spring().speed(1.25)) {
                    if selection == .expense {
                        selection = .income
                        newX = geo.size.width / 2 - 4
                    } else if selection == .income {
                        selection = .expense
                        newX = 0
                    }
                }
                if userDefaultsManager.hapticFeedback { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
            }
            .onChange(of: selection) { _ in
                withAnimation(.spring().speed(1.25)) {
                    if selection == .expense {
                        newX = 0
                    } else if selection == .income {
                        newX = geo.size.width / 2 - 4
                    }
                }
                if userDefaultsManager.hapticFeedback { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
            }
        }
        .frame(height: height)
    }//END body

    //MARK: Fonctions

}//END struct

//MARK: - Preview
struct CustomSegmentedControl_Previews: PreviewProvider {
    
    @State static var selectionPreview: ExpenseOrIncome = .expense
    
    static var previews: some View {
        CustomSegmentedControl(selection: $selectionPreview, textLeft: "Left", textRight: "Right", height: 30)
            .padding()
    }
}
