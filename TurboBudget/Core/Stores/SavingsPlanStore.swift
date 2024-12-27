//
//  SavingsPlanStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation

final class SavingsPlanStore: ObservableObject {
    static let shared = SavingsPlanStore()
    
    @Published var savingsPlans: [SavingsPlanModel] = []
}

extension SavingsPlanStore {
    
    @MainActor
    func fetchSavingsPlans(accountID: Int) async {
        do {
            let savingsPlans = try await NetworkService.shared.sendRequest(
                apiBuilder: SavingsPlanAPIRequester.fetch(accountID: accountID),
                responseModel: [SavingsPlanModel].self
            )
            self.savingsPlans = savingsPlans
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func createSavingsPlan(accountID: Int, body: SavingsPlanModel) async {
        do {
            let savingsPlan = try await NetworkService.shared.sendRequest(
                apiBuilder: SavingsPlanAPIRequester.create(accountID: accountID, body: body),
                responseModel: SavingsPlanModel.self
            )
            self.savingsPlans.append(savingsPlan)
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func createSavingsPlan(accountID: Int, body: SavingsPlanModel) async -> SavingsPlanModel? {
        do {
            let savingsPlan = try await NetworkService.shared.sendRequest(
                apiBuilder: SavingsPlanAPIRequester.create(accountID: accountID, body: body),
                responseModel: SavingsPlanModel.self
            )
            self.savingsPlans.append(savingsPlan)
            return savingsPlan
        } catch {
            NetworkService.handleError(error: error)
            return nil
        }
    }
    
    @MainActor
    func updateSavingsPlan(savingsPlanID: Int, body: SavingsPlanModel) async {
        do {
            let savingsPlan = try await NetworkService.shared.sendRequest(
                apiBuilder: SavingsPlanAPIRequester.update(savingsplanID: savingsPlanID, body: body),
                responseModel: SavingsPlanModel.self
            )
            if let index = self.savingsPlans.map(\.id).firstIndex(of: savingsPlanID) {
                self.savingsPlans[index].name = savingsPlan.name
                self.savingsPlans[index].emoji = savingsPlan.emoji
                self.savingsPlans[index].goalAmount = savingsPlan.goalAmount
                self.savingsPlans[index].startDateString = savingsPlan.startDateString
                self.savingsPlans[index].endDateString = savingsPlan.endDateString
                self.savingsPlans[index].note = savingsPlan.note
            }
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func deleteSavingsPlan(savingsPlanID: Int) async {
        do {
            try await NetworkService.shared.sendRequest(
                apiBuilder: SavingsPlanAPIRequester.delete(savingsplanID: savingsPlanID)
            )
            self.savingsPlans.removeAll { $0.id == savingsPlanID } 
        } catch { NetworkService.handleError(error: error) }
    }
}

extension SavingsPlanStore {
    
    func setNewAmount(savingsPlanID: Int, newAmount: Double) {
        if let savingsPlanIndex = savingsPlans.firstIndex(where: { $0.id == savingsPlanID }) {
            self.savingsPlans[savingsPlanIndex].currentAmount = newAmount
        }
    }
    
}
