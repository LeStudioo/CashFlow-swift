//
//  SettingCreditsView.swift
//  CashFlow
//
//  Created by KaayZenn on 13/08/2023.
//
// Localizations 01/10/2023

import Foundation
import SwiftUI
import Setting

struct People: Identifiable {
    var id: UUID = UUID()
    var name: String
    var bio: String
    var imageName: String
    var link: URL?
    var group: String
}

struct License: Identifiable {
    var id: UUID = UUID()
    var name: String
    var icon: String
    var link: URL?
    var isEdit: Bool
}

var allPeople: [People] = [
    People(
        name: "Théo Sementa",
        bio: NSLocalizedString("iOS Developer", comment: ""),
        imageName: "theosementa",
        link: URL(string: "https://x.com/theosementa?s=21&t=mHfvIyj-lTkunAAdI8h8Ww"),
        group: "founder"
    ),
    
    //Designer
    People(
        name: "Séréna De Araujo",
        bio: NSLocalizedString("Graphic Designer", comment: ""),
        imageName: "serenadearaujo",
        link: URL(string: "https://instagram.com/widesign._x?igshid=MzRlODBiNWFlZA=="),
        group: "designer"
    ),
    People(
        name: "Ryan Delépine",
        bio: NSLocalizedString("Graphic Designer", comment: ""),
        imageName: "ryandelepine",
        link: URL(string: "https://x.com/ryan_ssc?s=21&t=mHfvIyj-lTkunAAdI8h8Ww"),
        group: "designer"
    ),
    People(
        name: "Ali Husni Majid",
        bio: NSLocalizedString("Graphic Designer", comment: ""),
        imageName: "alihusnimajid",
        link: URL(string: "https://www.linkedin.com/in/alihusnimajid/"),
        group: "designer"
    ),
    
    //Beta Testeurs
    People(
        name: "Yves Charpentier",
        bio: NSLocalizedString("iOS Developer", comment: ""),
        imageName: "yvescharpentier",
        link: URL(string: "https://apps.apple.com/fr/developer/yves-charpentier/id1654705165"),
        group: "betatest"
    ),
    People(
        name: "Noémie Rosenkranz",
        bio: NSLocalizedString("iOS Developer", comment: ""),
        imageName: "noemierosenkranz",
        link: URL(string: "https://fr.linkedin.com/in/noemie-rosenkranz-a109b3219"),
        group: "betatest"
    ),
    People(
        name: "Juline Digne",
        bio: NSLocalizedString("Training Advisor", comment: ""),
        imageName: "julinedigne",
        link: URL(string: "https://www.linkedin.com/in/juline-digne/"),
        group: "betatest"
    ),
    People(
        name: "Théo Dahlem",
        bio: NSLocalizedString("UI/UX Designer", comment: ""),
        imageName: "theodahlem",
        link: URL(string: "http://portfolio-td.framer.website"),
        group: "betatest"
    ),
    
    //Translator
    People(
        name: "ChatGPT",
        bio: NSLocalizedString("Artificial intelligence", comment: ""),
        imageName: "chatgpt",
        link: URL(string: "https://chat.openai.com/"),
        group: "translator"
    ),
    People(
        name: "DeepL",
        bio: NSLocalizedString("Translation software", comment: ""),
        imageName: "deepL",
        link: URL(string: "https://www.deepl.com/translator"),
        group: "translator"
    )
]

var founders: [People] = allPeople.filter { $0.group == "founder" }
var designers: [People] = allPeople.filter { $0.group == "designer" }
var betaTesteurs: [People] = allPeople.filter { $0.group == "betatest" }
var translators: [People] = allPeople.filter { $0.group == "translator" }

