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

    //Custom type
    @Binding var account: Account?
    
    //Environnements
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) private var viewContext

    //State or Binding String
    @State private var accountTitle: String = ""
    @State private var textFieldEmptyString: String = ""

    //State or Binding Int, Float and Double
    @State private var accountBalance: Double = 0.0
    @State private var actualPage: Int = 1
    @State private var cardLimit: Double = 0.0
    @State private var textFieldEmptyDouble: Double = 0.0

    //State or Binding Bool

	//Enum
	
	//Computed var
    var numberFormatter: NumberFormatter {
        let numFor = NumberFormatter()
        numFor.numberStyle = .decimal
        numFor.zeroSymbol = ""
        return numFor
    }
    
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
                //1
                onboardingPage(
                    image: "TutorialPage1",
                    title: NSLocalizedString("onboarding_page1_title", comment: ""),
                    desc: NSLocalizedString("onboarding_page1_desc", comment: "")
                ).tag(1)
                
                //2
                onboardingPage(
                    image: "TutorialPage2",
                    title: NSLocalizedString("onboarding_page2_title", comment: ""),
                    desc: NSLocalizedString("onboarding_page2_desc", comment: "")
                ).tag(2)
                
                //3
                onboardingPage(
                    image: "TutorialPage3",
                    title: NSLocalizedString("onboarding_page3_title", comment: ""),
                    desc: NSLocalizedString("onboarding_page3_desc", comment: "")
                ).tag(3)
                
                //4
                onboardingPage(
                    image: "TutorialPage4",
                    title: NSLocalizedString("onboarding_page4_title", comment: ""),
                    desc: NSLocalizedString("onboarding_page4_desc", comment: "")
                ).tag(4)
                
                addAccountPage().tag(5)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            Button(action: {
                if actualPage < 5 {
                    withAnimation { actualPage += 1 }
                } else {
                    UserDefaults.standard.set(true, forKey: "alreadyOpen")
                    DispatchQueue.main.async {
                        let firstTransaction = Transaction(context: viewContext)
                        firstTransaction.id = UUID()
                        firstTransaction.title = NSLocalizedString("name_first_transaction", comment: "")
                        firstTransaction.amount = accountBalance
                        firstTransaction.date = .now
                        
                        let firstAccount = Account(context: viewContext)
                        firstAccount.id = UUID()
                        firstAccount.title = accountTitle
                        firstAccount.balance = accountBalance
                        firstAccount.cardLimit = cardLimit
                        firstAccount.accountToTransaction?.insert(firstTransaction)
                        
                        account = firstAccount
                        
                        persistenceController.saveContext()
                    }
                    
                    dismiss()
                }
            }, label: {
                Capsule()
                    .foregroundColor(.primary400)
                    .frame(height: 60)
                    .overlay {
                        Text(actualPage == 5 ? NSLocalizedString("onboarding_button_start", comment: "") : NSLocalizedString("onboarding_button_next", comment: ""))
                            .font(.semiBoldCustom(size: 22))
                            .foregroundColor(.primary0)
                    }
                    .padding()
                    .padding(.horizontal)
            })
            .disabled(!validateNewAccount())
            .opacity(validateNewAccount() ? 1 : 0.5)
        }
        .ignoresSafeArea(.keyboard)
        .background(colorScheme == .light ? Color.primary0.edgesIgnoringSafeArea(.all) : Color.secondary500.edgesIgnoringSafeArea(.all))
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }//END body
    
    //MARK: - ViewBuilder
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
                        .foregroundColor(colorScheme == .light ? .primary0 : .secondary500)
                    
                    VStack(spacing: isLittleIphone ? 20 : 40) {
                        Text(title)
                            .font(.boldCustom(size: sizeTitleOnboarding))
                            .multilineTextAlignment(.center)
                            .foregroundColor(colorScheme == .light ? .secondary500 : .primary0)
                        
                        Text(desc)
                            .foregroundColor(.secondary400)
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
        VStack {
            Text(NSLocalizedString("account_new", comment: ""))
                .titleAdjustSize()
                .padding(.top)
            
            CellAddCardView(textHeader: NSLocalizedString("account_name", comment: ""),
                            placeholder: NSLocalizedString("account_placeholder_name", comment: ""),
                            text: $accountTitle,
                            value: $textFieldEmptyDouble,
                            isNumberTextField: false)
            .padding(8)
            
            CellAddCardView(textHeader: NSLocalizedString("account_balance", comment: ""),
                            placeholder: NSLocalizedString("account_placeholder_balance", comment: ""),
                            text: $textFieldEmptyString,
                            value: $accountBalance,
                            isNumberTextField: true)
            .padding(8)
            .padding(.vertical)
            
            CellAddCardView(textHeader: NSLocalizedString("account_card_limit", comment: ""),
                            placeholder: NSLocalizedString("account_placeholder_card_limit", comment: ""),
                            text: $textFieldEmptyString,
                            value: $cardLimit,
                            isNumberTextField: true)
            .padding(8)
            
            Text(NSLocalizedString("account_info_credit_card", comment: ""))
                .foregroundColor(colorScheme == .dark ? .secondary300 : .secondary400)
                .multilineTextAlignment(.center)
                .font(.semiBoldText16())
                .padding()
            
            Spacer()
        }
    }

    //MARK: Fonctions
    func validateNewAccount() -> Bool {
        if actualPage == 5 {
            if !accountTitle.isEmpty && accountBalance != 0 {
                return true
            } else { return false }
        } else { return true }
    }

}//END struct

//MARK: - Preview
struct OnboardingView_Previews: PreviewProvider {
    
    @State static var previewAccount: Account? = previewAccount1()
    
    static var previews: some View {
        OnboardingView(account: $previewAccount)
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
