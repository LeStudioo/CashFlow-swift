//
//  CircleWithCheckmark.swift
//  CashFlow
//
//  Created by KaayZenn on 13/08/2023.
//

import SwiftUI

struct CircleWithCheckmark: View {

    //State or Binding Int, Float and Double
    @State private var scaleCheckmark: CGFloat = 0

    //MARK: - Body
    var body: some View {
        Circle()
            .frame(width: 100, height: 100)
            .foregroundStyle(ThemeManager.theme.color)
            .overlay {
                Image(systemName: "checkmark")
                    .foregroundStyle(.primary0)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .scaleEffect(scaleCheckmark)
            }
            .onAppear {
                withAnimation(.interpolatingSpring(stiffness: 170, damping: 5).delay(0.3)) { scaleCheckmark = 1.2 }
            }
    } // End body
} // End struct

//MARK: - Preview
#Preview {
    CircleWithCheckmark()
}
