//
//  SettingsCreditsView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/02/2024.
//

import SwiftUI
import CoreModule

struct SettingsCreditsView: View {
    
    // MARK: -
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                titleForCellCredit(text: Word.Setting.Credits.founders)
                ForEach(People.founders) { people in
                    PeopleRow(people: people)
                }
            }
            .padding(.bottom)
            
            VStack(spacing: 8) {
                titleForCellCredit(text: Word.Setting.Credits.designers)
                ForEach(People.designersWithoutTheo) { people in
                    PeopleRow(people: people)
                }
            }
            .padding(.bottom)
            
            // Licenses
            VStack(spacing: 8) {
                titleForCellCredit(text: Word.Setting.Credits.licences)
                NavigationLink(destination: {
                    List(allLicenses) { license in
                        Button(action: license.action, label: {
                            HStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.blue)
                                    .overlay {
                                        Image(systemName: license.icon)
                                            .font(.system(size: 14))
                                            .foregroundStyle(.white)
                                    }
                                Text(license.name)
                                    .font(Font.mediumText16())
                                    .foregroundStyle(Color.text)
                                Spacer()
                                Image(systemName: "arrow.up.forward")
                                    .foregroundStyle(.secondary300)
                            }
                        })
                    }
                }, label: {
                    LicenseRow()
                })
            }
        } // End ScrollView
        .padding(.horizontal)
        .scrollIndicators(.hidden)
        .background(Color.background)
        .navigationTitle(Word.Title.Setting.credits)
        .navigationBarTitleDisplayMode(.inline)
    } // End body
    
    // MARK: - ViewBuilder
    @ViewBuilder
    func titleForCellCredit(text: String) -> some View {
        HStack {
            Text(text)
                .font(Font.mediumText16())
                .foregroundStyle(Color.customGray)
            Spacer()
        }
        .padding(.leading)
    }
} // End struct

// MARK: - Preview
#Preview {
    SettingsCreditsView()
}

// MARK: - License
struct License: Identifiable {
    var id: UUID = UUID()
    var name: String
    var icon: String
    var action: () -> Void
    var isEdit: Bool
}

var allLicenses: [License] = [
    License(
        name: "Swipe Actions",
        icon: "arrow.left.arrow.right",
        action: URLManager.Setting.Credits.showSwipeActions,
        isEdit: true
    ),
    License(
        name: "SwiftUI Confetti",
        icon: "sparkles",
        action: URLManager.Setting.Credits.showSwiftUIConfetti,
        isEdit: false
    ),
    License(
        name: "StorySet",
        icon: "photo.fill",
        action: URLManager.Setting.Credits.showStorySet,
        isEdit: false
    )
]
