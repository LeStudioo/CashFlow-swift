//
//  TPieChart.swift
//  CustomPieChart
//
//  Created by KaayZenn on 10/08/2024.
//

import Foundation
import SwiftUI

struct PieChart: View {
    
    // Builder
    var slices: [PieSliceData]
    var backgroundColor: Color
    
    // Configuration
    var pieSizeRatio: Double
    var holeSizeRatio: Double
    var lineWidthMultiplier: Double
    var chartStyle: PieChartStyle
    var height: CGFloat
    var isInteractive: Bool

    // Environment
    @EnvironmentObject private var filter: FilterManager
    
    // Other
    @State private var activeSlice: PieSliceData? = nil
    
    // Computed
    var values: [Double] {
        return PieChart.adjustValues(slices.map(\.value))
    }
    var colors: [Color] {
        return slices.map(\.color)
    }
    var icons: [String] {
        return slices.map(\.iconName)
    }
    var percentage: Double {
        if let activeSlice {
            return (activeSlice.value / slices.map(\.value).reduce(0, +)) * 100
        } else { return 0 }
    }

    // MARK: -
    var body: some View {
        GeometryReader { geometry in
            let adjustedValues =  PieChart.adjustValues(values)
            let total = adjustedValues.reduce(0, +)
            let angles = adjustedValues.reduce(into: [Angle(degrees: 0)]) { angles, value in
                angles.append(angles.last! + Angle(degrees: 360 * (value / total)))
            }
            
            let shorterSideLength = min(geometry.size.width, geometry.size.height)
            let radius = shorterSideLength * pieSizeRatio / 2
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let lineWidth = shorterSideLength * pieSizeRatio * (values.count > 1 ? lineWidthMultiplier : 0)
            
            ZStack {
                ForEach(0..<values.count, id: \.self) { index in
                    PieSlice(startAngle: angles[index], endAngle: angles[index + 1])
                        .fill(colors[index % colors.count])
                        .scaleEffect(self.activeSlice == slices[index] ? 1.05 : 1)
                        .animation(Animation.spring(), value: activeSlice)
                        .overlay(
                            PieSlice(startAngle: angles[index], endAngle: angles[index + 1])
                                .stroke(backgroundColor, lineWidth: lineWidth)
                                .scaleEffect(self.activeSlice == slices[index] ? 1.05 : 1)
                        )
                        .onTapGesture {
                            if isInteractive {
                                if let activeSlice, activeSlice == slices[index] {
                                    withAnimation { self.activeSlice = nil }
                                } else {
                                    withAnimation { self.activeSlice = slices[index] }
                                }
                            }
                        }
                    
                    if index < icons.count {
                        let midAngle = (angles[index] + angles[index + 1]) / 2
                        let iconRadius = radius * (1.2 + holeSizeRatio) / 2
                        let iconPosition = CGPoint(
                            x: center.x + cos(midAngle.radians - .pi / 2) * iconRadius,
                            y: center.y + sin(midAngle.radians - .pi / 2) * iconRadius
                        )
                        
                        CustomOrSystemImage(
                            systemImage: icons[index],
                            size: 16
                        )
                        .position(iconPosition)
                    }
                } // End ForEach
                
                if holeSizeRatio > 0 {
                    Circle()
                        .fill(backgroundColor)
                        .frame(width: radius * 2 * holeSizeRatio, height: radius * 2 * holeSizeRatio)
                        .overlay {
                            VStack(spacing: 8) {
                                Group {
                                    if let cat = CategoryRepository.shared.findCategoryById(activeSlice?.categoryID) {
                                        if chartStyle == .category {
                                            Text(cat.name)
                                        } else if let subcat = CategoryRepository.shared.findSubcategoryById(activeSlice?.subcategoryID) {
                                            Text(subcat.name)
                                        }
                                    } else {
                                        Text(monthDisplayedInPieChart())
                                    }
                                }
                                .font(Font.mediumText16())
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .foregroundStyle(Color.gray)
                                .isDisplayed(isInteractive)
                                
                                Text((self.activeSlice == nil ? values.reduce(0, +).toCurrency() : activeSlice?.value.toCurrency()) ?? "")
                                    .foregroundStyle(Color(uiColor: .label))
                                    .font(.semiBoldCustom(size: 20))
                                
                                if activeSlice != nil {
                                    Text(percentage.formatWith(2) + "%")
                                        .foregroundStyle(Color(uiColor: .label))
                                        .font(Font.mediumText16())
                                }
                            }
                        }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(height: height)
    } // End body
} // End struct

extension PieChart {
    
    func monthDisplayedInPieChart() -> String {
        let components = Calendar.current.dateComponents([.month, .year], from: filter.date)
        
//        if !filter.automation && !filter.total {
            if let month = components.month, let year = components.year {
                return Calendar.current.monthSymbols[month - 1].capitalized + " \(year)"
            } else { return "" }
//        } else if filter.automation && !filter.total {
//            if let month = components.month {
//                return Calendar.current.monthSymbols[month - 1]
//            } else { return "" }
//        } else if !filter.automation && filter.total {
//            return "word_total".localized
//        } else if filter.automation && filter.total {
//            return "word_total_auto".localized
//        }
        
//        return ""
    }
    
}


//var categoriesWithExpenses: [PredefinedCategory] {
//    var categoriesWithout0: [PredefinedCategory] = []
//    
//    for category in Array(categories) {
//        if !filter.automation && !filter.total {
//            if category.expensesTransactionsAmountForSelectedDate(filter: filter) > 0 { categoriesWithout0.append(category)
//            }
//        } else if filter.automation && !filter.total {
//            if category.expensesAutomationsTransactionsAmountForSelectedDate(selectedDate: filter.date) > 0 {
//                categoriesWithout0.append(category)
//            }
//        } else if !filter.automation && filter.total {
//            if category.amountTotalOfExpenses > 0 {
//                categoriesWithout0.append(category)
//            }
//        } else if filter.automation && filter.total {
//            if category.amountTotalOfExpensesAutomations > 0 {
//                categoriesWithout0.append(category)
//            }
//        }
//    }
//    
//    return categoriesWithout0.sorted { $0.amountTotalOfExpenses < $1.amountTotalOfExpenses }
//}
//func stringDisplayInCircle() -> String {
//    
//    let components = Calendar.current.dateComponents([.month, .year], from: filter.date)
//    
//    if !filter.automation && !filter.total {
//        if let month = components.month {
//            return Calendar.current.monthSymbols[month - 1]
//        } else { return "" }
//    } else if filter.automation && !filter.total {
//        if let month = components.month {
//            return Calendar.current.monthSymbols[month - 1]
//        } else { return "" }
//    } else if !filter.automation && filter.total {
//        return "word_total".localized
//    } else if filter.automation && filter.total {
//        return "word_total_auto".localized
//    }
//    
//    return ""
//}
//
//var values: [Double] {
//    if !filter.automation && !filter.total {
//        return categoriesWithExpenses.map { $0.expensesTransactionsAmountForSelectedDate(filter: filter) }
//    } else if filter.automation && !filter.total {
//        return categoriesWithExpenses.map { $0.expensesAutomationsTransactionsAmountForSelectedDate(selectedDate: filter.date) }
//    } else if !filter.automation && filter.total {
//        return categoriesWithExpenses.map { $0.amountTotalOfExpenses }
//    } else if filter.automation && filter.total {
//        return categoriesWithExpenses.map { $0.amountTotalOfExpensesAutomations }
//    }
//    return []
//}
