//
//  TabbarView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
// Localizations 30/09/2023


import SwiftUI

struct TabbarView: View {
    
    // Builder
    var router: NavigationManager
    @Binding var account: Account?
    @Binding var selectedTab: Int
    @Binding var offsetYMenu: CGFloat
    
    // Custom type
    @ObservedObject var filter: Filter = sharedFilter
    @ObservedObject var viewModel = CustomTabBarViewModel.shared

    // Environement
    @Environment(\.colorScheme) private var colorScheme
    
    // Preferences
    @Preference(\.hapticFeedback) private var hapticFeedback

    //MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            BannerShape()
                .foregroundStyle(colorScheme == .light ? .primary0 : .secondary500)
                .cornerRadius(10, corners: .topLeft)
                .cornerRadius(10, corners: .topRight)
                .frame(height: 100)
                .shadow(radius: 64, y: -3)
            
            ZStack {
                VStack(alignment: .leading, spacing: 32) {
                    if account != nil {
                        Button(action: {
                            viewModel.showMenu = false
                            router.presentCreateSavingPlans()
                        }, label: {
                            HStack {
                                Image(systemName: "dollarsign.square.fill")
                                Text("word_savingsplan".localized)
                            }
                        })
                        .foregroundStyle(Color(uiColor: .label))
                        
                        Button(action: {
                            viewModel.showMenu = false
                            router.presentRecoverTransaction()
                        }, label: {
                            HStack {
                                Image(systemName: "tray.and.arrow.down.fill")
                                Text("recover_button".localized)
                            }
                        })
                        .foregroundStyle(Color(uiColor: .label))
                        
                        Button(action: {
                            viewModel.showMenu = false
                            router.presentCreateAutomation()
                        }, label: {
                            HStack {
                                Image(systemName: "clock.arrow.circlepath")
                                Text("word_automation".localized)
                            }
                        })
                        .foregroundStyle(Color(uiColor: .label))
                        
                        Button(action: { withAnimation { viewModel.showScanTransactionSheet() } }, label: {
                            HStack {
                                Image(systemName: "barcode.viewfinder")
                                Text("word_scanner".localized)
                            }
                        })
                        .foregroundStyle(Color(uiColor: .label))
                        
                        Button(action: {
                            viewModel.showMenu = false
                            router.presentCreateTransaction()
                        }, label: {
                            HStack {
                                Image(systemName: "creditcard.and.123")
                                Text("word_transaction".localized)
                            }
                        })
                        .foregroundStyle(Color(uiColor: .label))
                    } else {
                        Button(action: { viewModel.showAddAccountSheet() }, label: {
                            HStack {
                                Image(systemName: "person")
                                Text("word_account".localized)
                            }
                        })
                        .foregroundStyle(Color(uiColor: .label))
                    }
                }
                .padding()
                .background(colorScheme == .light ? Color.primary0 : Color.secondary500)
                .cornerRadius(15)
                .shadow(radius: 4)
                .scaleEffect(viewModel.showMenu ? 1 : 0)
                .offset(y: offsetYMenu)
                .opacity(viewModel.showMenu ? 1 : 0)
                
                Circle()
                    .foregroundStyle(HelperManager().getAppTheme().color)
                    .frame(width: 80)
                    .shadow(color: HelperManager().getAppTheme().color, radius: 12, y: 10)
                
                Image(systemName: "plus")
                    .font(.system(size: 34, weight: .regular, design: .rounded))
                    .foregroundStyle(colorScheme == .light ? .primary0 : .secondary500)
                    .rotationEffect(.degrees(viewModel.showMenu ? 45 : 0))
            }
            .frame(height: 80)
            .offset(y: -10)
            .onTapGesture {
                filter.showMenu = false
                withAnimation(.interpolatingSpring(stiffness: 150, damping: 12)) {
                    viewModel.showMenu.toggle()
                    if viewModel.showMenu {
                        if account != nil {
                            offsetYMenu = -180
                        } else { offsetYMenu = -80 }
                    } else {
                        offsetYMenu = 0
                    }
                }
                if viewModel.showMenu {
                    if hapticFeedback { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                }
            }
            
            ItemsForTabBar(selectedTab: $selectedTab, showMenu: $viewModel.showMenu)
        }
    } // End body
} //End struct

//MARK: - Preview
struct TabBarBackgroundView_Previews: PreviewProvider {
    
    @State static var selectedTabPreview: Int = 0
    @State static var showMenu: Bool = false
    
    @State static var offsetYMenu: CGFloat = 0
    
    @State static var previewAccount: Account? = Account.preview
    
    static var previews: some View {
        TabbarView(
            router: .init(isPresented: .constant(.homeCategories)),
            account: $previewAccount,
            selectedTab: $selectedTabPreview,
            offsetYMenu: $offsetYMenu
        )
        
        BannerShape()
            .cornerRadius(15, corners: [.topLeft, .topRight])
            .previewLayout(.sizeThatFits)
            .frame(width: UIScreen.main.bounds.width, height: 100)
            .padding()
    }
}

struct ItemsForTabBar: View {
    
    // Builder
    @Binding var selectedTab: Int
    @Binding var showMenu: Bool
    
    // Custom Type
    @ObservedObject var filter: Filter = sharedFilter
    
    // Environement
    @Environment(\.colorScheme) private var colorScheme
    
    // Number variables
    var hStackwidth = UIScreen.main.bounds.width / 2 - 80
    
    // MARK: - body
    var body: some View {
        HStack(alignment: .center) {
            HStack {
                VStack(spacing: 14) {
                    Image(systemName: "house")
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
                .frame(width: hStackwidth / 2)
                
                VStack(spacing: 14) {
                    Image(systemName: "chart.bar")
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
                .frame(width: hStackwidth / 2 + 10)
            }
            .padding(.bottom, 16)
            .frame(width: hStackwidth, height: 70)
            
            Spacer()
                        
            HStack {
                VStack(spacing: 14) {
                    Image(systemName: "creditcard")
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
                .frame(width: hStackwidth / 2 + 10)
                
                VStack(spacing: 14) {
                    Image(systemName: "rectangle.stack")
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
                .frame(width: hStackwidth / 2)
            }
            .padding(.bottom, 16)
            .frame(width: hStackwidth, height: 70)
        }
        .padding(.horizontal)
        .frame(height: 90)
    } // End body
} // End struct

struct BannerShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width / 2 - 48, y: 0))
            
            var pt1: CGPoint = .zero
            var pt2: CGPoint = .zero
            
            pt1 = .init(x: UIScreen.main.bounds.width / 2 - 48 + 5, y: 0)
            pt2 = .init(x: UIScreen.main.bounds.width / 2 - 48 - 10, y: 105)
            path.addArc(tangent1End: pt1, tangent2End: pt2, radius: 10)
            
            let p3 = path.currentPoint!
            path.addCurve(to: CGPoint(x: UIScreen.main.bounds.width - p3.x, y: p3.y),
                          control1: CGPoint(x: UIScreen.main.bounds.width / 2 - 75, y: 102),
                          control2: CGPoint(x: UIScreen.main.bounds.width / 2 + 75, y: 102))
            
            pt1 = .init(x: UIScreen.main.bounds.width / 2 + 48 - 10, y: 0)
            pt2 = .init(x: UIScreen.main.bounds.width / 2 + 48 + 10, y: 0)
            path.addArc(tangent1End: pt1, tangent2End: pt2, radius: 10)
            
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 0))
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 100))
            path.addLine(to: CGPoint(x: 0, y: 100))
            path.addLine(to: .zero)
            path.closeSubpath()
        }
    }
}
