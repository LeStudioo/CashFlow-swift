//
//  TextCreditCardRecognizer.swift
//  CashFlow
//
//  Created by KaayZenn on 17/10/2023.
//

import Foundation
import Vision
import VisionKit

final class TextCreditCardRecognizer {
    let cameraScan: VNDocumentCameraScan
    private let queue = DispatchQueue(
        label: "scan-creditcard",
        qos: .default,
        attributes: [],
        autoreleaseFrequency: .workItem)
    private var completion: ((_ cardNumber: String?, _ date: String?, _ errorMessage: String?) -> Void)!

    init(cameraScan: VNDocumentCameraScan) {
        self.cameraScan = cameraScan
    }

    func recognizeText(withCompletionHandler completionHandler: @escaping (_ cardNumber: String?, _ date: String?, _ errorMessage: String?) -> Void) {
        self.completion = completionHandler
        guard let image = self.cameraScan.imageOfPage(at: 0).cgImage else {
            self.completion(nil, nil, "error_scan_noimage".localized)
            return
        }

        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                self.completion(nil, nil, String(format: "error_scan".localized, "\(error)"))
            } else {
                self.handleDetectionResults(results: request.results)
            }
        }

        request.recognitionLanguages = ["fr_FR", "en_EN", "es_ES", "de_DE", "it_IT"]
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false

        performDetection(request: request, image: image)
    }

    func performDetection(request: VNRecognizeTextRequest, image: CGImage) {
        let requests = [request]

        let handler = VNImageRequestHandler(cgImage: image, orientation: .up, options: [:])

        queue.async {
            do {
                try handler.perform(requests)
            } catch let error {
                self.completion(nil, nil, "Error: \(error)")
            }
        }
    }

    func handleDetectionResults(results: [Any]?) {
        var cardcreditNumberScanned: String = ""
        var dateScanned: String?
        
        guard let results = results, !results.isEmpty else {
            self.completion(nil, nil, "error_scan_notext".localized)
            return
        }

        // Extracting the date
        func extractDate(from string: String?) -> String? {
            guard let text = string else { return nil }

            let datePatterns = [
                "\\b\\d{1,2}/\\d{1,2}\\b"
            ]

            for pattern in datePatterns {
                if let regex = try? NSRegularExpression(pattern: pattern, options: []),
                   let match = regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)),
                   let range = Range(match.range, in: text) {
                    return String(text[range])
                }
            }
            return nil
        }
        
        if let detectedDate = results.compactMap({
            if let candidates = ($0 as? VNRecognizedTextObservation)?.topCandidates(10) {
                for candidate in candidates {
                    print("🔥 candidate : \(candidate.string)")
                    let components = candidate.string.split(separator: " ")
                    if let firstComponent = components.first, extractDate(from: String(firstComponent)) != nil {
                        return String(firstComponent)
                    }
                }
            }
            return nil
        }).first {
            dateScanned = detectedDate
        }
        
        // Extracting credit card number
        if let detectedCreditCardNumber = results.compactMap({
            let textString = ($0 as? VNRecognizedTextObservation)?.topCandidates(1).first?.string
            // Valider si la chaîne ressemble à un numéro de carte de crédit via une expression régulière
            let cardRegex = #"^\d{4} \d{4} \d{4} \d{4}$"#
            if textString?.range(of: cardRegex, options: .regularExpression) != nil {
                return textString
            }
            return nil
        }).first {
            cardcreditNumberScanned = detectedCreditCardNumber
        } else {
            completion(nil, nil, "banner_scan_error".localized)
        }
        
        completion(cardcreditNumberScanned, dateScanned, nil)
    }
}
