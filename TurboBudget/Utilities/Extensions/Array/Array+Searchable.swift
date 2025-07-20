//
//  Array+Searchable.swift
//  CashFlow
//
//  Created by Theo Sementa on 24/05/2025.
//

import Foundation
import CoreModule

extension Array where Element: Searchable {
    
    func search(_ query: String) -> [Element] {
        guard !query.isEmpty else { return self }
        
        return self.filter { $0.searchableText.localizedStandardContains(query) }
    }
    
}
