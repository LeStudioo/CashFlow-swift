//
//  Saving Plan Manager.swift
//  CashFlow
//
//  Created by KaayZenn on 16/08/2023.
//

import Foundation

class SavingPlanManager {
    
}

//MARK: Archived
extension SavingPlanManager {
    
    //-------------------- archiveCompletedSavingPlansAutomatically ----------------------
    // Description : Archive automatiquement les plans d'épargne d'un compte qui ont atteint leur montant cible, en fonction des préférences de l'utilisateur.
    // Parameter : (account: Account)
    // Output : None
    // Extra : Cette fonction vérifie si l'archivage automatique des plans d'épargne est activé dans les préférences de l'utilisateur. Si c'est le cas, elle archive les plans d'épargne qui ont atteint leur montant cible après un certain nombre de jours défini pour l'archivage.
    //--------------------------------------------------------------------------------------------------
    func archiveCompletedSavingPlansAutomatically(account: Account) {
        if UserDefaultsManager().automatedArchivedSavingPlan {
            for savingPlan in account.savingPlans {
                if savingPlan.actualAmount == savingPlan.amountOfEnd {
                    let dateForArchive: Date = Calendar.current.date(byAdding: .day, value: UserDefaultsManager().numberOfDayForArchivedTransaction, to: savingPlan.dateOfEnd!)!
                    if Date() > dateForArchive {
                        savingPlan.isArchived = true
                        persistenceController.saveContext()
                    }
                }
            }
        }
    }
}
