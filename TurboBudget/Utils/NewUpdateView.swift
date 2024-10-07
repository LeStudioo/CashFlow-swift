//
//  NewUpdateView.swift
//  CashFlow
//
//  Created by KaayZenn on 01/11/2023.
//

import SwiftUI

struct NewUpdateView: View {

    // Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss

    //MARK: - Body
    var body: some View {
        VStack {
            Text("v1.1")
                .font(.boldH1())
                .padding(.top)
            
            ScrollView(showsIndicators: false) {
                ForEach(features) { feat in
                    HStack {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(ThemeManager.theme.color)
                            .overlay {
                                Image(systemName: feat.icon)
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                            }
                            .padding(.trailing, 8)
                        VStack(alignment: .leading) {
                            Text(feat.title)
                                .font(.semiBoldCustom(size: 22))
                            Text(feat.desc)
                                .font(.semiBoldCustom(size: 14))
                                .foregroundStyle(colorScheme == .dark ? Color.secondary400 : Color.secondary300)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
            }
            
            VStack {
                Button(action: { dismiss() }, label: {
                    HStack {
                        Spacer()
                        Text("word_continue".localized)
                            .foregroundStyle(Color(uiColor: .label))
                            .font(.semiBoldText18())
                        Spacer()
                    }
                    .padding()
                    .background(ThemeManager.theme.color)
                    .cornerRadius(50)
                    .padding()
                })
            }
        }
    } // End body
} // End struct

//MARK: - Preview
#Preview {
    NewUpdateView()
}

// UserDefault
let udV1_1 = UserDefaults.standard.bool(forKey: "udV1_1")

struct NewFeature: Identifiable {
    var id: UUID = UUID()
    var icon: String
    var title: String
    var desc: String
}

//MARK: UPDATE v1.1
let firstFeat = NewFeature(icon: "barcode.viewfinder", title: "update_first_feat_title".localized, desc: "update_first_feat_desc".localized)
let secondFeat = NewFeature(icon: "ipad.landscape", title: "update_second_feat_title".localized, desc: "update_second_feat_desc".localized)
let thirdFeat = NewFeature(icon: "icloud.fill", title: "update_third_feat_title".localized, desc: "update_third_feat_desc".localized)
let fourthFeat = NewFeature(icon: "creditcard.viewfinder", title: "update_fourth_feat_title".localized, desc: "update_fourth_feat_desc".localized)
let fifthFeat = NewFeature(icon: "bolt.horizontal.fill", title: "update_fifth_feat_title".localized, desc: "update_fifth_feat_desc".localized)
let sixthFeat = NewFeature(icon: "sparkles", title: "update_sixth_feat_title".localized, desc: "update_sixth_feat_desc".localized)

let features = [firstFeat, sixthFeat, secondFeat, thirdFeat, fourthFeat, fifthFeat]
