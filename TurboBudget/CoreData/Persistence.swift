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
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
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

// MARK: - GLOBAL
let persistenceController: PersistenceController = PersistenceController.shared
let viewContext: NSManagedObjectContext = persistenceController.container.viewContext

let previewViewContext = PersistenceController.shared.container.viewContext
