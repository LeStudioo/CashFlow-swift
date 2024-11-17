//
//  SavingPlanDetailView.swift
//  CashFlow
//
//  Created by Théo Sementa on 09/07/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct SavingPlanDetailView: View {
    
    //Custom type
    @ObservedObject var savingsPlan: SavingsPlanModel
    
    // Environement
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: PurchasesManager
    
    @EnvironmentObject private var router: NavigationManager
    @EnvironmentObject private var savingsPlanRepository: SavingsPlanRepository
    @EnvironmentObject private var contributionRepository: ContributionRepository
    
    //State or Binding String
    @State private var savingPlanNote: String = ""
    @State private var newName: String = ""
    
    //State or Binding Int, Float and Double
    @State private var percentage: Double = 0
    @State private var increaseWidthAmount: Double = 0
    
    //State or Binding Bool
    @State private var isDeleting: Bool = false
    @State private var showAddContribution: Bool = false
    
    //Enum
    enum Field: CaseIterable {
        case note
    }
    @FocusState var focusedField: Field?
        
    //MARK: - Body
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
                            .foregroundStyle(ThemeManager.theme.color)
                            .shadow(color: ThemeManager.theme.color, radius: 4, y: 2)
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
            
            if let date = savingsPlan.endDate?.toDate() {
                let color: Color = (date < Date() && savingsPlan.currentAmount ?? 0 != savingsPlan.goalAmount ?? 0)
                ? Color.red
                : Color(uiColor: .label
                )
                CellForDetailSavingPlan(
                    leftText: "savingsplan_detail_end_date".localized,
                    rightText: date.formatted(date: .abbreviated, time: .omitted),
                    rightTextColor: color
                )
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
                Button(action: { showAddContribution.toggle() }, label: {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(uiColor: .label))
                })
            }
            .padding(.top)
            .padding(.horizontal, 12)
            
            ForEach(contributionRepository.contributions) { contribution in
                ContributionRow(contribution: contribution)
            }
            
            Spacer()
        } // ScrollView
        .scrollIndicators(.hidden)
        .onAppear {
            savingPlanNote = savingsPlan.note ?? ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring()) {
                    guard let currentAmount = savingsPlan.currentAmount else { return }
                    guard let goalAmount = savingsPlan.goalAmount else { return }
                    
                    if currentAmount / goalAmount > 0.98 { percentage = 0.98 } else {
                        percentage = currentAmount / goalAmount
                    }
                    increaseWidthAmount = 1.5
                }
            }
        }
        .onDisappear {
            // TODO: Update
            //            if savingPlanNote != savingPlan.note {
            //                savingsPlan.note = savingPlanNote
            //                persistenceController.saveContext()
            //            }
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
                        action: { showAddContribution.toggle() },
                        label: { Label("savingsplan_detail_add_contribution".localized, systemImage: "plus") }
                    )
                    
                    Button(
                        role: .destructive,
                        action: { isDeleting.toggle() },
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
                    Button(action: { focusedField = nil }, label: { Image(systemName: "keyboard.chevron.compact.down.fill").foregroundStyle(ThemeManager.theme.color) })
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showAddContribution, onDismiss: {
            guard let currentAmount = savingsPlan.currentAmount else { return }
            guard let goalAmount = savingsPlan.goalAmount else { return }
            
            withAnimation(.spring()) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if currentAmount / goalAmount > 0.98 { percentage = 0.98 } else {
                        percentage = currentAmount / goalAmount
                    }
                    increaseWidthAmount = 1.5
                }
            }
        }, content: { /*CreateContributionView(savingPlan: savingPlan)*/ })

        .alert("savingsplan_detail_delete_savingsplan".localized, isPresented: $isDeleting, actions: {
            Button(role: .cancel, action: { return }, label: { Text("word_cancel".localized) })
            Button(role: .destructive, action: {
                Task {
                    if let savingsPlanID = savingsPlan.id {
                        await savingsPlanRepository.deleteSavingsPlan(savingsPlanID: savingsPlanID)
                        dismiss()
                    }
                }
            }, label: { Text("word_delete".localized) })
        }, message: { Text("savingsplan_detail_delete_savingsplan_desc".localized) })
    } // body
    
    //MARK: - ViewBuilder
    @ViewBuilder
    func progressBar() -> some View {
        guard let currentAmount = savingsPlan.currentAmount else { return EmptyView() }
        guard let goalAmount = savingsPlan.goalAmount else { return EmptyView() }
        
        return VStack(spacing: 6) {
            HStack {
                Text(0.currency)
                Spacer()
                Text(goalAmount.currency)
            }
            .font(.semiBoldText16())
            .foregroundStyle(Color(uiColor: .label))
            
            GeometryReader { geometry in
                let widthAmount = currentAmount.currency
                    .widthOfString(usingFont: UIFont(name: nameFontSemiBold, size: 16)!) * increaseWidthAmount
                let widthPercentage = geometry.size.width * percentage
                
                Capsule()
                    
                    .foregroundStyle(.colorCell)
                    .overlay(alignment: .leading) {
                        ZStack(alignment: .leading) {
                            Capsule()
                                .foregroundStyle(ThemeManager.theme.color)
                                .frame(width: widthAmount > widthPercentage ? widthAmount + 8 : widthPercentage)
                            
                            Text(currentAmount.currency)
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
    SavingPlanDetailView(savingsPlan: .mockClassicSavingsPlan)
}

private struct CellForDetailSavingPlan: View {
    
    var leftText: String
    var rightText: String
    var rightTextColor: Color
    
    var body: some View {
        HStack {
            Text(leftText)
                .font(Font.mediumText16())
            Spacer()
            Text(rightText)
                .font(.semiBoldText16())
                .foregroundStyle(rightTextColor)
        }
        .padding(12)
        .background(Color.colorCell)
        .cornerRadius(15)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}


