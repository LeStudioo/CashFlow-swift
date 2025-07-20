//
//  File.swift
//  CoreModule
//
//  Created by Theo Sementa on 20/07/2025.
//

import Foundation
import SwiftUI

extension Binding where Value == String {
    public func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}
