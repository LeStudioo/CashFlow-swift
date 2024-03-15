//
//  FilterView.swift
//  CashFlow
//
//  Created by KaayZenn on 10/08/2023.
//
// Localizations 01/10/2023

import SwiftUI

struct FilterView: View {

    //Custom type
    @ObservedObject var filter: Filter = sharedFilter

    //Environnements
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var store: Store

    //State or Binding String

    //State or Binding Int, Float and Double

    //State or Binding Bool
    var isWhatCategory: Bool?
    @Binding var showAlertPaywall: Bool
    @Binding var update: Bool

	//Enum
	
	//Computed var
    var noCategory: Bool {
        if filter.fromAnalytics || filter.fromBudget { return true } else { return false}
    }

    //MARK: - Body
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        filter.showMenu.toggle()
                        if filter.fromBudget { filter.fromBudget = false }
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color(uiColor: .label))
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                })
            }
            .if(!(isWhatCategory ?? false)) { view in
                view
                    .padding(.top).padding(.top)
            }
            .padding([.top, .trailing], 16)
            
            VStack {
                YearMonthPickerView(update: $update)
                    .disabled(filter.total)
                    .opacity(filter.total ? 0.5 : 1)
                if !filter.fromBudget && !filter.fromAnalytics {
                    Spacer()
                    
                    Toggle(isOn: $filter.byDay.animation(), label: {
                        Text("filter_by_day".localized)
                    })
                    .disabled(filter.total)
                    .padding(8)
                    .padding(.horizontal, 8)
                    .background(Color.background)
                    .cornerRadius(15)
                    .padding(8)
                    .if(!store.isLifetimeActive) { view in
                        view
                            .opacity(0.5)
                            .disabled(true)
                            .overlay { Image(systemName: "lock.fill") }
                            .onTapGesture { showAlertPaywall.toggle() }
                    }
                    
                    Toggle(isOn: $filter.automation.animation(), label: {
                        Text("filter_only_auto".localized)
                    })
                    .padding(8)
                    .padding(.horizontal, 8)
                    .background(Color.background)
                    .cornerRadius(15)
                    .padding(.horizontal, 8)
                    
                    Toggle(isOn: $filter.total.animation(), label: {
                        Text("filter_total".localized)
                    })
                    .padding(8)
                    .padding(.horizontal, 8)
                    .background(Color.background)
                    .cornerRadius(15)
                    .padding(8)
                }
            }
        }
//        .frame(height: !filter.fromBudget ? UIScreen.main.bounds.height / 2 : UIScreen.main.bounds.height / 3 )
        .frame(height: noCategory ? 300 : 500)
        .background(colorScheme == .light ? Color.primary0 : Color.secondary500)
        .cornerRadius(15, corners: .bottomLeft)
        .cornerRadius(15, corners: .bottomRight)
        .shadow(radius: 4, y: 4)
        .onChange(of: filter.fromBudget) { newValue in
            if newValue { filter.byDay = false }
        }
        .onChange(of: filter.fromAnalytics) { newValue in
            if newValue { filter.byDay = false }
        }
    }//END body

    //MARK: Fonctions

}//END struct

//MARK: - Preview
struct FilterView_Previews: PreviewProvider {
    
    @State static var update: Bool = false
    
    static var previews: some View {
        FilterView(showAlertPaywall: $update, update: $update)
    }
}
