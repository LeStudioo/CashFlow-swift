//
//  YearMonthPickerView.swift
//  CashFlow
//
//  Created by KaayZenn on 21/07/2023.
//

import Foundation
import SwiftUI

struct YearMonthPickerView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @ObservedObject var filter: Filter = sharedFilter
        
    let months: [String] = Calendar.current.monthSymbols
    let columns = [GridItem(), GridItem(), GridItem(), GridItem()]
    
    @Binding var update: Bool
    
    var body: some View {
        VStack {
            let dateComponentsYearAndMonth = Calendar.current.dateComponents([.day, .year, .month], from: filter.date)
            //year picker
            if filter.byDay {
                //Day picker
                DatePicker("", selection: $filter.date.animation(), displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .onChange(of: filter.date) { newValue in
                        update.toggle()
                    }
            } else {
                HStack {
                    Image(systemName: "chevron.left")
                        .frame(width: 24.0)
                        .onTapGesture {
                            var dateComponent = DateComponents()
                            dateComponent.year = -1
                            withAnimation {
                                filter.date = Calendar.current.date(byAdding: dateComponent, to: filter.date)!
                                update.toggle()
                            }
                        }
                    
                    Text(String(dateComponentsYearAndMonth.year ?? 0))
                        .font(.semiBoldText18())
                        .transition(.move(edge: .trailing))
                    
                    Image(systemName: "chevron.right")
                        .frame(width: 24.0)
                        .onTapGesture {
                            var dateComponent = DateComponents()
                            dateComponent.year = 1
                            withAnimation {
                                filter.date = Calendar.current.date(byAdding: dateComponent, to: filter.date)!
                                update.toggle()
                            }
                        }
                }.padding(15)
                
                //month picker
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(months, id: \.self) { item in
                        Text(item.prefix(3))
                            .font(Font.mediumText16())
                            .frame(width: 60, height: 33)
                            .bold()
                            .background(item == Calendar.current.monthSymbols[(dateComponentsYearAndMonth.month ?? 0) - 1] ?  ThemeManager.theme.color : Color.clear)
                            .cornerRadius(8)
                            .onTapGesture {
                                var dateComponent = DateComponents()
                                dateComponent.day = 1
                                dateComponent.month = months.firstIndex(of: item)! + 1
                                dateComponent.year = dateComponentsYearAndMonth.year
                                withAnimation {
                                    filter.date = Calendar.current.date(from: dateComponent)!
                                    update.toggle()
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(colorScheme == .light ? Color.primary0 : Color.secondary500)
        .padding(update ? 0 : 0)
    }
}

