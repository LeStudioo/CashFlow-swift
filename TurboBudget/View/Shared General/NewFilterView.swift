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
                    Text("by_month_word".localized)
                }
                if filter.byMonth {
                    MonthYearWheelPickerView(date: $filter.date)
                }
            }
            
            Section {
                Toggle(isOn: $filter.onlyExpenses) {
                    Text("only_expenses_word".localized)
                }
                
                Toggle(isOn: $filter.onlyIncomes) {
                    Text("only_incomes_word".localized)
                }
            }
            
            Section {
                Picker("sort_by_word".localized, selection: $filter.sortBy) {
                    Text("date_word".localized).tag(FilterSort.date)
                    Text("ascending_order_word".localized).tag(FilterSort.ascendingOrder)
                    Text("descending_order_word".localized).tag(FilterSort.descendingOrder)
                    Text("alphabetic_word".localized).tag(FilterSort.alphabetic)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: filter.byMonth) { newValue in
            if !newValue { filter.date = .now }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    NewFilterView()
}
