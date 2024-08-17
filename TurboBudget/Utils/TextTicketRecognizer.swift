//
//  TextRecognier.swift
//  CashFlow
//
//  Created by KaayZenn on 08/10/2023.
//

import Foundation
import Vision
import VisionKit

final class TextTicketRecognizer {
    let cameraScan: VNDocumentCameraScan
    private let queue = DispatchQueue(
        label: "scan-codes",
        qos: .default,
        attributes: [],
        autoreleaseFrequency: .workItem)
    private var completion: ((_ amount: Double?, _ date: Date?, _ errorMessage: String?) -> Void)!

    init(cameraScan: VNDocumentCameraScan) {
        self.cameraScan = cameraScan
    }

    func recognizeText(withCompletionHandler completionHandler: @escaping (_ amount: Double?, _ date: Date?, _ errorMessage: String?) -> Void) {
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
        var amountScanned: Double = 0.0
        var dateScanned: Date? = nil
        
        guard let results = results, !results.isEmpty else {
            self.completion(nil, nil, "error_scan_notext".localized)
            return
        }
        
        func convertStringToDate(_ dateString: String) -> Date? {
            let newDate = dateString.replacingOccurrences(of: ".", with: "/")
            let possibleFormats = ["dd/MM/yyyy", "MM/dd/yyyy", "dd.MM.yyyy", "MM.dd.yyyy"]
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            
            for format in possibleFormats {
                dateFormatter.dateFormat = format
                if let date = dateFormatter.date(from: newDate) {
                    return date
                }
            }
            return nil
        }
        
        // Extracting the date
        func extractDate(from string: String?) -> String? {
            guard let text = string else { return nil }

            let datePatterns = [
                "\\b\\d{1,2}[/.]\\d{1,2}[/.]\\d{2}\\b",
                "\\b\\d{1,2}[/.]\\d{1,2}[/.]\\d{4}\\b",
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
                    if let firstComponent = components.first, extractDate(from: String(firstComponent)) != nil  {
                        return String(firstComponent)
                    }
                }
            }
            return nil
        }).first {
            if let date = convertStringToDate(detectedDate) {
                dateScanned = date
            }
        }
        
        // Extracting the price
        if let highestPrice = results.compactMap({
            let priceString = ($0 as? VNRecognizedTextObservation)?.topCandidates(1).first?.string
            
            // Valider si la chaîne ressemble à un prix via une expression régulière
            let priceRegex = #"(\d+[.,]\d{2})"#
            let priceMatches = priceString?.matches(for: priceRegex)
            
            // Si nous avons des correspondances, essayons de les convertir en Double et retournons la plus grande
            return priceMatches?.compactMap { price in
                Double(price.replacingOccurrences(of: ",", with: "."))
            }.max()
        }).max() {
            amountScanned = highestPrice
        } else {
            completion(nil, nil, "banner_scan_error".localized)
        }
        
        completion(amountScanned, dateScanned, nil)
    }
}
