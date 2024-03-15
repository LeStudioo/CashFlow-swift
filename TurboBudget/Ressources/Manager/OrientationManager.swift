//
//  OrientationManager.swift
//  CashFlow
//
//  Created by KaayZenn on 28/07/2023.
//

import Foundation
import SwiftUI
import Combine

class OrientationManager: ObservableObject {
    static let shared = OrientationManager()
    
    @Published var orientation: UIDeviceOrientation = .unknown
    
    init() {
        getOrientationOnAppear()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func getOrientationOnAppear() {
        if UIDevice.current.orientation.isPortrait {
            orientation = UIDeviceOrientation.portrait
        } else {
            orientation = UIDeviceOrientation.landscapeRight
        }
    }
    
    @objc func orientationChanged() {
        DispatchQueue.main.async {
            self.getOrientationOnAppear()
        }
    }
}
