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
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    
    //Environnements
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss

    //State or Binding String
    @State private var savingPlanNote: String = ""
    @State private var newName: String = ""

    //State or Binding Int, Float and Double
    @State private var percentage: Double = 0
    @State private var increaseWidthAmount: Double = 0
    @State private var stepSelection: Int = 1

    //State or Binding Bool
    @Binding var update: Bool
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
    
    //Other
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    //MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                Spacer()
                Circle()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.colorCell)
                    .overlay {
                        Circle()
                            .frame(width: 80, height: 80)
                            .foregroundColor(HelperManager().getAppTheme().color)
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
                                            .foregroundColor(colorScheme == .light ? .secondary500 : .primary0)
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
                let color: Color = (date < Date() && savingPlan.actualAmount != savingPlan.amountOfEnd) ? Color.red : Color.colorLabel
                CellForDetailSavingPlan(leftText: NSLocalizedString("savingsplan_detail_end_date", comment: ""), rightText: date.formatted(date: .abbreviated, time: .omitted), rightTextColor: color)
            }
            
            HStack {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $savingPlanNote)
                        .focused($focusedField, equals: .note)
                        .scrollContentBackground(.hidden)
                        .font(Font.mediumText16())
                    
                    if savingPlanNote.isEmpty {
                        HStack {
                            Text(NSLocalizedString("savingsplan_detail_note", comment: ""))
                                .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
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
            
            archivedOrDeleteButton()
            
            HStack {
                Text(NSLocalizedString("word_contributions", comment: ""))
                    .font(.semiBoldCustom(size: 22))
                Spacer()
                Button(action: { showAddContribution.toggle() }, label: {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .medium, design: .rounded))
                        .foregroundColor(.colorLabel)
                })
            }
            .padding(.top)
            .padding(.horizontal, 12)
            
            ForEach(savingPlan.contributions) { contribution in
                CellContributionView(contribution: contribution, update: $update)
            }
            
            Spacer()
        }
        .padding(update ? 0 : 0)
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
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.colorLabel)
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu(content: {
                    Button(action: { isRenaming.toggle() }, label: { Label(NSLocalizedString("word_rename", comment: ""), systemImage: "pencil") })
                    
                    Button(action: {
                        withAnimation {
                            savingPlan.isStepEnable.toggle()
                            persistenceController.saveContext()
                            update.toggle()
                        }
                    }, label: { 
                        Label(savingPlan.isStepEnable 
                              ? NSLocalizedString("savingsplan_detail_disable_steps", comment: "")
                              : NSLocalizedString("savingsplan_detail_enable_steps", comment: ""),
                              systemImage: "chart.line.uptrend.xyaxis")
                    })
                    .disabled(!userDefaultsManager.isCashFlowProEnable)
                    
                    Button(action: { showAddContribution.toggle() }, label: { Label(NSLocalizedString("savingsplan_detail_add_contribution", comment: ""), systemImage: "plus") })
                    
                    Button(role: .destructive, action: { isDeleting.toggle() }, label: { Label(NSLocalizedString("word_delete", comment: ""), systemImage: "trash.fill") })
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.colorLabel)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                })
            }
            
            ToolbarItem(placement: .keyboard) {
                HStack {
                    EmptyView()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(action: { focusedField = nil }, label: { Image(systemName: "keyboard.chevron.compact.down.fill").foregroundColor(HelperManager().getAppTheme().color) })
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .background(Color.colorBackground.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showAddContribution, onDismiss: {
            withAnimation(.spring()) {
                update.toggle()
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
        }, content: { AddContributionView(savingPlan: savingPlan) })
        .alert(NSLocalizedString("word_rename", comment: ""), isPresented: $isRenaming, actions: {
            TextField(NSLocalizedString("word_new_name", comment: ""), text: $newName)
            Button(role: .cancel, action: { return }, label: { Text(NSLocalizedString("word_cancel", comment: "")) })
            Button(action: {
                savingPlan.title = newName
                persistenceController.saveContext()
                update.toggle()
            }, label: { Text(NSLocalizedString("word_rename", comment: "")) })
        })
        .alert(NSLocalizedString("savingsplan_detail_delete_savingsplan", comment: ""), isPresented: $isDeleting, actions: {
            Button(role: .cancel, action: { return }, label: { Text(NSLocalizedString("word_cancel", comment: "")) })
            Button(role: .destructive, action: {
                DispatchQueue.main.async {
                    withAnimation {
                        viewContext.delete(savingPlan)
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            persistenceController.saveContext()
                        }
                    }
                }
            }, label: { Text(NSLocalizedString("word_delete", comment: "")) })
        }, message: { Text(NSLocalizedString("savingsplan_detail_delete_savingsplan_desc", comment: "")) })
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
                        .foregroundColor(.colorLabel)
                    } else {
                        HStack {
                            Text(0.currency)
                            Spacer()
                            Text(savingPlan.amountOfEnd.currency)
                        }
                        .font(.semiBoldText16())
                        .foregroundColor(.colorLabel)
                    }
                    
                    let widthAmount = savingPlan.actualAmount.currency.widthOfString(usingFont: UIFont(name: nameFontSemiBold, size: 16)!) * increaseWidthAmount
                    
                    Capsule()
                        .frame(height: 40)
                        .foregroundColor(.colorCell)
                        .overlay(alignment: .leading) {
                            Capsule()
                                .foregroundColor(HelperManager().getAppTheme().color)
                                .frame(width: widthCapsule(widthBar: geometry.size.width) < widthAmount ? widthAmount : widthCapsule(widthBar: geometry.size.width))
                                .padding(4)
                                .overlay(alignment: .trailing) {
                                    Text(savingPlan.actualAmount.currency)
                                        .padding(.trailing, 12)
                                        .font(.semiBoldText16())
                                        .foregroundColor(.colorLabelInverse)
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
                Text(stepSelection != 5 ? NSLocalizedString("savingsplan_detail_step", comment: "") + " " + String(stepSelection) : NSLocalizedString("savingsplan_detail_total", comment: ""))
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
                                        .foregroundColor(colorScheme == .light ? .secondary500 : .primary0)
                                }
                            }
                        }
                    }
                    .frame(width: 15, height: 15)
                    .padding(4)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            stepSelection = num
                            if userDefaultsManager.hapticFeedback { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                        }
                        if userDefaultsManager.hapticFeedback { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
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
        .foregroundColor(.colorLabel)
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
                        Text(savingPlan.isArchived ? NSLocalizedString("word_unarchive", comment: "") : NSLocalizedString("word_archive", comment: ""))
                            .font(Font.mediumText16())
                        Spacer()
                    }
                })
                .foregroundColor(.white)
                .padding(8)
                .background(Color.blue)
                .cornerRadius(100)
                .shadow(color: .blue, radius: 6, x: 0, y: 2)
                
                Button(action: { isDeleting.toggle() }, label: {
                    HStack {
                        Spacer()
                        Image(systemName: "trash.fill")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                        Text(NSLocalizedString("word_delete", comment: ""))
                            .font(.semiBoldText16())
                        Spacer()
                    }
                })
                .foregroundColor(.white)
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
struct SavingPlanDetailView_Previews: PreviewProvider {
    
    @State static var preveiwUpdate: Bool = false
    
    static var previews: some View {
        SavingPlanDetailView(savingPlan: previewSavingPlan1(), update: $preveiwUpdate)
    }
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
                .foregroundColor(rightTextColor)
        }
        .padding(12)
        .background(Color.colorCell)
        .cornerRadius(15)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}


