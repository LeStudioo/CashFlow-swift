//
//  ScannerView.swift
//  CashFlow
//
//  Created by KaayZenn on 08/10/2023.
//

import VisionKit
import SwiftUI

struct ScannerTicketView: UIViewControllerRepresentable {
    private let completionHandler: (_ amount: Double?, _ date: Date?, _ errorMessage: String?) -> Void
    
    init(completion: @escaping (_ amount: Double?, _ date: Date?, _ errorMessage: String?) -> Void) {
        self.completionHandler = completion
    }
    
    typealias UIViewControllerType = VNDocumentCameraViewController
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<ScannerTicketView>
    ) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(
        _ uiViewController: VNDocumentCameraViewController,
        context: UIViewControllerRepresentableContext<ScannerTicketView>
    ) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: completionHandler)
    }
    
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        private let completionHandler: (_ amount: Double?, _ date: Date?, _ errorMessage: String?) -> Void
        
        init(completion: @escaping (_ amount: Double?, _ date: Date?, _ errorMessage: String?) -> Void) {
            self.completionHandler = completion
        }
        
        func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFinishWith scan: VNDocumentCameraScan) {
                TextTicketRecognizer(cameraScan: scan).recognizeText { (amount, date, errorMessage) in
                    self.completionHandler(amount, date, errorMessage)
                    DispatchQueue.main.async {
                        controller.dismiss(animated: true, completion: nil)
                    }
                }
            }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            completionHandler(nil, nil, nil)
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            let errorMsg  = "error : \(error)"
            completionHandler(nil, nil, errorMsg)
        }
    }
}
