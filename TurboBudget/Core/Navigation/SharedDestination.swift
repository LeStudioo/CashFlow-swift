//
//  SharedDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/04/2025.
//

import SwiftUICore
import NavigationKit

enum SharedDestination: AppDestinationProtocol {
    case paywall
    case whatsNew
    case qrCodeScanner
    case releaseNoteDetail(releaseNote: ReleaseNoteModel)
    
    case home
    case analytics
    
    var id: Self { self }
    
    func body(route: Route) -> some View {
        switch self {
        case .paywall:
            PaywallScreen()
        case .whatsNew:
            WhatsNewScreen()
        case .qrCodeScanner:
            QRCodeScannerView()
        case .home:
            HomeScreen()
        case .analytics:
            AnalyticsScreen()
        case .releaseNoteDetail(let releaseNote):
            ReleaseNoteDetailView(releaseNote: releaseNote)
        }
    }
}
