//
//  ModalView.swift
//  CustomModal
//
//  Created by Theo Sementa on 28/02/2024.
//

import SwiftUI
import ConfettiSwiftUI

struct SuccessfullCreationView: View {
    
    // Environment
    @EnvironmentObject private var succesfullModalManager: SuccessfullModalManager
    
    // Number variables
    @State private var confettiCounter: Int = 0
    
    // MARK: -
    var body: some View {
        ZStack(alignment: .bottom) {
            if succesfullModalManager.isPresenting {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        succesfullModalManager.isPresenting = false
                    }
                
                VStack(spacing: 36) {
                    CircleWithCheckmark()
                        .confettiCannon(
                            counter: $confettiCounter,
                            num: 50,
                            openingAngle: Angle(degrees: 0),
                            closingAngle: Angle(degrees: 360),
                            radius: 200
                        )
                    
                    VStack(spacing: 16) {
                        Text(succesfullModalManager.title)
                            .font(.semiBoldCustom(size: 28))
                            .foregroundStyle(Color(uiColor: .label))
                        
                        Text(succesfullModalManager.subtitle)
                            .font(.mediumSmall())
                            .foregroundStyle(.secondary400)
                    }

                    AnyView(succesfullModalManager.content)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
                .frame(height: 400)
                .frame(maxWidth: .infinity)
                .padding(24)
                .padding(.vertical, 8)
                .background(Color.componentInComponent)
                .clipShape(RoundedRectangle(cornerRadius: UIScreen.main.displayCornerRadius, style: .continuous))
                .transition(.move(edge: .bottom))
                .padding(4)
            }
        }
        .animation(.smooth, value: succesfullModalManager.isPresenting)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .onChange(of: succesfullModalManager.isPresenting) { newValue in
            if newValue { 
                confettiCounter += 1
            } else {
                succesfullModalManager.resetData()
            }
        }
    }
}
