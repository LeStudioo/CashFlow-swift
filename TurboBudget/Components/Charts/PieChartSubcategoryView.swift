//
//  PieChartSubcategoryView.swift
//  CashFlow
//
//  Created by Théo Sementa on 29/06/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct PieChartSubcategoryView: View {
    
    @ObservedObject var filter: Filter = sharedFilter
    
    var subcategories: [PredefinedSubcategory]
    
    var widthFraction: CGFloat = 0.75
    var innerRadiusFraction: CGFloat = 0.60
    
    @State private var activeSlice: PieSliceData? = nil
    
    @Binding var selectedSubcategory: PredefinedSubcategory?
    
    @Binding var height: CGFloat
        
    var subcategoriesWithExpenses: [PredefinedSubcategory] {
        var subcategoriesWithout0: [PredefinedSubcategory] = []
        for subcategory in Array(subcategories) {
            if !filter.automation && !filter.total {
                if subcategory.expensesTransactionsAmountForSelectedDate(filter: filter) > 0 {
                    subcategoriesWithout0.append(subcategory)
                }
            } else if filter.automation && !filter.total {
                if subcategory.expensesAutomationsTransactionsAmountForSelectedDate(selectedDate: filter.date) > 0 {
                    subcategoriesWithout0.append(subcategory)
                }
            } else if !filter.automation && filter.total {
                if subcategory.amountTotalOfExpenses > 0 {
                    subcategoriesWithout0.append(subcategory)
                }
            } else if filter.automation && filter.total {
                if subcategory.amountTotalOfExpensesAutomations > 0 {
                    subcategoriesWithout0.append(subcategory)
                }
            }
        }
        return subcategoriesWithout0.sorted { $0.amountTotalOfExpenses < $1.amountTotalOfExpenses }
    }
    
    var values: [Double] {
        if !filter.automation && !filter.total {
            return subcategoriesWithExpenses.map { $0.expensesTransactionsAmountForSelectedDate(filter: filter) }
        } else if filter.automation && !filter.total {
            return subcategoriesWithExpenses.map { $0.expensesAutomationsTransactionsAmountForSelectedDate(selectedDate: filter.date) }
        } else if !filter.automation && filter.total {
            return subcategoriesWithExpenses.map { $0.amountTotalOfExpenses }
        } else if filter.automation && filter.total {
            return subcategories.map { $0.amountTotalOfExpensesAutomations }
        }
        return []
    }
    
    var iconNames: [String] { return subcategoriesWithExpenses.map { $0.icon } }
    
    var colors: [Color] { return subcategoriesWithExpenses.map { $0.category.color } }
    
    //    var slices: [PieSliceData] {
    //        let sum = values.reduce(0, +)
    //        var endDeg: Double = 0
    //        var tempSlices: [PieSliceData] = []
    //
    //        for (i, value) in values.enumerated() {
    //                let degrees: Double = value * 360 / sum
    //            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), iconName: iconNames[i], value: value, percentage: String(format: "%.0f%%", value * 100 / sum), color: self.colors[i]))
    //                endDeg += degrees
    //        }
    //        return tempSlices
    //    }
    
    var slices: [PieSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var counterOf: Double = 0
        var tempSlices: [PieSliceData] = []
        let minimumSliceAngle: Double = 20 // Le minimum requis pour chaque slice (vous pouvez ajuster cette valeur)
        
        // Trouver la slice avec la valeur la plus grande (en valeur absolue)
        var maxSliceIndex = 0
        var maxSliceValue = values.isEmpty ? 0 : abs(values[0])
        for (i, value) in values.enumerated() {
            if abs(value) > maxSliceValue {
                maxSliceValue = abs(value)
                maxSliceIndex = i
            }
        }
        
        for (i, value) in values.enumerated() {
            var degrees: Double = abs(value) * 360 / sum
            
            // Vérifier si la taille angulaire est inférieure au minimum requis
            if degrees < minimumSliceAngle {
                degrees = minimumSliceAngle // Ajuster la taille angulaire au minimum requis
                counterOf += 1
            }
            
            // Vérifier si c'est la slice avec la plus grande valeur (en valeur absolue) et ajuster son angle
            if i == maxSliceIndex {
                degrees -= (minimumSliceAngle * counterOf) - Double(values.count)
            }
            
            var endAngle = endDeg + degrees
            
            if endAngle > 360 { endAngle = 360 }
            
            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endAngle), iconName: iconNames[i], value: value, percentage: String(format: "%.0f%%", value * 100 / sum), color: self.colors[i]))
            
            endDeg += degrees
        }
        return tempSlices
    }
    
    //MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Spacer()
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
                                self.selectedSubcategory = nil
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
                                        self.selectedSubcategory = PredefinedSubcategoryManager().subcategoryForSymbol(subcategories: subcategories, symbol: slice.iconName)
                                    }
                                    break
                                }
                            }
                            
                            if actualSlice == activeSlice {
                                withAnimation { activeSlice = nil; selectedSubcategory = nil }
                            }
                        }
                        
                        Circle()
                            .fill(Color.colorCell)
                            .frame(width: height * innerRadiusFraction, height: height * innerRadiusFraction)
                        
                        VStack {
                            VStack(spacing: 10) {
                                //Month of name of category
                                Text(((self.activeSlice == nil ? stringDisplayInCircle() : PredefinedSubcategoryManager().subcategoryForSymbol(subcategories: subcategories, symbol: activeSlice?.iconName ?? "")?.title) ?? ""))
                                    .font(Font.mediumText18())
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .foregroundStyle(Color.gray)
                                    .frame(width: height * innerRadiusFraction - 20)
                                
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
                        
                    }
                    Spacer()
                    
                    //                     PieChartRows(colors: self.colors, names: self.names, values: self.values.map { self.formatter($0) }, percents: self.values.map { String(format: "%.0f%%", $0 * 100 / self.values.reduce(0, +)) })
                }
                .foregroundStyle(Color.white)
            }
            .onAppear {
                height = isIPad ? widthFraction * geometry.size.width / 3 : widthFraction * geometry.size.width
            }
        }
    }//END body
    
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
    
}//END struct

//MARK: - Preview
#Preview {
    PieChartSubcategoryView(
        subcategories: [subCategory1Category1],
        selectedSubcategory: Binding.constant(subCategory1Category1),
        height: Binding.constant(280)
    )
}
