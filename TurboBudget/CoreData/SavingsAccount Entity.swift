//
//  SavingsAccount+CoreDataProperties.swift
//  CashFlow
//
//  Created by KaayZenn on 23/11/2023.
//
//

import Foundation
import CoreData


@objc(SavingsAccount)
public class SavingsAccount: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavingsAccount> {
        return NSFetchRequest<SavingsAccount>(entityName: "SavingsAccount")
    }

    @NSManaged public var id: UUID
    @NSManaged public var balance: Double
    @NSManaged public var savingsAccountToTransfer: Set<Transfer>?
    
    public var transfers: [Transfer] {
        if let transfers = savingsAccountToTransfer {
            return transfers.sorted(by: { $0.date > $1.date })
        } else {
            return []
        }
    }

}

// MARK: - Savings
extension SavingsAccount {

    //-------------------- getAllSavingsTransferForChosenMonth() ----------------------
    // Description : Récupère tous les transfers qui sont de l'épargne, pour un mois donné
    // Parameter : selectedDate: Date
    // Output : return [Transfer]
    // Extra : No
    //-----------------------------------------------------------
    func getAllSavingsTransferForChosenMonth(selectedDate: Date) -> [Transfer] {
        var savingsTransfer: [Transfer] = []
        
        for transfer in transfers {
            if transfer.amount > 0 && Calendar.current.isDate(transfer.date, equalTo: selectedDate, toGranularity: .month) { savingsTransfer.append(transfer) }
        }
        
        return savingsTransfer
    }
    
    //-------------------- amountOfSavingsByMonth() ----------------------
    // Description : Retourne la somme de toutes les transfers qui sont de l'épargne, pour un mois donné
    // Parameter : (month: Date)
    // Output : return Double
    // Extra : No
    //-----------------------------------------------------------
    func amountOfSavingsByMonth(month: Date) -> Double {
        return getAllSavingsTransferForChosenMonth(selectedDate: month).map({ $0.amount }).reduce(0, +)
    }

}

// MARK: - Withdrawal
extension SavingsAccount {
    
    //-------------------- getAllWithdrawalTransferForChosenMonth() ----------------------
    // Description : Récupère toutes les transfers qui sont des retraits, pour un mois donné
    // Parameter : (selectedDate: Date)
    // Output : return [Transfer]
    // Extra : No
    //-----------------------------------------------------------
    func getAllWithdrawalTransferForChosenMonth(selectedDate: Date) -> [Transfer] {
        var withdrawalTransfer: [Transfer] = []
        
        for transfer in transfers {
            if transfer.amount < 0 && Calendar.current.isDate(transfer.date, equalTo: selectedDate, toGranularity: .month) { withdrawalTransfer.append(transfer) }
        }
        
        return withdrawalTransfer
    }
    
    //-------------------- amountOfWithdrawalByMonth() ----------------------
    // Description : Retourne la somme de toutes les transfers qui sont des retraits, pour un mois donné
    // Parameter : (month: Date)
    // Output : return Double
    // Extra : No
    //-----------------------------------------------------------
    func amountOfWithdrawalByMonth(month: Date) -> Double {
        return getAllWithdrawalTransferForChosenMonth(selectedDate: month).map({ $0.amount }).reduce(0, -)
    }
    
}
