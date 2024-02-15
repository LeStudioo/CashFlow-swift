//
//  ICloudManager.swift
//  CashFlow
//
//  Created by KaayZenn on 03/10/2023.
//

import Foundation
import CloudKit
import CoreData

enum IcloudDataStatus {
    case none, error, found
}

class ICloudManager: ObservableObject {
    
    @Published var icloudDataStatus: IcloudDataStatus = .none
    
    @Published var isSignedInToiCloud: Bool = false
    @Published var errorMessage: String = ""
    
    enum CloudKitError: LocalizedError {
        case iCloudAccountNotFound
        case iCloudAccountNotDetermined
        case iCloudAccountRestricted
        case iCloudAccountUnknown
    }
    
    func getiCloudStatus() {
        CKContainer.default().accountStatus { [weak self] status, error in
            DispatchQueue.main.async {
                switch status {
                case .couldNotDetermine:
                    self?.errorMessage = CloudKitError.iCloudAccountNotDetermined.localizedDescription
                case .available:
                    self?.isSignedInToiCloud = true
                case .restricted:
                    self?.errorMessage = CloudKitError.iCloudAccountRestricted.localizedDescription
                case .noAccount:
                    self?.errorMessage = CloudKitError.iCloudAccountNotFound.localizedDescription
                case .temporarilyUnavailable:
                    self?.errorMessage = CloudKitError.iCloudAccountUnknown.localizedDescription
                @unknown default:
                    self?.errorMessage = CloudKitError.iCloudAccountUnknown.localizedDescription
                }
            }
        }
    }
    
    func fetchTransactionFromCloudKit(completion: @escaping ([CKRecord]?, Error?) -> Void) {
        let container = CKContainer(identifier: "iCloud.Sementa.CashFlow")
        let privateDatabase = container.privateCloudDatabase
        
        let query = CKQuery(recordType: "CD_Transaction", predicate: NSPredicate(value: true))
        
        privateDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("⚠️ Error fetching records: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            if let records = records {
                completion(records, nil)
            }
        }
    }
    
    func saveRecordsToCoreData(records: [CKRecord]) {
        let context = PersistenceController.shared.container.viewContext
        let container = CKContainer(identifier: "iCloud.Sementa.CashFlow")
        let privateDatabase = container.privateCloudDatabase
        
        var results: [Transaction] = []
        var array: [Transaction] = []
        
        let request = NSFetchRequest<Transaction>(entityName: "Transaction")
        do {
            results = try context.fetch(request)
//            print("🔥 RESULTS : \(results.count)")
        } catch {
            print("⚠️ \(error.localizedDescription)")
        }
                
        for record in records {
            let newManagedObject = Transaction(context: context)
            // Map attributes from CKRecord to CoreData entity
            newManagedObject.id = UUID(uuidString: record["CD_id"] as? String ?? "") ?? UUID()
            newManagedObject.title = record["CD_title"] as? String ?? ""
            
//            print("🔥 TITLE : \(newManagedObject.title)")
            
            array.append(newManagedObject)
            // Save to CoreData
//            do {
//                try context.save()
//            } catch {
//                print("Failed to save to CoreData: \(error.localizedDescription)")
//            }
        }
        
        let resultsID: [UUID] = results.map({ $0.id })
        let arrayID: [UUID] = array.map({ $0.id })

        let arrayIDDiff = resultsID.filter({ !arrayID.contains($0) })
        
        print("🔥 COREDATA COUNT : \(results.count)")
        print("🔥 ICLOUD COUNT : \(array.count)")
        print("🔥 ARRAY DIFF ID (\(arrayIDDiff.count)) : \(arrayIDDiff)")
        
        let query = CKQuery(recordType: "CD_Account", predicate: NSPredicate(value: true))
        privateDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let records {
                if let account = records.first {
                    for result in results {
                        for id in arrayIDDiff {
                            if result.id == id && result.amount != 0 {
                                print("🔥 MISSING IN ICLOUD : \(result.title)")
                                
                                print("🔥 TRANSAC : \(result)")
                                
                                let newRecord = CKRecord(recordType: "CD_Transaction")
                                newRecord["CD_id"] = result.id.uuidString
                                newRecord["CD_title"] = result.title
                                newRecord["CD_amount"] = result.amount
                                newRecord["CD_comeFromAuto"] = result.comeFromAuto
                                newRecord["CD_creationDate"] = Date()
                                newRecord["CD_date"] = result.date
                                newRecord["CD_isArchived"] = false
                                newRecord["CD_isAuto"] = result.isAuto
                                newRecord["CD_note"] = result.note
                                newRecord["CD_predefCategoryID"] = result.predefCategoryID
                                newRecord["CD_predefSubcategoryID"] = result.predefSubcategoryID
                                newRecord["CD_transactionToAccount"] = account.recordID.recordName
            //                    newRecord["CD_transactionToAutomation"] = result.transactionToAutomation
                                newRecord["CD_transactionToCategory"] = nil
                                newRecord["CD_transactionToSubCategory"] = nil
                                
                                print("🔥 NEW RECORD : \(newRecord)")

                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    
    func checkDataInCloudKit(completion: @escaping (Bool) -> Void ) {
        let container = CKContainer(identifier: "iCloud.Sementa.CashFlow")
        let privateDatabase = container.privateCloudDatabase
        
        let query = CKQuery(recordType: "CD_Account", predicate: NSPredicate(value: true))
        privateDatabase.perform(query, inZoneWith: nil) { (records, error) in
            
//            print("🔥 RECORDS : \(records)")

            
//            if let error {
//                DispatchQueue.main.sync {
//                    self.icloudDataStatus = .error
//                }
//                print("⚠️ ERROR DATA ICLOUD \(error.localizedDescription)")
//            } else if let records = records, !records.isEmpty {
//                DispatchQueue.main.sync {
//                    self.icloudDataStatus = .found
//                }
//                print("🔥 DATA ICLOUD FOUND")
//            } else {
//                DispatchQueue.main.sync {
//                    self.icloudDataStatus = .error
//                }
//                print("🔥 ERROR DATA ICLOUD")
//            }
        }
        
        let queryTr = CKQuery(recordType: "CD_Transaction", predicate: NSPredicate(value: true))
        privateDatabase.perform(queryTr, inZoneWith: nil) { (records, error) in
            if let records {
//                print("🔥 RECORDS TR : \(records.count)")
                if !records.isEmpty {
                    completion(true)
                }
            }
            
        }
    }
    
}
