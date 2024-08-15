//
//  ModalView.swift
//  CustomModal
//
//  Created by Theo Sementa on 28/02/2024.
//

import SwiftUI

// TODO: Implenter ceci pour valider des transactions etc ...
// Refaire le fichier correcetement
struct SuccessfullModal {
    var title: String
    var subTitle: String
    @ViewBuilder var content: AnyView
    
    init(title: String, subTitle: String, content: @escaping () -> AnyView) {
        self.title = title
        self.subTitle = subTitle
        self.content = content()
    }
}

struct ModalView: View {
    
    // Builder
    var successfullModal: SuccessfullModal
    
    @EnvironmentObject private var succesfullModalManager: SuccessfullModalManager
    
    // MARK: - body
    var body: some View {
        ZStack(alignment: .bottom) {
            if succesfullModalManager.isPresenting {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.smooth) {
                            succesfullModalManager.isPresenting = false
                        }
                    }
                
                VStack {
                    HStack{
                        Spacer()
                        Button(action: { 
                            withAnimation(.smooth) {
                                succesfullModalManager.isPresenting = false
                            }
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(Color(uiColor: .label))
                                .padding(6)
                                .background {
                                    Circle()
                                        .foregroundStyle(Color(uiColor: .systemGray4))
                                }
                        })
                    }
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Text(successfullModal.title)
                            .font(.semiBoldCustom(size: 28))
                            .foregroundStyle(Color(uiColor: .label))
                        
                        Text(successfullModal.subTitle)
                            .font(.mediumSmall())
                            .foregroundStyle(.secondary400)
                    }
                    .padding(.bottom, 30)

                    successfullModal.content
                    
                    Spacer()
                }
                .padding(24)
                .padding(.vertical, 8)
                .frame(height: 400)
                .frame(maxWidth: .infinity)
                .background(Color.backgroundComponent)
                .clipShape(RoundedRectangle(cornerRadius: UIScreen.main.displayCornerRadius, style: .continuous))
                .transition(.move(edge: .bottom))
                .padding(4)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
    }
}

import UIKit

extension UIScreen {
    private static let cornerRadiusKey: String = {
        let components = ["Radius", "Corner", "display", "_"]
        return components.reversed().joined()
    }()

    /// The corner radius of the display. Uses a private property of `UIScreen`,
    /// and may report 0 if the API changes.
    public var displayCornerRadius: CGFloat {
        guard let cornerRadius = self.value(forKey: Self.cornerRadiusKey) as? CGFloat else {
            assertionFailure("Failed to detect screen corner radius")
            return 0
        }

        return cornerRadius
    }
}
