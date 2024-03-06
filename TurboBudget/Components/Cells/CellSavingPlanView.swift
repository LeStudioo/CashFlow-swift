//
//  CellSavingPlanView.swift
//  CashFlow
//
//  Created by Théo Sementa on 24/06/2023.
//

import SwiftUI

struct CellSavingPlanView: View {

    //Custom type
    var savingPlan: SavingPlan

    //Environnements
    @Environment(\.colorScheme) private var colorScheme

    //State or Binding String

    //State or Binding Int, Float and Double
    @State private var percentage: Double = 0
    @State private var increaseWidthAmount: Double = 0

    //State or Binding Bool

	//Enum
	
	//Computed var

    //MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Rectangle()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.color3Apple)
                    .cornerRadius(12)
                    .overlay {
                        if savingPlan.icon.count == 1 {
                            Text(savingPlan.icon)
                                .font(.system(size: 24, weight: .semibold, design: .rounded))
                                .shadow(radius: 2, y: 2)
                        } else if savingPlan.icon.count != 0 && savingPlan.icon.count != 1 {
                            Image(systemName: savingPlan.icon)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color(uiColor: .label))
                                .shadow(radius: 2, y: 2)
                        }
                    }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(uiColor: .label))
            }
            .padding(.top)
            
            Text(savingPlan.title)
                .font(.semiBoldText16())
                .foregroundStyle(Color(uiColor: .label))
                .lineLimit(1)
            
            progressBar()
                .padding(.bottom, 12)
                .padding(.top, -10)
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .frame(height: 150)
        .background(Color.colorCell)
        .cornerRadius(15)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring()) {
                    if savingPlan.actualAmount / savingPlan.amountOfEnd >= 0.96 {
                        percentage = 0.96
                    } else {
                        percentage = savingPlan.actualAmount / savingPlan.amountOfEnd
                    }
                    increaseWidthAmount = 1.1
                }
            }
        }
    }//END body

    //MARK: Fonctions
    
    @ViewBuilder
    func progressBar() -> some View {
        VStack {
            GeometryReader { geometry in
                VStack(spacing: 5) {
                    HStack {
                        Spacer()
                        Text(formatNumber(savingPlan.amountOfEnd))
                    }
                    .font(.semiBoldVerySmall())
                    .foregroundStyle(Color(uiColor: .label))
                    
                    let widthCapsule = geometry.size.width * percentage
                    let widthAmount = formatNumber(savingPlan.actualAmount).widthOfString(usingFont: UIFont(name: nameFontSemiBold, size: 16)!) * increaseWidthAmount
                    
                    Capsule()
                        .frame(height: 24)
                        .foregroundStyle(.color2Apple)
                        .overlay(alignment: .leading) {
                            Capsule()
                                .foregroundStyle(HelperManager().getAppTheme().color)
                                .frame(width: widthCapsule < widthAmount ? widthAmount : widthCapsule)
                                .padding(3)
                                .overlay(alignment: .trailing) {
                                    Text(formatNumber(savingPlan.actualAmount))
                                        .padding(.trailing, 12)
                                        .font(.semiBoldVerySmall())
                                        .foregroundStyle(Color(uiColor: .systemBackground))
                                }
                        }
                }
            }
            .frame(height: 38)
        }
    }

}//END struct

//MARK: - Preview
struct SavingPlanCellView_Previews: PreviewProvider {
    static var previews: some View {
        CellSavingPlanView(savingPlan: SavingPlan.preview1)
            .frame(width: 180, height: 150)
    }
}
