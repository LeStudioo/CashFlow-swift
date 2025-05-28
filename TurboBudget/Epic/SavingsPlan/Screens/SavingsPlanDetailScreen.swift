//
//  SavingsPlanDetailScreen.swift
//  CashFlow
//
//  Created by Théo Sementa on 09/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import AlertKit
import NavigationKit
import StatsKit

struct SavingsPlanDetailScreen: View {
    
    // Builder
    var savingsPlan: SavingsPlanModel
    
    // Environement
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: PurchasesManager
    @EnvironmentObject private var themeManager: ThemeManager
    
    @EnvironmentObject private var savingsPlanStore: SavingsPlanStore
    @EnvironmentObject private var contributionStore: ContributionStore
    
    @State private var savingPlanNote: String = ""
    
    // Enum
    enum Field: CaseIterable {
        case note
    }
    @FocusState var focusedField: Field?
    
    @State private var selectedDate: Date = Date()
    @State private var selectedYear: Int = Date().year
    @State private var contributionsByMonth: [Double] = []
    @State private var amount: Double = 0
        
    var currentSavingsPlan: SavingsPlanModel {
        return savingsPlanStore.savingsPlans.first { $0.id == savingsPlan.id } ?? savingsPlan
    }
    
    // MARK: -
    var body: some View {
        ScrollView {
            Circle()
                .frame(width: 100, height: 100)
                .foregroundStyle(.background100)
                .overlay {
                    Circle()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(themeManager.theme.color)
                        .shadow(color: themeManager.theme.color, radius: 4, y: 2)
                        .overlay {
                            Text(currentSavingsPlan.emoji ?? "")
                                .font(.system(size: 32, weight: .semibold, design: .rounded))
                                .shadow(radius: 2, y: 2)
                        }
                }
            
            Text(currentSavingsPlan.name ?? "")
                .titleAdjustSize()
                .multilineTextAlignment(.center)
                .lineLimit(2)
                     
            VStack(spacing: 40) {
                let amountContributed = contributionStore.getAmountOfContributions()
                VStack(spacing: 8) {
                    ProgressBar(percentage: currentSavingsPlan.percentageComplete)
                        .frame(height: 48)
                    DetailRow(
                        icon: .iconCoins,
                        text: Word.Classic.remaining,
                        value: currentSavingsPlan.amountToTheGoal.toCurrency()
                    )
                    DetailRow(
                        icon: .iconHandCoins,
                        text: Word.Classic.contributed,
                        value: amountContributed.toCurrency()
                    )
                    DetailRow(
                        icon: .iconLandmark,
                        text: Word.Classic.finalTarget,
                        value: currentSavingsPlan.goalAmount?.toCurrency() ?? ""
                    )
                }
               
                VStack(spacing: 8) {
                    if amountContributed != 0 {
                        GenericBarChart(
                            title: selectedDate.formatted(Date.FormatStyle().month(.wide).year()).capitalized,
                            selectedDate: $selectedDate,
                            values: contributionsByMonth,
                            amount: amount
                        )
                        .onChange(of: selectedDate) { _ in
                            if selectedDate.year != selectedYear {
                                selectedYear = selectedDate.year
                                contributionsByMonth = contributionStore.getContributionsAmountByMonth(for: selectedDate.year)
                            }
                            amount = contributionsByMonth[selectedDate.month - 1]
                        }
                        .onChange(of: contributionStore.contributions.count) { _ in
                            contributionsByMonth = contributionStore.getContributionsAmountByMonth(for: selectedDate.year)
                            amount = contributionsByMonth[selectedDate.month - 1]
                        }
                        .onAppear {
                            contributionsByMonth = contributionStore.getContributionsAmountByMonth(for: selectedDate.year)
                            amount = contributionsByMonth[selectedDate.month - 1]
                        }
                    }
                    if currentSavingsPlan.endDate != nil {
                        DetailRow(
                            icon: .iconLandmark,
                            text: Word.Classic.monthlyTarget,
                            value: currentSavingsPlan.monthlyGoalAmount.toCurrency()
                        )
                    }
                    DetailRow(
                        icon: .iconHandCoins,
                        text: Word.Classic.contributedThisMonth,
                        value: contributionStore.getAmountOfContributions(in: .now).toCurrency()
                    )
                }
                
                VStack(spacing: 8) {
                    DetailRow(
                        icon: .iconCalendar,
                        text: Word.Classic.startDate,
                        value: currentSavingsPlan.startDate.formatted(date: .abbreviated, time: .omitted)
                    )
                    DetailRow(
                        icon: .iconHourGlass,
                        text: Word.Classic.daysElapsed,
                        value: "\(currentSavingsPlan.daysSinceStart)"
                    )
                    
                    if let endDate = currentSavingsPlan.endDate {
                        DetailRow(
                            icon: .iconClock,
                            text: Word.Classic.daysRemaining,
                            value: "\(currentSavingsPlan.daysRemaining)"
                        )
                        
                        DetailRow(
                            icon: .iconCalendar,
                            text: Word.Classic.endDate,
                            value: endDate.formatted(date: .abbreviated, time: .omitted)
                        )
                    }
                }
              
                TransactionDetailNoteRowView(note: $savingPlanNote)
                
                VStack(spacing: 8) {
                    HStack {
                        Text("word_contributions".localized)
                            .font(.semiBoldCustom(size: 22))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        NavigationButton(
                            route: .sheet,
                            destination: AppDestination.contribution(.create(savingsPlan: currentSavingsPlan))
                        ) {
                            Image(systemName: "plus")
                                .font(.system(size: 22, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.text)
                        }
                    }
                    
                    if contributionStore.contributions.isNotEmpty {
                        ForEach(contributionStore.contributions) { contribution in
                            ContributionRowView(savingsPlan: currentSavingsPlan, contribution: contribution)
                        }
                    } else {
//                        CustomEmptyView(
//                            type: .empty(.contributions),
//                            isDisplayed: contributionStore.contributions.isEmpty
//                        )
//                        .padding(.top)
                    }
                }
                .padding(.bottom)
            }
        } // ScrollView
        .padding(.horizontal)
        .scrollIndicators(.hidden)
        .onAppear {
            savingPlanNote = currentSavingsPlan.note ?? ""
            EventService.sendEvent(key: .savingsplanDetailPage)
        }
        .onDisappear {
            if savingPlanNote != currentSavingsPlan.note && !savingPlanNote.isEmpty {
                Task {
                    if let savingsPlanID = currentSavingsPlan.id {
                        await savingsPlanStore.updateSavingsPlan(
                            savingsPlanID: savingsPlanID,
                            body: .init(note: savingPlanNote)
                        )
                        EventService.sendEvent(key: .savingsPlanNoteAdded)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarDismissPushButton()
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    NavigationButton(
                        route: .push,
                        destination: AppDestination.savingsPlan(.update(savingsPlan: currentSavingsPlan))
                    ) {
                        Label(Word.Classic.edit.localized, systemImage: "pencil")
                    }
                    
                    NavigationButton(
                        route: .sheet,
                        destination: AppDestination.contribution(.create(savingsPlan: currentSavingsPlan))
                    ) {
                        Label("savingsplan_detail_add_contribution".localized, systemImage: "plus")
                    }
                    
                    Button(
                        role: .destructive,
                        action: { AlertManager.shared.deleteSavingsPlan(savingsPlan: currentSavingsPlan, dismissAction: dismiss) },
                        label: { Label("word_delete".localized, systemImage: "trash.fill") }
                    )
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.text)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                }
            }
            
            ToolbarDismissKeyboardButtonView()
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // body
} // struct

// MARK: - Preview
#Preview {
    SavingsPlanDetailScreen(savingsPlan: .mockClassicSavingsPlan)
}
