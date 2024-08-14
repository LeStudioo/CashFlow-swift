//
//  CellAutomationView.swift
//  CashFlow
//
//  Created by KaayZenn on 18/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import SwipeActions

struct CellAutomationView: View {

    // Builder
    @ObservedObject var automation: Automation

    // Environement
    @EnvironmentObject private var automationRepo: AutomationRepository
    @Environment(\.colorScheme) private var colorScheme
    
    // Boolean variables
    @State private var isDeleting: Bool = false
    @State private var cancelDeleting: Bool = false

    //MARK: - Body
    var body: some View {
        if let transaction = automation.automationToTransaction {
            SwipeView(label: {
                HStack {
                    Circle()
                        .foregroundStyle(.color2Apple)
                        .frame(width: 50)
                        .overlay {
                            if let category = automation.category, let subcategory = automation.subcategory {
                                Circle()
                                    .foregroundStyle(category.color)
                                    .shadow(radius: 4, y: 4)
                                    .frame(width: 34)
                                
                                Image(systemName: subcategory.icon)
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundStyle(Color(uiColor: .systemBackground))
                                
                            } else if let category = automation.category, automation.subcategory == nil {
                                Circle()
                                    .foregroundStyle(category.color)
                                    .shadow(radius: 4, y: 4)
                                    .frame(width: 34)
                                
                                Image(systemName: category.icon)
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundStyle(Color(uiColor: .systemBackground))
                            } else {
                                Circle()
                                    .foregroundStyle(transaction.amount < 0 ? .error400 : .primary500)
                                    .shadow(radius: 4, y: 4)
                                    .frame(width: 34)
                                
                                Text(Locale.current.currencySymbol ?? "$")
                                    .foregroundStyle(Color(uiColor: .systemBackground))
                            }
                        }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(transaction.amount < 0 ? "word_automation_expense".localized : "word_automation_income".localized)
                            .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                            .font(Font.mediumSmall())
                        Text(transaction.title)
                            .font(.semiBoldText18())
                            .foregroundStyle(Color(uiColor: .label))
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        Text(transaction.amount.currency)
                            .font(.semiBoldText16())
                            .foregroundStyle(transaction.amount < 0 ? .error400 : .primary500)
                            .lineLimit(1)
                        Text(transaction.date.formatted(date: .numeric, time: .omitted))
                            .font(Font.mediumSmall())
                            .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                            .lineLimit(1)
                    }
                }
                .padding(12)
                .background(Color.colorCell)
                .cornerRadius(15)
            }, trailingActions: { context in
                SwipeAction(action: {
                    isDeleting.toggle()
                }, label: { _ in
                    VStack(spacing: 5) {
                        Image(systemName: "trash")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        Text("word_DELETE".localized)
                            .font(.semiBoldCustom(size: 10))
                    }
                    .foregroundStyle(Color(uiColor: .systemBackground))
                }, background: { _ in
                    Rectangle()
                        .foregroundStyle(.error400)
                })
                .onChange(of: cancelDeleting) { _ in
                    context.state.wrappedValue = .closed
                }
            })
            .swipeActionsStyle(.cascade)
            .swipeActionWidth(90)
            .swipeActionCornerRadius(15)
            .swipeMinimumDistance(30)
            .padding(.vertical, 4)
            .padding(.horizontal)
            .alert("transaction_cell_delete_auto".localized, isPresented: $isDeleting, actions: {
                Button(role: .cancel, action: { cancelDeleting.toggle(); return }, label: { Text("word_cancel".localized) })
                Button(
                    role: .destructive,
                    action: { automationRepo.deleteAutomation(automation) },
                    label: { Text("word_delete".localized) }
                )
            }, message: {
                Text("transaction_cell_delete_auto_desc".localized)
            })
        } // End id
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CellAutomationView(automation: Automation.preview)
}
