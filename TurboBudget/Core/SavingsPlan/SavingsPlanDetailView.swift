//
//  SavingsPlanDetailView.swift
//  CashFlow
//
//  Created by Théo Sementa on 09/07/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct SavingsPlanDetailView: View {
    
    //Custom type
    @ObservedObject var savingsPlan: SavingsPlanModel
    
    // Environement
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: PurchasesManager
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var alertManager: AlertManager
    
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var savingsPlanRepository: SavingsPlanRepository
    @EnvironmentObject private var contributionRepository: ContributionRepository
    
    //State or Binding String
    @State private var savingPlanNote: String = ""
    
    //Enum
    enum Field: CaseIterable {
        case note
    }
    @FocusState var focusedField: Field?
    
    var percentage: Double {
        guard let currentAmount = savingsPlan.currentAmount else { return 0 }
        guard let goalAmount = savingsPlan.goalAmount else { return 0 }
        
        if currentAmount / goalAmount > 0.98 {
            return 0.98
        } else {
            return currentAmount / goalAmount
        }
    }
        
    // MARK: -
    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                Circle()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.colorCell)
                    .overlay {
                        Circle()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(themeManager.theme.color)
                            .shadow(color: themeManager.theme.color, radius: 4, y: 2)
                            .overlay {
                                Text(savingsPlan.emoji ?? "")
                                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                                    .shadow(radius: 2, y: 2)
                            }
                    }
                Spacer()
            }
            
            Text(savingsPlan.name ?? "")
                .titleAdjustSize()
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            progressBar()
                .padding(.horizontal, 12)
            
            if let endDate = savingsPlan.endDate {
                DetailRow(
                    icon: "calendar",
                    text: Word.Classic.finalTargetDate,
                    value: endDate.formatted(date: .abbreviated, time: .omitted)
                )
                .padding(.horizontal, 12)
            }
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $savingPlanNote)
                    .focused($focusedField, equals: .note)
                    .scrollContentBackground(.hidden)
                    .font(Font.mediumText16())
                
                if savingPlanNote.isEmpty {
                    HStack {
                        Text("savingsplan_detail_note".localized)
                            .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                            .font(Font.mediumText16())
                        Spacer()
                    }
                    .padding([.leading, .top], 8)
                    .onTapGesture { focusedField = .note }
                }
            }
            .padding(12)
            .background(Color.colorCell)
            .frame(height: 140)
            .cornerRadius(15)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            
            //            archivedOrDeleteButton()
            
            HStack {
                Text("word_contributions".localized)
                    .font(.semiBoldCustom(size: 22))
                Spacer()
                Button(action: { router.presentCreateContribution(savingsPlan: savingsPlan) }, label: {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(uiColor: .label))
                })
            }
            .padding(.top)
            .padding(.horizontal, 12)
            
            ForEach(contributionRepository.contributions) { contribution in
                ContributionRow(savingsPlan: savingsPlan, contribution: contribution)
            }
            
            Spacer()
        } // ScrollView
        .scrollIndicators(.hidden)
        .onAppear {
            savingPlanNote = savingsPlan.note ?? ""
        }
        .onDisappear {
            if savingPlanNote != savingsPlan.note && savingPlanNote != "" {
                Task {
                    if let savingsPlanID = savingsPlan.id {
                        await savingsPlanRepository.updateSavingsPlan(
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
                        action: { router.presentCreateSavingsPlan(savingsPlan: savingsPlan) },
                        label: { Label(Word.Classic.edit.localized, systemImage: "pencil") }
                    )
                    
                    Button(
                        action: { router.presentCreateContribution(savingsPlan: savingsPlan) },
                        label: { Label("savingsplan_detail_add_contribution".localized, systemImage: "plus") }
                    )
                    
                    Button(
                        role: .destructive,
                        action: { alertManager.deleteSavingsPlan(savingsPlan: savingsPlan, dismissAction: dismiss) },
                        label: { Label("word_delete".localized, systemImage: "trash.fill") }
                    )
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color(uiColor: .label))
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
            }
            
            ToolbarItem(placement: .keyboard) {
                HStack {
                    EmptyView()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(action: { focusedField = nil }, label: { Image(systemName: "keyboard.chevron.compact.down.fill").foregroundStyle(themeManager.theme.color) })
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    } // body
    
    //MARK: - ViewBuilder
    @ViewBuilder
    func progressBar() -> some View {
        if let currentAmount = savingsPlan.currentAmount, let goalAmount = savingsPlan.goalAmount, goalAmount > 0 {
            
            let percentage: Double = min(currentAmount / goalAmount, 1.0)
            
            VStack(spacing: 6) {
                HStack {
                    Text(0.toCurrency())
                    Spacer()
                    Text(goalAmount.toCurrency())
                }
                .font(.semiBoldText16())
                .foregroundStyle(Color(uiColor: .label))
                
                GeometryReader { geometry in
                    let widthAmount = currentAmount.toCurrency()
                        .widthOfString(usingFont: UIFont(name: nameFontSemiBold, size: 16)!) * 1.5
                    let widthPercentage = geometry.size.width * percentage
                    
                    Capsule()
                        .foregroundStyle(.colorCell)
                        .overlay(alignment: .leading) {
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .foregroundStyle(themeManager.theme.color)
                                    .frame(width: max(widthAmount, widthPercentage))
                                
                                Text(currentAmount.toCurrency())
                                    .padding(.trailing, 12)
                                    .font(.semiBoldText16())
                                    .foregroundStyle(Color(uiColor: .systemBackground))
                                    .padding(.leading, 8)
                            }
                            .padding(4)
                        }
                }
                .frame(height: 40)
            }
        } else {
            EmptyView()
        }
    }
    
    //    @ViewBuilder
    //    func archivedOrDeleteButton() -> some View {
    //        if savingPlan.actualAmount == savingPlan.amountOfEnd {
    //            HStack {
    //                Button(action: {
    //                    dismiss()
    //                    withAnimation {
    //                        if savingPlan.isArchived {
    //                            if savingPlan.dateOfEnd != nil { savingPlan.dateOfEnd = nil }
    //                            savingPlan.isArchived = false
    //                        } else {
    //                            if savingPlan.dateOfEnd == nil { savingPlan.dateOfEnd = Date() }
    //                            savingPlan.isArchived = true
    //                        }
    //                        persistenceController.saveContext()
    //                    }
    //                }, label: {
    //                    HStack {
    //                        Spacer()
    //                        Image(systemName: savingPlan.isArchived ? "tray.and.arrow.up.fill" : "tray.and.arrow.down.fill")
    //                            .font(.system(size: 16, weight: .semibold, design: .rounded))
    //                        Text(savingPlan.isArchived ? "word_unarchive".localized : "word_archive".localized)
    //                            .font(Font.mediumText16())
    //                        Spacer()
    //                    }
    //                })
    //                .foregroundStyle(.white)
    //                .padding(8)
    //                .background(Color.blue)
    //                .cornerRadius(100)
    //                .shadow(color: .blue, radius: 6, x: 0, y: 2)
    //
    //                Button(action: { isDeleting.toggle() }, label: {
    //                    HStack {
    //                        Spacer()
    //                        Image(systemName: "trash.fill")
    //                            .font(.system(size: 16, weight: .semibold, design: .rounded))
    //                        Text("word_delete".localized)
    //                            .font(.semiBoldText16())
    //                        Spacer()
    //                    }
    //                })
    //                .foregroundStyle(.white)
    //                .padding(8)
    //                .background(Color.red)
    //                .cornerRadius(100)
    //                .shadow(color: .red, radius: 6, x: 0, y: 2)
    //            }
    //            .padding(.horizontal)
    //        }
    //    }
} // struct

// MARK: - Preview
#Preview {
    SavingsPlanDetailView(savingsPlan: .mockClassicSavingsPlan)
}
