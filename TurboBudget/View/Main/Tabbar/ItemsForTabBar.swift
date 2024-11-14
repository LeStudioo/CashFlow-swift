//
//  ItemsForTabBar.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

import SwiftUI

struct ItemsForTabBar: View {
    
    // Builder
    @Binding var selectedTab: Int
    @Binding var showMenu: Bool
    
    // Custom Type
    @ObservedObject var filter: Filter = sharedFilter
    
    // MARK: - body
    var body: some View {
        HStack(alignment: .center, spacing: 100) {
            HStack {
                VStack(spacing: 14) {
                    Image(systemName: "house\(selectedTab == 0 ? ".fill" : "")")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .frame(width: 20, height: 20)
                    
                    Text("word_home".localized)
                        .font(.semiBoldSmall())
                }
                .foregroundStyle(
                    selectedTab == 0
                    ? Color(uiColor: UIColor.label)
                    : Color.reversedCustomGray
                )
                .onTapGesture { selectedTab = 0; withAnimation { showMenu = false; filter.showMenu = false } }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 14) {
                    Image(systemName: "chart.bar\(selectedTab == 1 ? ".fill" : "")")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .frame(width: 20, height: 20)
                    
                    Text("word_analytic".localized)
                        .font(.semiBoldSmall())
                }
                .onTapGesture { selectedTab = 1; withAnimation { showMenu = false; filter.showMenu = false } }
                .foregroundStyle(
                    selectedTab == 1
                    ? Color(uiColor: UIColor.label)
                    : Color.reversedCustomGray
                )
                .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 16)
            .frame(height: 70)
            .frame(maxWidth: .infinity)
                        
            HStack {
                VStack(spacing: 14) {
                    Image(systemName: "creditcard\(selectedTab == 3 ? ".fill" : "")")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .frame(width: 20, height: 20)
                    
                    Text("word_account".localized)
                        .font(.semiBoldSmall())
                }
                .onTapGesture { selectedTab = 3; withAnimation { showMenu = false; filter.showMenu = false } }
                .foregroundStyle(
                    selectedTab == 3
                    ? Color(uiColor: UIColor.label)
                    : Color.reversedCustomGray
                )
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 14) {
                    Image(systemName: "rectangle.stack\(selectedTab == 4 ? ".fill" : "")")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .frame(width: 20, height: 20)
                    
                    Text("word_type".localized)
                        .font(.semiBoldSmall())
                }
                .onTapGesture { selectedTab = 4; withAnimation { showMenu = false; filter.showMenu = false } }
                .foregroundStyle(
                    selectedTab == 4
                    ? Color(uiColor: UIColor.label)
                    : Color.reversedCustomGray
                )
                .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 16)
            .frame(height: 70)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 4)
        .frame(height: 90)
        .frame(maxWidth: .infinity)
    } // End body
} // End struct