var allLicenses: [License] = [
    License(
        name: "Swipe Actions",
        icon: "arrow.left.arrow.right",
        link: URL(string: "https://github.com/aheze/SwipeActions"),
        isEdit: true
    ),
    License(
        name: "Setting",
        icon: "gearshape.fill",
        link: URL(string: "https://github.com/aheze/Setting"),
        isEdit: true
    ),
    License(
        name: "SwiftUI Confetti",
        icon: "sparkles",
        link: URL(string: "https://github.com/simibac/ConfettiSwiftUI"),
        isEdit: false
    ),
    License(
        name: "StorySet",
        icon: "photo.fill",
        link: URL(string: "https://storyset.com/"),
        isEdit: false
    )
]

func settingCreditsView(isDarkMode: Binding<Bool>) -> SettingPage {
    
    @State var isDarkMode: Bool = isDarkMode.wrappedValue
    
    @ViewBuilder
    func cellForCredit(people: People) -> some View {
        Button(action: {
            if let url = people.link { if UIApplication.shared.canOpenURL(url) { UIApplication.shared.open(url) } }
        }, label: {
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
                        .foregroundColor(isDarkMode ? .secondary300 : .secondary400)
                }
                Spacer()
                Image(systemName: "arrow.up.forward")
                    .foregroundColor(isDarkMode ? .secondary300 : .secondary400)
            }
            .padding(12)
            .background(Color.colorCustomCell)
            .cornerRadius(15)
            .padding(.horizontal)
        })
    }
    
    @ViewBuilder
    func titleForCellCredit(text: String) -> some View {
        HStack {
            Text(text)
                .font(Font.mediumText16())
                .foregroundColor(isDarkMode ? .secondary300 : .secondary400)
            Spacer()
        }
        .padding(.horizontal).padding(.leading)
    }

    return SettingPage(title: NSLocalizedString("setting_credits_title", comment: "")) {
        
        SettingCustomView {
            VStack(spacing: 2) { // Founder
                titleForCellCredit(text: NSLocalizedString("setting_credits_founder", comment: ""))
                ForEach(founders) { people in
                    cellForCredit(people: people)
                        .padding(.bottom, 6)
                }
            }
            
            VStack(spacing: 2) { // Designer
                titleForCellCredit(text: NSLocalizedString("setting_credits_designer", comment: ""))
                ForEach(designers) { people in
                    cellForCredit(people: people)
                        .padding(.bottom, 6)
                }
            }
            
            VStack(spacing: 2) { // Beta Testeur
                titleForCellCredit(text: NSLocalizedString("setting_credits_beta_testeur", comment: ""))
                ForEach(betaTesteurs) { people in
                    cellForCredit(people: people)
                        .padding(.bottom, 6)
                }
            }
            
            VStack(spacing: 2) { // Translator
                titleForCellCredit(text: NSLocalizedString("setting_credits_translator", comment: ""))
                ForEach(translators) { people in
                    cellForCredit(people: people)
                        .padding(.bottom, 6)
                }
            }
            
            VStack(spacing: 2) { // Licenses
                titleForCellCredit(text: NSLocalizedString("setting_credits_licences", comment: ""))
                NavigationLink(destination: {
                    List(allLicenses) { license in
                        Button(action: {
                            if let url = license.link { if UIApplication.shared.canOpenURL(url) { UIApplication.shared.open(url) } }
                        }, label: {
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
                            Text(NSLocalizedString("setting_credits_licences_title", comment: ""))
                                .font(.semiBoldText18())
                                .foregroundColor(.colorLabel)
                            Text(NSLocalizedString("setting_credits_licences_desc", comment: ""))
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
                    .padding(.horizontal)
                })
            }
        } // END CustomView
        
//            SettingGroup(header: NSLocalizedString("MARKETING", comment: "")) {
//                SettingButton(title: "Léa Morel", action: {
//                    let url = URL(string: "https://www.linkedin.com/in/l%C3%A9a-morel-aa2465240")!
//                    if UIApplication.shared.canOpenURL(url) { UIApplication.shared.open(url) }
//                })
//                .icon("person.wave.2.fill", foregroundColor: .white, backgroundColor: Color(hex: 0xFF26BA))
//            }
        
    } // END Page
    .previewIcon("person.fill", backgroundColor: .indigo)
}
