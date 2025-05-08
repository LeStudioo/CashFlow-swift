//
//  TransferRepositoryUtils.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/11/2024.
//

import Foundation

extension TransferStore {
    
    // -------------------- getAllSavingsTransferForChosenMonth() ----------------------
    // Description : Récupère tous les transfers qui sont de l'épargne, pour un mois donné
    // Parameter : selectedDate: Date
    // Output : return [Transfer]
    // Extra : No
    // -----------------------------------------------------------
    func getAllSavingsTransferForChosenMonth(selectedDate: Date) -> [TransactionModel] {
        var savingsTransfer: [TransactionModel] = []
        
        for transfer in self.transfers {
            if transfer.amount > 0 && Calendar.current.isDate(transfer.date, equalTo: selectedDate, toGranularity: .month) {
                savingsTransfer.append(transfer)
            }
        }
        
        return savingsTransfer
    }
    
    // -------------------- amountOfSavingsByMonth() ----------------------
    // Description : Retourne la somme de toutes les transfers qui sont de l'épargne, pour un mois donné
    // Parameter : (month: Date)
    // Output : return Double
    // Extra : No
    // -----------------------------------------------------------
    func amountOfSavingsByMonth(month: Date) -> Double {
        return getAllSavingsTransferForChosenMonth(selectedDate: month)
            .map(\.amount)
            .reduce(0, +)
    }
    
    // -------------------- getAllWithdrawalTransferForChosenMonth() ----------------------
    // Description : Récupère toutes les transfers qui sont des retraits, pour un mois donné
    // Parameter : (selectedDate: Date)
    // Output : return [Transfer]
    // Extra : No
    // -----------------------------------------------------------
    func getAllWithdrawalTransferForChosenMonth(selectedDate: Date) -> [TransactionModel] {
        var withdrawalTransfer: [TransactionModel] = []
        
        for transfer in transfers {
            if transfer.amount < 0 && Calendar.current.isDate(transfer.date, equalTo: selectedDate, toGranularity: .month) {
                withdrawalTransfer.append(transfer)
            }
        }
        
        return withdrawalTransfer
    }
    
    // -------------------- amountOfWithdrawalByMonth() ----------------------
    // Description : Retourne la somme de toutes les transfers qui sont des retraits, pour un mois donné
    // Parameter : (month: Date)
    // Output : return Double
    // Extra : No
    // -----------------------------------------------------------
    func amountOfWithdrawalByMonth(month: Date) -> Double {
        return getAllWithdrawalTransferForChosenMonth(selectedDate: month)
            .map(\.amount)
            .reduce(0, +)
    }
    
}
