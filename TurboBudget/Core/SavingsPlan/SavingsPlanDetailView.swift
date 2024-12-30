//
//  SavingsPlanDetailView.swift
//  CashFlow
//
//  Created by Théo Sementa on 09/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import AlertKit

struct SavingsPlanDetailView: View {
    
    // Builder
    var savingsPlan: SavingsPlanModel
    
    // Environement
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: PurchasesManager
    @EnvironmentObject private var themeManager: ThemeManager
    
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var savingsPlanStore: SavingsPlanStore
    @EnvironmentObject private var contributionRepository: ContributionStore
    
   
    @State private var savingPlanNote: String = ""
    
    
    // Enum
    enum Field: CaseIterable {
        case note
    }
    @FocusState var focusedField: Field?
        
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
                VStack(spacing: 8) {
                    ProgressBar(percentage: currentSavingsPlan.percentageComplete)
                        .frame(height: 48)
                    DetailRow(
                        icon: UserCurrency.name + "sign.circle.fill",
                        text: "TBL Restant",
                        value: currentSavingsPlan.amountToTheGoal.toCurrency()
                    )
                    DetailRow(
                        icon: "building.columns.fill",
                        text: "TBL Contribué",
                        value: contributionRepository.getAmountOfContributions().toCurrency()
                    )
                    DetailRow(
                        icon: "flag.fill",
                        text: "TBL Objectif final",
                        value: currentSavingsPlan.goalAmount?.toCurrency() ?? ""
                    )
                }
               
                VStack(spacing: 8) {
                    SavingsPlanChart()
                    if currentSavingsPlan.endDate != nil {
                        DetailRow(
                            icon: "flag.fill",
                            text: "TBL Objectif mensuel",
                            value: currentSavingsPlan.monthlyGoalAmount.toCurrency()
                        )
                    }
                    DetailRow(
                        icon: "building.columns.fill",
                        text: "TBL Contribué ce mois-ci",
                        value: contributionRepository.getAmountOfContributions(in: .now).toCurrency()
                    )
                }
                
                VStack(spacing: 8) {
                    DetailRow(
                        icon: "calendar",
                        text: "TBL Date de début",
                        value: currentSavingsPlan.startDate.formatted(date: .abbreviated, time: .omitted)
                    )
                    DetailRow(
                        icon: "clock.fill",
                        text: "TBL Jours écoulés",
                        value: "\(currentSavingsPlan.daysSinceStart)"
                    )
                    
                    if let endDate = currentSavingsPlan.endDate {
                        DetailRow(
                            icon: "hourglass",
                            text: "TBL Jours restants",
                            value: "\(currentSavingsPlan.daysRemaining)"
                        )
                        
                        DetailRow(
                            icon: "calendar",
                            text: "TBL Date de fin",
                            value: endDate.formatted(date: .abbreviated, time: .omitted)
                        )
                    }
                }
              
                TransactionDetailNoteRow(note: $savingPlanNote)
                
                VStack(spacing: 8) {
                    HStack {
                        Text("word_contributions".localized)
                            .font(.semiBoldCustom(size: 22))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        NavigationButton(present: router.presentCreateContribution(savingsPlan: currentSavingsPlan)) {
                            Image(systemName: "plus")
                                .font(.system(size: 22, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.text)
                        }
                    }
                    
                    if contributionRepository.contributions.isNotEmpty {
                        ForEach(contributionRepository.contributions) { contribution in
                            ContributionRow(savingsPlan: currentSavingsPlan, contribution: contribution)
                        }
                    } else {
                        CustomEmptyView(
                            type: .empty(.contributions),
                            isDisplayed: contributionRepository.contributions.isEmpty
                        )
                        .padding(.top)
                    }
                }
                .padding(.bottom)
            }
        } // ScrollView
        .padding(.horizontal)
        .scrollIndicators(.hidden)
        .onAppear {
            savingPlanNote = currentSavingsPlan.note ?? ""
        }
        .onDisappear {
            if savingPlanNote != currentSavingsPlan.note && !savingPlanNote.isEmpty {
                Task {
                    if let savingsPlanID = currentSavingsPlan.id {
                        await savingsPlanStore.updateSavingsPlan(
                            savingsPlanID: savingsPlanID,
                            body: .init(note: savingPlanNote)
                        )
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarDismissPushButton()
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu(content: {
                    Button(
                        action: { router.presentCreateSavingsPlan(savingsPlan: currentSavingsPlan) },
                        label: { Label(Word.Classic.edit.localized, systemImage: "pencil") }
                    )
                    
                    Button(
                        action: { router.presentCreateContribution(savingsPlan: currentSavingsPlan) },
                        label: { Label("savingsplan_detail_add_contribution".localized, systemImage: "plus") }
                    )
                    
                    Button(
                        role: .destructive,
                        action: { AlertManager.shared.deleteSavingsPlan(savingsPlan: currentSavingsPlan, dismissAction: dismiss) },
                        label: { Label("word_delete".localized, systemImage: "trash.fill") }
                    )
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.text)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
            }
            
            ToolbarDismissKeyboardButtonView()
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // body
} // struct

// MARK: - Preview
#Preview {
    SavingsPlanDetailView(savingsPlan: .mockClassicSavingsPlan)
}
