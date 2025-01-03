//
//  OnGetHeightViewModifier.swift
//  CashFlow
//
//  Created by Theo Sementa on 07/12/2024.
//

import SwiftUI

struct GetHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct OnGetHeightViewModifier: ViewModifier {
    
    let completion: (CGFloat) -> Void
    
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader {
                    Color.clear
                        .preference(
                            key: GetHeightKey.self,
                            value: $0.frame(in: .local).size.height
                        )
                }
            }
            .onPreferenceChange(GetHeightKey.self) {
                completion($0)
            }
    }
}

extension View {
    func onGetHeight(perform completion: @escaping (CGFloat) -> Void) -> some View {
        modifier(OnGetHeightViewModifier(completion: completion))
    }
}
