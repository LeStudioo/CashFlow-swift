//
//  PieChartView.swift
//  CashFlow
//
//  Created by Théo Sementa on 28/06/2023.
//
// Localizations 01/10/2023

import Foundation
import SwiftUI

//https://betterprogramming.pub/build-pie-charts-in-swiftui-822651fbf3f2
struct PieChartView: View {
    
    @ObservedObject var filter: Filter = sharedFilter
    
    var categories: [PredefinedCategory]
    
    var widthFraction: CGFloat = 0.75
    var innerRadiusFraction: CGFloat = 0.60
    
    @State private var activeSlice: PieSliceData? = nil
    
    @Binding var selectedCategory: PredefinedCategory?
    
    @Binding var height: CGFloat
        
    var categoriesWithExpenses: [PredefinedCategory] {
        var categoriesWithout0: [PredefinedCategory] = []
        
        for category in Array(categories) {
            if !filter.automation && !filter.total {
                if category.expensesTransactionsAmountForSelectedDate(filter: filter) > 0 { categoriesWithout0.append(category)
                }
            } else if filter.automation && !filter.total {
                if category.expensesAutomationsTransactionsAmountForSelectedDate(selectedDate: filter.date) > 0 {
                    categoriesWithout0.append(category)
                }
            } else if !filter.automation && filter.total {
                if category.amountTotalOfExpenses > 0 {
                    categoriesWithout0.append(category)
                }
            } else if filter.automation && filter.total {
                if category.amountTotalOfExpensesAutomations > 0 {
                    categoriesWithout0.append(category)
                }
            }
        }
        
        return categoriesWithout0.sorted { $0.amountTotalOfExpenses < $1.amountTotalOfExpenses }
    }
    
    var values: [Double] {
        if !filter.automation && !filter.total {
            return categoriesWithExpenses.map { $0.expensesTransactionsAmountForSelectedDate(filter: filter) }
        } else if filter.automation && !filter.total {
            return categoriesWithExpenses.map { $0.expensesAutomationsTransactionsAmountForSelectedDate(selectedDate: filter.date) }
        } else if !filter.automation && filter.total {
            return categoriesWithExpenses.map { $0.amountTotalOfExpenses }
        } else if filter.automation && filter.total {
            return categoriesWithExpenses.map { $0.amountTotalOfExpensesAutomations }
        }
        return []
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

            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endAngle), iconName: iconNames[i], value: value, percentage: String(format: "%.0f%%", value * 100 / sum), color: self.colors[i]))

            endDeg += degrees
        }
        
        return tempSlices
    }

    
    //MARK: Body
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {
                    ZStack {
                        ForEach(slices, id: \.self) { slice in
                            PieSlice(pieSliceData: slice, isGap: slices.count > 1 ? true : false, bigSymbol: true)
                                .scaleEffect(self.activeSlice == slice ? 1.03 : 1)
                                .animation(Animation.spring(), value: activeSlice)
                        }
                        .frame(width: height, height: height)
                        .onTapGesture {
                            let actualSlice = activeSlice
                            
                            let radius = 0.5 * height
                            let diff = CGPoint(x: $0.x - radius, y: radius - $0.y)
                            let dist = pow(pow(diff.x, 2.0) + pow(diff.y, 2.0), 0.5)
                            if (dist > radius || dist < radius * innerRadiusFraction) {
                                self.activeSlice = nil
                                self.selectedCategory = nil
                                return
                            }
                            var radians = Double(atan2(diff.x, diff.y))
                            if (radians < 0) {
                                radians = 2 * Double.pi + radians
                            }
                            
                            for slice in slices {
                                if (radians < slice.endAngle.radians) {
                                    withAnimation {
                                        self.activeSlice = slice
                                        self.selectedCategory = PredefinedCategoryManager().categoryBySymbol(symbol: slice.iconName)
                                    }
                                    break
                                }
                            }

                            if actualSlice == activeSlice {
                                withAnimation { activeSlice = nil; selectedCategory = nil }
                            }
                        }
                        
                        Circle()
                            .fill(Color.colorCell)
                            .frame(width: height * innerRadiusFraction, height: height * innerRadiusFraction)
                        
                        VStack(spacing: 10) {
                            //Month or name of category
                            Text(((self.activeSlice == nil ? stringDisplayInCircle() : PredefinedCategoryManager().categoryBySymbol(symbol: activeSlice?.iconName ?? "")?.title ?? "")))
                                .font(Font.mediumText18())
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .foregroundStyle(Color.gray)
                                .frame(width: height != 0 ? height * innerRadiusFraction - 20 : 0)
                            
                            //Amount
                            Text(self.activeSlice == nil ? values.reduce(0, -).currency : (-(activeSlice?.value ?? 0)).currency)
                                .foregroundStyle(Color(uiColor: .label))
                                .font(.semiBoldCustom(size: 20))
                            
                            //Percentage
                            Text(activeSlice == nil ? "" : activeSlice?.percentage ?? "")
                                .foregroundStyle(Color(uiColor: .label))
                                .font(Font.mediumText16())
                        }
                        
                    }
                    
                    //                     PieChartRows(colors: self.colors, names: self.names, values: self.values.map { self.formatter($0) }, percents: self.values.map { String(format: "%.0f%%", $0 * 100 / self.values.reduce(0, +)) })
                }
                .foregroundStyle(Color.white)
                Spacer()
            }
            .onAppear {
                height = isIPad ? widthFraction * geometry.size.width / 3 : widthFraction * geometry.size.width
            }
        }
    }
    
    //MARK: Fonctions
    func stringDisplayInCircle() -> String {
        
        let components = Calendar.current.dateComponents([.month, .year], from: filter.date)
        
        if !filter.automation && !filter.total {
            if let month = components.month {
                return Calendar.current.monthSymbols[month - 1]
            } else { return "" }
        } else if filter.automation && !filter.total {
            if let month = components.month {
                return Calendar.current.monthSymbols[month - 1]
            } else { return "" }
        } else if !filter.automation && filter.total {
            return "word_total".localized
        } else if filter.automation && filter.total {
            return "word_total_auto".localized
        }
        
        return ""
    }
}

//@available(OSX 10.15, *)
//struct PieChartRows: View {
//    var colors: [Color]
//    var names: [String]
//    var values: [String]
//    var percents: [String]
//
//    var body: some View {
//        VStack{
//            ForEach(0..<self.values.count){ i in
//                HStack {
//                    RoundedRectangle(cornerRadius: 5.0)
//                        .fill(self.colors[i])
//                        .frame(width: 20, height: 20)
//                    Text(self.names[i])
//                    Spacer()
//                    VStack(alignment: .trailing) {
//                        Text(self.values[i])
//                        Text(self.percents[i])
//                            .foregroundStyle(Color.gray)
//                    }
//                }
//            }
//        }
//    }
//}

#Preview {
    PieChartView(
        categories: [categoryPredefined1,
                     categoryPredefined2,
                     categoryPredefined3],
        selectedCategory: Binding.constant(categoryPredefined1),
        height: Binding.constant(280)
    )
}



