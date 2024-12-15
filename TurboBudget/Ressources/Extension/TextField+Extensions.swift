//
//  TextField+Extensions.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/12/2024.
//

import Foundation
import SwiftUI

extension TextField {
    func format(
        _ binding: Binding<String>,
        type: TextFieldFormatter.FormatType? = nil
    ) -> some View {
        self.onChange(of: binding.wrappedValue) { newValue in
            guard let type else { return }
            binding.wrappedValue = TextFieldFormatter(type: type).format(newValue)
        }
    }
}
