//
//  JSONManager.swift
//  CashFlow
//
//  Created by KaayZenn on 02/10/2023.
//

import Foundation

enum DecodeJSONStatus {
    case success, error, none
}

class JSONManager {
    
    func generateJSONForTransaction(transaction: TransactionEntity) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let date = transaction.date.withDefault
        let dateString = dateFormatter.string(from: date)
        
        let categoryTransaction = transaction.predefCategoryID
        let subcategoryTransaction = transaction.predefSubcategoryID
        
        let jsonString = """
        {
            "id": "\(transaction.id)",
            "predefCategoryID": "\(categoryTransaction)",
            "predefSubcategoryID": "\(subcategoryTransaction)",
            "title": "\(transaction.title)",
            "amount": \(transaction.amount),
            "date": "\(dateString)",
            "transactionToAccount": "null",
        }
        """
        return jsonString
    }
    
    func decodeJSON(account: Account, jsonString: String) -> TransactionEntity? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let jsonData = jsonString.data(using: .utf8)!
            let recoverTransaction = try decoder.decode(RecoverTransaction.self, from: jsonData)
            
            let newTransacation = TransactionEntity(context: persistenceController.container.viewContext)
            newTransacation.id = UUID()
            newTransacation.title = recoverTransaction.title
            newTransacation.amount = recoverTransaction.amount
            newTransacation.date = recoverTransaction.date
            newTransacation.transactionToAccount = account

            guard let category = PredefinedCategory.findByID(recoverTransaction.predefCategoryID) else {
                return nil
            }
            
            let subcategory = category.subcategories.findByID(recoverTransaction.predefSubcategoryID)
            
            newTransacation.predefCategoryID = category.id
            newTransacation.predefSubcategoryID = subcategory?.id ?? ""
            
            if newTransacation.title.isEmpty || newTransacation.amount == 0 {
                return nil
            } else {
                return newTransacation
            }
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
} // End Class
