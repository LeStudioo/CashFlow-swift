//
//  ScannerCreditCardView.swift
//  CashFlow
//
//  Created by KaayZenn on 17/10/2023.
//

import VisionKit
import SwiftUI

struct ScannerCreditCardView: UIViewControllerRepresentable {
    private let completionHandler: (_ cardNumber: String?, _ date: String?, _ errorMessage: String?) -> Void
    
    init(completion: @escaping (_ cardNumber: String?, _ date: String?, _ errorMessage: String?) -> Void) {
        self.completionHandler = completion
    }
    
    typealias UIViewControllerType = VNDocumentCameraViewController
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<ScannerCreditCardView>
    ) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(
        _ uiViewController: VNDocumentCameraViewController,
        context: UIViewControllerRepresentableContext<ScannerCreditCardView>
    ) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: completionHandler)
    }
    
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        private let completionHandler: (_ cardNumber: String?, _ date: String?, _ errorMessage: String?) -> Void
        
        init(completion: @escaping (_ cardNumber: String?, _ date: String?, _ errorMessage: String?) -> Void) {
            self.completionHandler = completion
        }
        
        func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFinishWith scan: VNDocumentCameraScan) {
                TextCreditCardRecognizer(cameraScan: scan).recognizeText { cardNumber, date, errorMessage in
                    self.completionHandler(cardNumber, date, errorMessage)
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
