//
//  TransactionMapRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/04/2025.
//

import Foundation
import SwiftUI
import MapKit

@available(iOS 17.0, *)
struct TransactionMapRow: View {
    
    // dependencies
    var transaction: TransactionModel
        
    var cameraPosition: MapCameraPosition {
        return .region(.init(
            center: transaction.coordinates,
            latitudinalMeters: 400,
            longitudinalMeters: 400)
        )
    }
    
    // MARK: -
    var body: some View {
        let systemImage = transaction.subcategory?.icon ?? .iconQuestionFile
        Map(initialPosition: cameraPosition) { //TODO: Verify
//            Marker(
//                transaction.nameDisplayed,
//                image: systemImage,
//                coordinate: transaction.coordinates
//            )
//            .tint(transaction.category?.color ?? .blue)
        }
        .mapStyle(.standard(elevation: .realistic))
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    } // body
} // struct

// MARK: - Preview
#Preview {
    if #available(iOS 17.0, *) {
        TransactionMapRow(transaction: .mockClassicTransaction)
            .padding()
    } else {
        // Fallback on earlier versions
    }
}
