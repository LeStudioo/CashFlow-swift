//
//  AddTransactionIntent.swift
//  CashFlow
//
//  Created by KaayZenn on 13/10/2023.
//  Localized with Toglee on 16/04/2025

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
        inputOptions: .init(keyboardType: .numberPad),
        requestValueDialog: "shortcut_parameter_amount_dialog"
    )
    var amount: String
    
    @Parameter(
        title: "shortcut_parameter_account_title",
        description: "shortcut_parameter_account_description",
        requestValueDialog: "shortcut_parameter_account_dialog"
    )
    var account: AccountModel?
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let userStore: UserStore = .shared
        let accountStore: AccountStore = .shared
        let transactionStore: TransactionStore = .shared
        
        func extractAmount(from input: String) -> Double {
            let allowedCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: ".,"))
            let filtered = input.components(separatedBy: allowedCharacters.inverted).joined()
            let normalized = filtered.replacingOccurrences(of: ",", with: ".")
            return Double(normalized) ?? 0.0
        }
        
        let finalNumber = extractAmount(from: amount)
        
        var body: TransactionModel = .init(
            _name: title,
            amount: finalNumber,
            typeNum: TransactionType.expense.rawValue,
            dateISO: Date().toISO(),
            categoryID: 0,
            isFromApplePay: true,
            nameFromApplePay: title,
            autoCat: PreferencesApplePay.shared.isAddCategoryAutomaticallyEnabled
        )
        
        if LocationManager.shared.isLocationEnabled && PreferencesApplePay.shared.isAddAddressAutomaticallyEnabled {
            let location = LocationManager.shared.getCurrentLocation()
            if let location, let address = try await LocationManager.shared.getCurrentAddress(location: location) {
                body.address = address
                body.lat = location.coordinate.latitude
                body.long = location.coordinate.longitude
            }
        }
                
        do {
            try await userStore.loginWithToken()
            await accountStore.fetchAccounts()
            
            let selectedAccount = account ?? accountStore.selectedAccount
            
            if let selectedAccount, let accountID = selectedAccount._id {
                let addInStore = AccountStore.shared.selectedAccount?._id == accountID
                await transactionStore.createTransaction(accountID: accountID, body: body, addInRepo: addInStore)
            }
                        
            let formatString = "shortcut_result_label".localized
            let formattedText = String(format: formatString, finalNumber.toString(), UserCurrency.symbol, title)
            
            return .result(dialog: IntentDialog(stringLiteral: formattedText))
        } catch {
            return .result(dialog: IntentDialog(stringLiteral: "Fail to add transaction."))
        }
    }
    
}

extension AccountModel: AppEntity {
    public static var typeDisplayRepresentation: TypeDisplayRepresentation {
        return TypeDisplayRepresentation(name: "Account")
    }
    
    public static var defaultQuery = AccountQuery()
    
    public var displayRepresentation: DisplayRepresentation {
        return DisplayRepresentation(
            title: "\(name)",
            subtitle: "\(balance.toString(maxDigits: 2)) \(UserCurrency.symbol)"
        )
    }
    
    public typealias ID = String // swiftlint:disable:this type_name
    
    public var entityID: ID {
        if let id = _id {
            return String(id)
        }
        return UUID().uuidString // Fallback if no ID is available
    }
}

// Create a query to fetch all accounts
struct AccountQuery: EntityQuery {
    func entities(for identifiers: [AccountModel.ID]) async throws -> [AccountModel] {
        let accountStore = AccountStore.shared
        await accountStore.fetchAccounts()
        
        return accountStore.allAccounts.filter { account in
            if let id = account._id {
                return identifiers.contains(String(id))
            }
            return false
        }
    }
    
    func suggestedEntities() async throws -> [AccountModel] {
        let userStore: UserStore = .shared
        try await userStore.loginWithToken()
        
        let accountStore = AccountStore.shared
        await accountStore.fetchAccounts()
        return accountStore.accounts
    }
}
