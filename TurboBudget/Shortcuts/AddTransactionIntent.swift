//
//  AddTransactionIntent.swift
//  CashFlow
//
//  Created by KaayZenn on 13/10/2023.
//

import CoreData
import AppIntents

struct AddTransactionIntent: AppIntent {
    
    static let title: LocalizedStringResource = "shortcut_title"
    static let description: LocalizedStringResource = "shortcut_desccription"
    
    @Parameter(
        title: "shortcut_parameter_title_title",
        description: "shortcut_parameter_title_description",
        requestValueDialog: "shortcut_parameter_title_dialog"
    )
    var title: String
    
    @Parameter(
        title: "shortcut_parameter_amount_title",
        description: "shortcut_parameter_amount_description",
        requestValueDialog: "shortcut_parameter_amount_dialog"
    )
    var amount: String
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
                
        func extractNumberString(from string: String) -> String {
            var numberString: String = ""
            var finalNumber: Double = 0.0
            var numbers: [Int] = []
            
            let regex = try? NSRegularExpression(pattern: "\\d+", options: [])
            
            regex?.enumerateMatches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count)) { match, _, _ in
                if let match = match, let range = Range(match.range, in: string) {
                    let number = String(string[range])
                    if let intValue = Int(number) {
                        numbers.append(intValue)
                    }
                }
            }
            
            numberString = String(numbers[0])
            if numbers.count > 1 {
                let decimalPart = numbers[1] < 10 ? String("0" + String(numbers[1])) : String(numbers[1])
                numberString += "." + decimalPart
                finalNumber = Double(numberString) ?? 0 / 100
            } else {
                finalNumber = Double(numberString) ?? 0
            }
            
            return String(format: "%.2f", finalNumber)
        }
        
        func extractNumber(from string: String) -> Double {
            var numberString: String = ""
            var finalNumber: Double = 0.0
            var numbers: [Int] = []
            
            let regex = try? NSRegularExpression(pattern: "\\d+", options: [])
            
            regex?.enumerateMatches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count)) { match, _, _ in
                if let match = match, let range = Range(match.range, in: string) {
                    let number = String(string[range])
                    if let intValue = Int(number) {
                        numbers.append(intValue)
                    }
                }
            }
            
            numberString = String(numbers[0])
            if numbers.count > 1 {
                let decimalPart = numbers[1] < 10 ? String("0" + String(numbers[1])) : String(numbers[1])
                numberString += "." + decimalPart
                finalNumber = Double(numberString) ?? 0 / 100
            } else {
                finalNumber = Double(numberString) ?? 0
            }
            
            return finalNumber
        }
        
        let finalNumber = extractNumber(from: amount)
        
        let userRepository: UserStore = .shared
        let accountRepository: AccountStore = .shared
        let transactionRepository: TransactionStore = .shared
        
        let body: TransactionModel = .init(
            _name: title,
            amount: finalNumber,
            typeNum: TransactionType.expense.rawValue,
            dateISO: Date().toISO(),
            categoryID: 0,
            isFromApplePay: true,
            nameFromApplePay: title,
            autoCat: PreferencesApplePay.shared.isAddCategoryAutomaticallyEnabled
        )
                
        do {
            try await userRepository.loginWithToken()
            await accountRepository.fetchAccounts()
            if let account = accountRepository.selectedAccount, let accountID = account.id {
                await transactionRepository.createTransaction(accountID: accountID, body: body)
            }
            
            let amountString: String = extractNumberString(from: amount)
            
            let formatString = "shortcut_result_label".localized
            let formattedText = String(format: formatString, amountString, UserCurrency.symbol, title)
            
            return .result(dialog: IntentDialog(stringLiteral: formattedText))
        } catch {
            return .result(dialog: IntentDialog(stringLiteral: "Fail to add transaction."))
        }
    }
    
}
