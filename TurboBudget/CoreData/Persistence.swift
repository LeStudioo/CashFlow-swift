//
//  Persistence.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//

import CoreData
import SwiftUI
//https://stackoverflow.com/questions/66075714/using-cloudkit-coredata-how-to-update-ui-from-remote-cloud-update-without-swi

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController()
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newAccount = Account(context: viewContext)
            newAccount.id = UUID()
            newAccount.title = "Name of accout preview"
            newAccount.balance = 155_000
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "TurboBudget")
        
        guard let description = container.persistentStoreDescriptions.first else {
             fatalError("No container descriptions available")
        }
        
        // Generate NOTIFICATIONS on remote changes
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.Sementa.CashFlow")
        container.persistentStoreDescriptions = [ description ]
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    //MARK: Additional func
    
    //--------------------- saveContext() ------------------------
    // Description: Save the user's changes, reloadTransactions of Category and Subcategory
    // Parameter: NO
    // Output: Void
    // Extra :
    //----------------------------------------------------------------------
    func saveContext() {
        let context = container.viewContext
        
        do {
            try context.save()
            print("✅ Successfully saved")
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
}

//MARK: - Object For Preview
let previewViewContext = PersistenceController.shared.container.viewContext
let sampleViewContext = PersistenceController.shared.container.viewContext

//MARK: - ACCOUNT
func previewAccount1() -> Account {
    let account = Account(context: previewViewContext)
    account.id = UUID()
    account.title = "Preview Account"
    account.balance = 18_915
    account.cardLimit = 3000
    account.position = 1
    account.accountToSavingPlan?.insert(previewSavingPlan1())
    account.accountToSavingPlan?.insert(previewSavingPlan2())
//    account.accountToTransaction?.insert(previewTransaction1())
//    account.accountToTransaction?.insert(previewTransaction2())
//    account.accountToTransaction?.insert(previewTransaction3())
//    account.accountToTransaction?.insert(previewTransaction4())
//    account.accountToTransaction?.insert(previewTransaction5())
//    account.accountToTransaction?.insert(previewTransaction6())
//    account.accountToTransaction?.insert(previewTransaction7())
//    account.accountToTransaction?.insert(previewTransaction8())
    
//    account.accountToAutomation?.insert(previewAutomation1())
//    account.accountToAutomation?.insert(previewAutomation2())
    
//    account.accountToCard = previewCard1()
    
    return account
}

//MARK: - CARD
func previewCard1() -> Card {
    let card = Card(context: PersistenceController.preview.container.viewContext)
    card.id = UUID()
    card.holder = "Preview Holder"
    card.number = "1234 1234 1234 1234"
    card.date = "01/01"
    card.cvv = "123"
    card.limit = 3000
    
    return card
}

//MARK: - TRANSACTION
func previewTransaction1() -> Transaction {
    let previewTransaction1 = Transaction(context: PersistenceController.preview.container.viewContext)
    previewTransaction1.id = UUID()
    previewTransaction1.title = "Preview Transaction 1"
    previewTransaction1.amount = -800
    previewTransaction1.date = Calendar.current.date(byAdding: .day, value: -12, to: Date()) ?? .now
    
    return previewTransaction1
}

func previewTransaction2() -> Transaction {
    let transaction = Transaction(context: PersistenceController.preview.container.viewContext)
    transaction.id = UUID()
    transaction.title = "Preview Transaction 1"
    transaction.amount = -400
    transaction.date = Calendar.current.date(byAdding: .day, value: -8, to: Date()) ?? .now
    
    return transaction
}

func previewTransaction3() -> Transaction {
    let transaction = Transaction(context: PersistenceController.preview.container.viewContext)
    transaction.id = UUID()
    transaction.title = "Preview Transaction 1"
    transaction.amount = -1000
    transaction.date = Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? .now
    
    return transaction
}

func previewTransaction4() -> Transaction {
    let transaction = Transaction(context: PersistenceController.preview.container.viewContext)
    transaction.id = UUID()
    transaction.title = "Preview Transaction 1"
    transaction.amount = -600
    transaction.date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? .now
    
    return transaction
}

func previewTransaction5() -> Transaction {
    let transaction = Transaction(context: PersistenceController.preview.container.viewContext)
    transaction.id = UUID()
    transaction.title = "Preview Transaction 1"
    transaction.amount = 800
    transaction.date = Calendar.current.date(byAdding: .day, value: -12, to: Date()) ?? .now
    
    return transaction
}

func previewTransaction6() -> Transaction {
    let transaction = Transaction(context: PersistenceController.preview.container.viewContext)
    transaction.id = UUID()
    transaction.title = "Preview Transaction 1"
    transaction.amount = 400
    transaction.date = Calendar.current.date(byAdding: .day, value: -8, to: Date()) ?? .now
    
    return transaction
}

func previewTransaction7() -> Transaction {
    let transaction = Transaction(context: PersistenceController.preview.container.viewContext)
    transaction.id = UUID()
    transaction.title = "Preview Free"
    transaction.amount = 100
//    transaction.date = Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? .now
    
    return transaction
}

func previewTransaction8() -> Transaction {
    let transaction = Transaction(context: PersistenceController.preview.container.viewContext)
    transaction.id = UUID()
    transaction.title = "Preview Netflix"
    transaction.amount = 600
//    transaction.date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? .now
    
    return transaction
}

var previewAllTransactions: [Transaction] = [previewTransaction1(), previewTransaction2(), previewTransaction3(), previewTransaction4(), previewTransaction5(), previewTransaction6(), previewTransaction7(), previewTransaction8()]

//MARK: - AUTOMATIONS
func previewAutomation1() -> Automation {
    let automation = Automation(context: PersistenceController.preview.container.viewContext)
    automation.id = UUID()
    automation.title = "Free"
    automation.date = Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? .now
    automation.isNotif = false
    automation.automationToTransaction = previewTransaction7()
    
    return automation
}

func previewAutomation2() -> Automation {
    let automation = Automation(context: PersistenceController.preview.container.viewContext)
    automation.id = UUID()
    automation.title = "Netflix"
    automation.date = Calendar.current.date(byAdding: .day, value: 4, to: Date()) ?? .now
    automation.isNotif = false
    automation.automationToTransaction = previewTransaction8()
    
    return automation
}

//MARK: - BUDGETS
func previewBudget1() -> Budget {
    let budget = Budget(context: PersistenceController.preview.container.viewContext)
    budget.id = UUID()
    budget.title = "Preview Budget 1"
    budget.amount = 500
    budget.predefCategoryID = categoryPredefined1.idUnique
    
    return budget
}

func previewBudget2() -> Budget {
    let budget = Budget(context: PersistenceController.preview.container.viewContext)
    budget.id = UUID()
    budget.title = "Preview Budget 2"
    budget.amount = 800
    budget.predefCategoryID = categoryPredefined2.idUnique
    budget.predefSubcategoryID = subCategory1Category2.idUnique
    
    return budget
}

//MARK: - SAVING PLANS
func previewSavingPlan1() -> SavingPlan {
    let savingPlan = SavingPlan(context: previewViewContext)
    savingPlan.id = UUID()
    savingPlan.icon = "🚙"
    savingPlan.title = "New Car"
    savingPlan.amountOfStart = 1000
    savingPlan.actualAmount = 3250
    savingPlan.amountOfEnd = 5000
    savingPlan.savingPlansToContribution?.insert(previewContribution1())
    savingPlan.savingPlansToContribution?.insert(previewContribution2())
    
    return savingPlan
}

func previewSavingPlan2() -> SavingPlan {
    let savingPlan = SavingPlan(context: previewViewContext)
    savingPlan.id = UUID()
    savingPlan.icon = "🏠"
    savingPlan.title = "New Home"
    savingPlan.amountOfEnd = 5000
    
    return savingPlan
}

func previewSavingPlan3() -> SavingPlan {
    let savingPlan = SavingPlan(context: PersistenceController.preview.container.viewContext)
    savingPlan.id = UUID()
    savingPlan.icon = "👕"
    savingPlan.title = "New Clothes"
    savingPlan.amountOfEnd = 5000
    
    return savingPlan
}

func previewSavingPlan4() -> SavingPlan {
    let savingPlan = SavingPlan(context: PersistenceController.preview.container.viewContext)
    savingPlan.id = UUID()
    savingPlan.icon = "✈️"
    savingPlan.title = "Vacation"
    savingPlan.amountOfEnd = 5000
    
    return savingPlan
}

func previewSavingPlan5() -> SavingPlan {
    let savingPlan = SavingPlan(context: PersistenceController.preview.container.viewContext)
    savingPlan.id = UUID()
    savingPlan.icon = "👸"
    savingPlan.title = "New Cosmetic"
    savingPlan.amountOfEnd = 5000
    
    return savingPlan
}

func previewSavingPlan6() -> SavingPlan {
    let savingPlan = SavingPlan(context: PersistenceController.preview.container.viewContext)
    savingPlan.id = UUID()
    savingPlan.icon = "❤️"
    savingPlan.title = "Love"
    savingPlan.amountOfEnd = 5000
    
    return savingPlan
}

//MARK: - CONTRIBUTIONS
func previewContribution1() -> Contribution {
    let contribution = Contribution(context: previewViewContext)
    contribution.id = UUID()
    contribution.amount = 1000
    contribution.date = .now

    return contribution
}

func previewContribution2() -> Contribution {
    let contribution = Contribution(context: previewViewContext)
    contribution.id = UUID()
    contribution.amount = -500
    contribution.date = .now

    return contribution
}

//MARK: - SampleData
func sampleDataCashFlowChart() -> [Int: Double] {
    let sampleData: [Int: Double] = [1: 1805, 2: 1340, 3: 2500, 4: 2000, 5: 1800, 6: 2300, 7: 2100, 8: 2800, 9: 2285, 10: 0, 11: 0, 12: 0]
    return sampleData
}
//ForEach(Array(sampleDataCashFlowChart()).indices, id: \.self) { index in
//
//
//    BarMark(x: .value("x", "\(index)"),
//            y: .value("y", sampleDataCashFlowChart()[index + 1] ?? 0))
//    .foregroundStyle(index == 8 ? Color.yellow.gradient : HelperManager().getAppTheme().color.gradient)
//    .clipShape(RoundedRectangle(cornerRadius: 30))
//}
