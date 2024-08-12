//
//  PieChartViewNoInteractive.swift
//  CashFlow
//
//  Created by KaayZenn on 02/09/2023.
//

import SwiftUI

struct PieChartViewNoInteractive: View {

    var categories: [PredefinedCategory]
    
    var widthFraction: CGFloat = 0.75
    var innerRadiusFraction: CGFloat = 0.60
    
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    
    var categoriesWithExpenses: [PredefinedCategory] {
        var categoriesWithout0: [PredefinedCategory] = []
        
        for category in Array(categories) {
            if category.getAllExpensesTransactionsForChosenMonth(selectedDate: .now).map({ $0.amount }).reduce(0, -) > 0 {
                categoriesWithout0.append(category)
            }
        }
        
        return categoriesWithout0.sorted { $0.amountTotalOfExpenses < $1.amountTotalOfExpenses }
    }
    
    var values: [Double] {
        return categoriesWithExpenses.map { $0.getAllExpensesTransactionsForChosenMonth(selectedDate: .now).map({ $0.amount }).reduce(0, -) }
    }
    
    var iconNames: [String] { return categoriesWithExpenses.map { $0.icon } }
    
    var colors: [Color] { return categoriesWithExpenses.map { $0.color } }
    
    var slices: [PieSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []
        let minimumSliceAngle: Double = 20 // Le minimum requis pour chaque slice

        // Calculer le total des degrés qui doivent être ajoutés pour les slices inférieures au minimum
        let totalDegreesToAdd = values.filter { abs($0) * 360 / sum < minimumSliceAngle }.reduce(0) { $0 + (minimumSliceAngle - abs($1) * 360 / sum) }

        for (i, value) in values.enumerated() {
            var degrees: Double = abs(value) * 360 / sum
            
            // Si la slice est inférieure au minimum, ajustez-la au minimum
            if degrees < minimumSliceAngle {
                degrees = minimumSliceAngle
            } else {
                // Sinon, réduisez proportionnellement pour compenser l'ajout aux petites slices
                degrees -= degrees / (360 - totalDegreesToAdd) * totalDegreesToAdd
            }
            
            let endAngle = endDeg + degrees

//            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endAngle), iconName: iconNames[i], value: value, percentage: String(format: "%.0f%%", value * 100 / sum), color: self.colors[i]))

            endDeg += degrees
        }
        
        return tempSlices
    }

    
    //MARK: Body
    var body: some View {
        HStack {
            Spacer()
            VStack {
                ZStack {
                    ForEach(slices, id: \.self) { slice in
//                        PieSlice(pieSliceData: slice, isGap: slices.count > 1 ? true : false, bigSymbol: false)
                    }
                    .frame(width: width, height: height)
                    
                    Circle()
                        .fill(Color.colorCell)
                        .frame(width: width * innerRadiusFraction, height: height * innerRadiusFraction)
                    
                }
            }
            .foregroundStyle(Color.white)
            Spacer()
        }
        .frame(width: width, height: height)
    }
    //MARK: Fonctions

}//END struct

//MARK: - Preview
#Preview {
    PieChartViewNoInteractive(
        categories: [],
        width: Binding.constant(280),
        height: Binding.constant(280)
    )
}
