//
//  SettingsCreditsView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/02/2024.
//

import SwiftUI

struct SettingsCreditsView: View {
    
    // Environment
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - body
    var body: some View {
        ScrollView {
            
            // Founder
            VStack(spacing: 4) {
                titleForCellCredit(text: "setting_credits_founder".localized)
                VStack(spacing: 8) {
                    ForEach(founders) { people in
                        cellForCredit(people: people)
                    }
                }
            }
            .padding(.bottom)
            
            // Designer
            VStack(spacing: 4) {
                titleForCellCredit(text: "setting_credits_designer".localized)
                VStack(spacing: 8) {
                    ForEach(designers) { people in
                        cellForCredit(people: people)
                    }
                }
            }
            .padding(.bottom)
            
            // Beta Testeur
            VStack(spacing: 4) {
                titleForCellCredit(text: "setting_credits_beta_testeur".localized)
                VStack(spacing: 8) {
                    ForEach(betaTesteurs) { people in
                        cellForCredit(people: people)
                    }
                }
            }
            .padding(.bottom)
            
            // Translator
            VStack(spacing: 4) {
                titleForCellCredit(text: "setting_credits_translator".localized)
                VStack(spacing: 8) {
                    ForEach(translators) { people in
                        cellForCredit(people: people)
                    }
                }
            }
            .padding(.bottom)
            
            // Licenses
            VStack(spacing: 4) {
                titleForCellCredit(text: "setting_credits_licences".localized)
                NavigationLink(destination: {
                    List(allLicenses) { license in
                        Button(action: license.action, label: {
                            HStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.blue)
                                    .overlay {
                                        Image(systemName: license.icon)
                                            .font(.system(size: 14))
                                            .foregroundColor(.white)
                                    }
                                Text(license.name)
                                    .font(Font.mediumText16())
                                    .foregroundColor(.colorLabel)
                                Spacer()
                                Image(systemName: "arrow.up.forward")
                                    .foregroundColor(.secondary300)
                            }
                        })
                    }
                }, label: {
                    HStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.green.opacity(0.3))
                            .overlay {
                                Image(systemName: "doc.text.fill")
                                    .foregroundColor(.green)
                            }
                        VStack(alignment: .leading) {
                            Text("setting_credits_licences_title".localized)
                                .font(.semiBoldText18())
                                .foregroundColor(.colorLabel)
                            Text("setting_credits_licences_desc".localized)
                                .font(Font.mediumSmall())
                                .foregroundColor(.secondary300)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary300)
                    }
                    .padding(12)
                    .background(Color.colorCustomCell)
                    .cornerRadius(15)
                })
            }
            
        } // End ScrollView
        .scrollIndicators(.hidden)
        .padding(.horizontal)
        .navigationTitle("setting_credits_title".localized)
        .navigationBarTitleDisplayMode(.inline)
    } // End body
    
    // MARK: - ViewBuilder
    @ViewBuilder
    func cellForCredit(people: People) -> some View {
        Button(action: people.action, label: {
            HStack {
                Image(people.imageName)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                VStack(alignment: .leading) {
                    Text(people.name)
                        .font(.semiBoldText18())
                        .foregroundColor(.colorLabel)
                    Text(people.bio)
                        .font(Font.mediumSmall())
                        .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                }
                Spacer()
                Image(systemName: "arrow.up.forward")
                    .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
            }
            .padding(12)
            .padding(.horizontal, 4)
            .background(Color.colorCustomCell)
            .cornerRadius(15)
        })
    }
    
    @ViewBuilder
    func titleForCellCredit(text: String) -> some View {
        HStack {
            Text(text)
                .font(Font.mediumText16())
                .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
            Spacer()
        }
        .padding(.leading)
    }
} // End struct

// MARK: - Preview
#Preview {
    SettingsCreditsView()
}

// MARK: - People
struct People: Identifiable {
    var id: UUID = UUID()
    var name: String
    var bio: String
    var imageName: String
    var action: () -> Void
    var group: String
}

var allPeople: [People] = [
    // Founder
    People(
        name: "Théo Sementa",
        bio: "iOS Developer".localized,
        imageName: "theosementa",
        action:  URLManager.Setting.Credits.showTheoSementa,
        group: "founder"
    ),
    
    // Designer
    People(
        name: "Séréna De Araujo",
        bio: "Graphic Designer".localized,
        imageName: "serenadearaujo",
        action: URLManager.Setting.Credits.showSerenaDeAraujo,
        group: "designer"
    ),
    People(
        name: "Ryan Delépine",
        bio: "Graphic Designer".localized,
        imageName: "ryandelepine",
        action:  URLManager.Setting.Credits.showRyanDelepine,
        group: "designer"
    ),
    People(
        name: "Ali Husni Majid",
        bio: "Graphic Designer".localized,
        imageName: "alihusnimajid",
        action:  URLManager.Setting.Credits.showAliHusniMajid,
        group: "designer"
    ),
    
    // Beta Testeurs
    People(
        name: "Yves Charpentier",
        bio: "iOS Developer".localized,
        imageName: "yvescharpentier",
        action:  URLManager.Setting.Credits.showYvesCharpentier,
        group: "betatest"
    ),
    People(
        name: "Noémie Rosenkranz",
        bio: "Computer Science Student".localized,
        imageName: "noemierosenkranz",
        action:  URLManager.Setting.Credits.showNoemieRosenkranz,
        group: "betatest"
    ),
    People(
        name: "Juline Digne",
        bio: "Training Advisor".localized,
        imageName: "julinedigne",
        action:  URLManager.Setting.Credits.showJulineDigne,
        group: "betatest"
    ),
    People(
        name: "Théo Dahlem",
        bio: "UI/UX Designer".localized,
        imageName: "theodahlem",
        action:  URLManager.Setting.Credits.showTheoDahlem,
        group: "betatest"
    ),
    
    // Translator
    People(
        name: "ChatGPT",
        bio: "Artificial intelligence".localized,
        imageName: "chatgpt",
        action:  URLManager.Setting.Credits.showChatGPT,
        group: "translator"
    ),
    People(
        name: "DeepL",
        bio: "Translation software".localized,
        imageName: "deepL",
        action:  URLManager.Setting.Credits.showDeepl,
        group: "translator"
    )
]

var founders: [People] = allPeople.filter { $0.group == "founder" }
var designers: [People] = allPeople.filter { $0.group == "designer" }
var betaTesteurs: [People] = allPeople.filter { $0.group == "betatest" }
var translators: [People] = allPeople.filter { $0.group == "translator" }

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
        action:  URLManager.Setting.Credits.showSwipeActions,
        isEdit: true
    ),
    License(
        name: "SwiftUI Confetti",
        icon: "sparkles",
        action:  URLManager.Setting.Credits.showSwiftUIConfetti,
        isEdit: false
    ),
    License(
        name: "StorySet",
        icon: "photo.fill",
        action:  URLManager.Setting.Credits.showStorySet,
        isEdit: false
    )
]
