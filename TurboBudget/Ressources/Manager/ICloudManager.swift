//
//  ICloudManager.swift
//  CashFlow
//
//  Created by KaayZenn on 03/10/2023.
//

import Foundation
import CloudKit

enum IcloudDataStatus {
    case none, error, found
}

class ICloudManager: ObservableObject {
    
    @Published var icloudDataStatus: IcloudDataStatus = .none
    
    func checkDataInCloudKit() {
        let container = CKContainer(identifier: "iCloud.Sementa.CashFlow")
        let privateDatabase = container.privateCloudDatabase
        
        let query = CKQuery(recordType: "CD_Account", predicate: NSPredicate(value: true))
        privateDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error {
                DispatchQueue.main.sync {
                    self.icloudDataStatus = .error
                }
                print("⚠️ ERROR DATA ICLOUD \(error.localizedDescription)")
            } else if let records = records, !records.isEmpty {
                DispatchQueue.main.sync {
                    self.icloudDataStatus = .found
                }
                print("🔥 DATA ICLOUD FOUND")
            } else {
                DispatchQueue.main.sync {
                    self.icloudDataStatus = .error
                }
                print("🔥 ERROR DATA ICLOUD")
            }
        }
    }
    
}
