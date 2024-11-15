//
//  OnboardingView.swift
//  CashFlow
//
//  Created by KaayZenn on 10/09/2023.
//
// Localizations 30/09/2023

import SwiftUI
import CloudKit

struct OnboardingView: View {
    
    //Environnements
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    // Repo
    @EnvironmentObject private var accountRepo: AccountRepositoryOld

    //State or Binding String
    @State private var accountTitle: String = ""
    @State private var textFieldEmptyString: String = ""

    //State or Binding Int, Float and Double
    @State private var accountBalance: String = ""
    @State private var actualPage: Int = 1
    @State private var cardLimit: Double = 0.0
    @State private var textFieldEmptyDouble: Double = 0.0
	
	// Computed var
    var sizeTitleOnboarding: CGFloat {
        if isLittleIphone {
            return 26
        } else if isIPad {
            return 30
        } else { return 28 }
    }

    var sizeDescOnboarding: CGFloat {
        if isLittleIphone {
            return 16
        } else if isIPad {
            return 20
        } else { return 18 }
    }

    //MARK: - Body
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $actualPage) {
                onboardingPage(
                    image: "TutorialPage1",
                    title: "onboarding_page1_title".localized,
                    desc: "onboarding_page1_desc".localized
                ).tag(1)
                
                onboardingPage(
                    image: "TutorialPage2",
                    title: "onboarding_page2_title".localized,
                    desc: "onboarding_page2_desc".localized
                ).tag(2)
                
                onboardingPage(
                    image: "TutorialPage3",
                    title: "onboarding_page3_title".localized,
                    desc: "onboarding_page3_desc".localized
                ).tag(3)
                
                onboardingPage(
                    image: "TutorialPage4",
                    title: "onboarding_page4_title".localized,
                    desc: "onboarding_page4_desc".localized
                ).tag(4)
                
                addAccountPage()
                    .tag(5)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            Button(action: {
                if actualPage < 5 {
                    withAnimation { actualPage += 1 }
                } else {
                    UserDefaults.standard.set(true, forKey: "alreadyOpen")
                    DispatchQueue.main.async {
                        let firstTransaction = TransactionEntity(context: viewContext)
                        firstTransaction.id = UUID()
                        firstTransaction.title = "name_first_transaction".localized
                        firstTransaction.amount = accountBalance.toDouble()
                        firstTransaction.date = .now
                        
                        let firstAccount = Account(context: viewContext)
                        firstAccount.id = UUID()
                        firstAccount.title = accountTitle
                        firstAccount.balance = accountBalance.toDouble()
                        firstAccount.cardLimit = cardLimit
                        firstAccount.accountToTransaction?.insert(firstTransaction)
                        
                        accountRepo.mainAccount = firstAccount
                        
                        persistenceController.saveContext()
                    }
                    
                    dismiss()
                }
            }, label: {
                Capsule()
                    .foregroundStyle(.primary400)
                    .frame(height: 60)
                    .overlay {
                        Text(actualPage == 5 ? "onboarding_button_start".localized : "onboarding_button_next".localized)
                            .font(.semiBoldCustom(size: 22))
                            .foregroundStyle(.primary0)
                    }
                    .padding()
                    .padding(.horizontal)
            })
            .disabled(!validateNewAccount())
            .opacity(validateNewAccount() ? 1 : 0.5)
        }
        .background(colorScheme == .light ? Color.primary0.edgesIgnoringSafeArea(.all) : Color.secondary500.edgesIgnoringSafeArea(.all))
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    } // End body
    
    // MARK: - ViewBuilder
    @ViewBuilder
    func onboardingPage(image: String, title: String, desc: String) -> some View {
        ZStack(alignment: .bottom) {
            VStack {
                Spacer()
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 60)
                Spacer()
                Spacer()
            }
            
            VStack {
                Spacer()
                ZStack(alignment: .top) {
                    CustomShapeOnboarding()
                        .frame(height: UIScreen.main.bounds.height / 2 - 30)
                        .foregroundStyle(colorScheme == .light ? .primary0 : .secondary500)
                    
                    VStack(spacing: isLittleIphone ? 20 : 40) {
                        Text(title)
                            .font(.boldCustom(size: sizeTitleOnboarding))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color(uiColor: .label))
                        
                        Text(desc)
                            .foregroundStyle(.secondary400)
                            .font(.mediumCustom(size: sizeDescOnboarding))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 70)
                    .padding(.horizontal)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(Gradient(colors: [.primary600, .primary800]))
    }
    
    @ViewBuilder
    func addAccountPage() -> some View {
        VStack(spacing: 32) {
            Text("account_new".localized)
                .titleAdjustSize()
                .padding(.top)
            
                VStack(spacing: 24) {
                    CustomTextField(
                        text: $accountTitle,
                        config: .init(
                            title: "account_name".localized,
                            placeholder: "account_placeholder_name".localized
                        )
                    )
                    
                    CustomTextField(
                        text: $accountBalance,
                        config: .init(
                            title: "account_balance".localized,
                            placeholder: "account_placeholder_balance".localized,
                            style: .amount
                        )
                    )
                }
                
                Text("account_info_credit_card".localized)
                    .foregroundStyle(colorScheme == .dark ? .secondary300 : .secondary400)
                    .multilineTextAlignment(.center)
                    .font(.semiBoldText16())
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }

    // MARK: Fonctions
    func validateNewAccount() -> Bool {
        if actualPage == 5 {
            if !accountTitle.isEmpty && !accountBalance.isEmpty {
                return true
            } else { return false }
        } else { return true }
    }

} // End struct

//MARK: - Preview
struct OnboardingView_Previews: PreviewProvider {
    
    @State static var previewAccount: Account? = Account.preview
    
    static var previews: some View {
        OnboardingView()
    }
}

//MARK: - Extra
private struct CustomShapeOnboarding: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: .zero)
            
            path.addCurve(to: CGPoint(x: UIScreen.main.bounds.width, y: 0),
                                      control1: CGPoint(x: 100, y: 40),
                                      control2: CGPoint(x: UIScreen.main.bounds.width - 100, y: 40))
            
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 0))
            
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height / 2 - 30))
            path.addLine(to: CGPoint(x: 0, y: UIScreen.main.bounds.height / 2 - 30))
            
            path.closeSubpath()
        }
    }
}
