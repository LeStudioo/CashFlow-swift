//
//  NewFilterView.swift
//  CashFlow
//
//  Created by KaayZenn on 16/03/2024.
//

import SwiftUI

struct NewFilterView: View {
    
    // Custom
    @ObservedObject var filter = FilterManager.shared
    
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $filter.byMonth) {
                    Text("By month")
                }
                if filter.byMonth {
                    MonthYearWheelPickerView(date: $filter.date)
                }
            }
            
            Section {
                Toggle(isOn: $filter.onlyExpenses) {
                    Text("Only expenses")
                }
                
                Toggle(isOn: $filter.onlyIncomes) {
                    Text("Only incomes")
                }
            }
            
            Section {
                Picker("Sort by", selection: $filter.sortBy) {
                    Text("Date").tag(FilterSort.date)
                    Text("Asceding order").tag(FilterSort.ascendingOrder)
                    Text("Descending Order").tag(FilterSort.descendingOrder)
                    Text("Alphabetic").tag(FilterSort.alphabetic)
                }
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    NewFilterView()
}
