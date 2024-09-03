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
    var savingPlan: SavingPlan
    
    // Environement
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: PurchasesManager
    @EnvironmentObject private var savingPlanRepo: SavingPlanRepository

    //State or Binding String
    @State private var savingPlanNote: String = ""
    @State private var newName: String = ""

    //State or Binding Int, Float and Double
    @State private var percentage: Double = 0
    @State private var increaseWidthAmount: Double = 0
    @State private var stepSelection: Int = 1

    //State or Binding Bool
    @State private var isDeleting: Bool = false
    @State private var isRenaming: Bool = false
    @State private var showAddContribution: Bool = false
    @State private var showAddStep: Bool = false

	//Enum
    enum Field: CaseIterable {
        case note
    }
    @FocusState var focusedField: Field?
	
	//Computed var
    
    //MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                Spacer()
                Circle()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.colorCell)
                    .overlay {
                        Circle()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(HelperManager().getAppTheme().color)
                            .shadow(color: HelperManager().getAppTheme().color, radius: 4, y: 2)
                            .overlay {
                                VStack {
                                    if savingPlan.icon.count == 1 {
                                        Text(savingPlan.icon)
                                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                                            .shadow(radius: 2, y: 2)
                                    } else if savingPlan.icon.count != 0 && savingPlan.icon.count != 1 {
                                        Image(systemName: savingPlan.icon)
                                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                                            .foregroundStyle(Color(uiColor: .label))
                                            .shadow(radius: 2, y: 2)
                                    }
                                }
                            }
                    }
                Spacer()
            }
            
            Text(savingPlan.title)
                .titleAdjustSize()
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            VStack(spacing: 4) {
                progressBar()
                if savingPlan.isStepEnable { customSegmented() }
            }
            
            if let date = savingPlan.dateOfEnd {
                let color: Color = (date < Date() && savingPlan.actualAmount != savingPlan.amountOfEnd) ? Color.red : Color(uiColor: .label)
                CellForDetailSavingPlan(leftText: "savingsplan_detail_end_date".localized, rightText: date.formatted(date: .abbreviated, time: .omitted), rightTextColor: color)
            }
            
            HStack {
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
            
            ForEach(savingPlan.contributions) { contribution in
                ContributionRow(contribution: contribution)
            }
            
            Spacer()
        }
        .onAppear {
            savingPlanNote = savingPlan.note
            
            if savingPlan.isStepEnable {
                while (Int(percentageForStep().replacingOccurrences(of: "%", with: "")) ?? 0 == 100 ) { stepSelection += 1 }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring()) {
                    if savingPlan.actualAmount / savingPlan.amountOfEnd > 0.98 { percentage = 0.98 } else {
                        percentage = savingPlan.actualAmount / savingPlan.amountOfEnd
                    }
                    increaseWidthAmount = 1.5
                }
            }
        }
        .onDisappear {
            if savingPlanNote != savingPlan.note {
                savingPlan.note = savingPlanNote
                persistenceController.saveContext()
            }
        }
        .onChange(of: savingPlan.isStepEnable, perform: { newValue in
            if newValue {
                while (Int(percentageForStep().replacingOccurrences(of: "%", with: "")) ?? 0 == 100 ) { stepSelection += 1 }
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarDismissPushButton()
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu(content: {
                    Button(action: { isRenaming.toggle() }, label: { Label("word_rename".localized, systemImage: "pencil") })
                    
                    Button(action: {
                        withAnimation {
                            savingPlan.isStepEnable.toggle()
                            persistenceController.saveContext()
                        }
                    }, label: { 
                        Label(savingPlan.isStepEnable 
                              ? "savingsplan_detail_disable_steps".localized
                              : "savingsplan_detail_enable_steps".localized,
                              systemImage: "chart.line.uptrend.xyaxis")
                    })
                    .disabled(!store.isCashFlowPro)
                    
                    Button(action: { showAddContribution.toggle() }, label: { Label("savingsplan_detail_add_contribution".localized, systemImage: "plus") })
                    
                    Button(role: .destructive, action: { isDeleting.toggle() }, label: { Label("word_delete".localized, systemImage: "trash.fill") })
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
                    Button(action: { focusedField = nil }, label: { Image(systemName: "keyboard.chevron.compact.down.fill").foregroundStyle(HelperManager().getAppTheme().color) })
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showAddContribution, onDismiss: {
            withAnimation(.spring()) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if savingPlan.actualAmount == savingPlan.amountOfEnd {
                        savingPlan.dateOfEnd = Date()
                        persistenceController.saveContext()
                    } else {
                        savingPlan.dateOfEnd = nil
                        persistenceController.saveContext()
                    }
                    
                    if savingPlan.actualAmount / savingPlan.amountOfEnd > 0.98 { percentage = 0.98 } else {
                        percentage = savingPlan.actualAmount / savingPlan.amountOfEnd
                    }
                    increaseWidthAmount = 1.5
                }
            }
        }, content: { CreateContributionView(savingPlan: savingPlan) })
        .alert("word_rename".localized, isPresented: $isRenaming, actions: {
            TextField("word_new_name".localized, text: $newName)
            Button(role: .cancel, action: { return }, label: { Text("word_cancel".localized) })
            Button(action: {
                savingPlan.title = newName
                persistenceController.saveContext()
            }, label: { Text("word_rename".localized) })
        })
        .alert("savingsplan_detail_delete_savingsplan".localized, isPresented: $isDeleting, actions: {
            Button(role: .cancel, action: { return }, label: { Text("word_cancel".localized) })
            Button(role: .destructive, action: {
                savingPlanRepo.deleteSavingsPlan(savingsPlan: savingPlan)
                dismiss()
            }, label: { Text("word_delete".localized) })
        }, message: { Text("savingsplan_detail_delete_savingsplan_desc".localized) })
    }//END body
    
    //MARK: - ViewBuilder
    @ViewBuilder
    func progressBar() -> some View {
        
        let step1Goal = (savingPlan.amountOfEnd * 0.25)
        let step2Goal = (savingPlan.amountOfEnd * 0.50)
        let step3Goal = (savingPlan.amountOfEnd * 0.75)
        let step4Goal = savingPlan.amountOfEnd
        
        VStack {
            GeometryReader { geometry in
                VStack(spacing: 5) {
                    if savingPlan.isStepEnable {
                        HStack {
                            switch(stepSelection) {
                            case 1: Text(0.currency)
                            case 2: Text(step1Goal.currency)
                            case 3: Text(step2Goal.currency)
                            case 4: Text(step3Goal.currency)
                            case 5: Text(0.currency)
                            default: Text("Fail")
                            }
                            Spacer()
                            
                            switch(stepSelection) {
                            case 1: Text(step1Goal.currency)
                            case 2: Text(step2Goal.currency)
                            case 3: Text(step3Goal.currency)
                            case 4: Text(step4Goal.currency)
                            case 5: Text(step4Goal.currency)
                            default: Text("Fail")
                            }
                        }
                        .font(.semiBoldText16())
                        .foregroundStyle(Color(uiColor: .label))
                    } else {
                        HStack {
                            Text(0.currency)
                            Spacer()
                            Text(savingPlan.amountOfEnd.currency)
                        }
                        .font(.semiBoldText16())
                        .foregroundStyle(Color(uiColor: .label))
                    }
                    
                    let widthAmount = savingPlan.actualAmount.currency.widthOfString(usingFont: UIFont(name: nameFontSemiBold, size: 16)!) * increaseWidthAmount
                    
                    Capsule()
                        .frame(height: 40)
                        .foregroundStyle(.colorCell)
                        .overlay(alignment: .leading) {
                            Capsule()
                                .foregroundStyle(HelperManager().getAppTheme().color)
                                .frame(width: widthCapsule(widthBar: geometry.size.width) < widthAmount ? widthAmount : widthCapsule(widthBar: geometry.size.width))
                                .padding(4)
                                .overlay(alignment: .trailing) {
                                    Text(savingPlan.actualAmount.currency)
                                        .padding(.trailing, 12)
                                        .font(.semiBoldText16())
                                        .foregroundStyle(Color(uiColor: .systemBackground))
                                }
                        }
                }
            }
            .frame(height: 65)
        }
        .padding(.horizontal, 12)
    }
    
    @ViewBuilder
    func customSegmented() -> some View {
        HStack {
            HStack {
                Text(stepSelection != 5 ? "savingsplan_detail_step".localized + " " + String(stepSelection) : "savingsplan_detail_total".localized)
                Spacer()
                Text(percentageForStep())
            }
            .frame(height: 30)
            .padding(.horizontal, 8)
            .background(Color.colorCell)
            .cornerRadius(15)
            Spacer()
            HStack {
                ForEach(1..<6) { num in
                    VStack {
                        if num != 5 { Text(String(num)) } else {
                            VStack {
                                if savingPlan.icon.count == 1 {
                                    Text(savingPlan.icon)
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .adaptText()
                                } else if savingPlan.icon.count != 0 && savingPlan.icon.count != 1 {
                                    Image(systemName: savingPlan.icon)
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundStyle(Color(uiColor: .label))
                                }
                            }
                        }
                    }
                    .frame(width: 15, height: 15)
                    .padding(4)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            stepSelection = num
                        }
                        VibrationManager.vibration()
                    }
                    .if(stepSelection == num) { view in
                        view
                            .background(HelperManager().getAppTheme().color)
                            .clipShape(Circle())
                    }
                }
            }
            .frame(height: 30)
            .padding(.horizontal, 8)
            .background(Color.colorCell)
            .cornerRadius(15)
        }
        .padding(.horizontal, 12)
        .font(.semiBoldText16())
        .foregroundStyle(Color(uiColor: .label))
    }
    
    @ViewBuilder
    func archivedOrDeleteButton() -> some View {
        if savingPlan.actualAmount == savingPlan.amountOfEnd {
            HStack {
                Button(action: {
                    dismiss()
                    withAnimation {
                        if savingPlan.isArchived {
                            if savingPlan.dateOfEnd != nil { savingPlan.dateOfEnd = nil }
                            savingPlan.isArchived = false
                        } else {
                            if savingPlan.dateOfEnd == nil { savingPlan.dateOfEnd = Date() }
                            savingPlan.isArchived = true
                        }
                        persistenceController.saveContext()
                    }
                }, label: {
                    HStack {
                        Spacer()
                        Image(systemName: savingPlan.isArchived ? "tray.and.arrow.up.fill" : "tray.and.arrow.down.fill")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                        Text(savingPlan.isArchived ? "word_unarchive".localized : "word_archive".localized)
                            .font(Font.mediumText16())
                        Spacer()
                    }
                })
                .foregroundStyle(.white)
                .padding(8)
                .background(Color.blue)
                .cornerRadius(100)
                .shadow(color: .blue, radius: 6, x: 0, y: 2)
                
                Button(action: { isDeleting.toggle() }, label: {
                    HStack {
                        Spacer()
                        Image(systemName: "trash.fill")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                        Text("word_delete".localized)
                            .font(.semiBoldText16())
                        Spacer()
                    }
                })
                .foregroundStyle(.white)
                .padding(8)
                .background(Color.red)
                .cornerRadius(100)
                .shadow(color: .red, radius: 6, x: 0, y: 2)
            }
            .padding(.horizontal)
        }
    }
    
    //MARK: - Fonctions
    func widthCapsule(widthBar: CGFloat) -> Double {
        let step1Goal = (savingPlan.amountOfEnd * 0.25)
        let step2Goal = (savingPlan.amountOfEnd * 0.50)
        let step3Goal = (savingPlan.amountOfEnd * 0.75)
        let step4Goal = savingPlan.amountOfEnd
        
        var percentage: Double = 0
        var amountLeft: Double = 0
        var amountRight: Double = 0
        
        if stepSelection == 1 { amountLeft = 0; amountRight = step1Goal
        } else if stepSelection == 2 { amountLeft = step1Goal; amountRight = step2Goal
        } else if stepSelection == 3 { amountLeft = step2Goal; amountRight = step3Goal
        } else if stepSelection == 4 { amountLeft = step3Goal; amountRight = step4Goal
        } else if stepSelection == 5 { amountLeft = 0; amountRight = step4Goal; }
        
        withAnimation(.spring()) {
            if savingPlan.isStepEnable {
                if amountLeft < savingPlan.actualAmount {
                    if savingPlan.actualAmount / amountRight > 0.98 { percentage = 0.98 } else {
                        percentage = savingPlan.actualAmount / amountRight
                    }
                } else { percentage = 0 }
            } else {
                if savingPlan.actualAmount / savingPlan.amountOfEnd > 0.98 { percentage = 0.98 } else {
                    percentage = savingPlan.actualAmount / savingPlan.amountOfEnd
                }
            }
        }
        
        return widthBar * percentage
    }
    
    func percentageForStep() -> String {
        let step1Goal = (savingPlan.amountOfEnd * 0.25)
        let step2Goal = (savingPlan.amountOfEnd * 0.50)
        let step3Goal = (savingPlan.amountOfEnd * 0.75)
        let step4Goal = savingPlan.amountOfEnd
        
        var percentage: Double = 0
        var amountLeft: Double = 0
        var amountRight: Double = 0
        
        if stepSelection == 1 { amountLeft = 0; amountRight = step1Goal
        } else if stepSelection == 2 { amountLeft = step1Goal; amountRight = step2Goal
        } else if stepSelection == 3 { amountLeft = step2Goal; amountRight = step3Goal
        } else if stepSelection == 4 { amountLeft = step3Goal; amountRight = step4Goal
        } else if stepSelection == 5 { amountLeft = 0; amountRight = step4Goal; }
        
        withAnimation(.spring()) {
            if amountLeft < savingPlan.actualAmount {
                if savingPlan.actualAmount / amountRight > 0.98 { percentage = 1 } else {
                    percentage = savingPlan.actualAmount / amountRight
                }
            } else { percentage = 0 }
        }
        
        return String(format: "%.0f", percentage * 100) + "%"
    }
    
}//END struct

//MARK: - Preview
#Preview {
    SavingPlanDetailView(savingPlan: SavingPlan.preview1)
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


