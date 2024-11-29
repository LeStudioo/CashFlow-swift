//
//  ContributionRepository.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation

final class ContributionRepository: ObservableObject {
    static let shared = ContributionRepository()
    
    @Published var contributions: [ContributionModel] = []
}

extension ContributionRepository {
    
    @MainActor
    func fetchContributions(savingsplanID: Int) async {
        do {
            let contributions = try await NetworkService.shared.sendRequest(
                apiBuilder: ContributionAPIRequester.fetch(savingsplanID: savingsplanID),
                responseModel: [ContributionModel].self
            )
            self.contributions = contributions
            sortContributionsByDate()
        } catch { NetworkService.handleError(error: error) }
    }
    
    @discardableResult
    @MainActor
    func createContribution(savingsplanID: Int, body: ContributionModel) async -> ContributionModel? {
        do {
            let response = try await NetworkService.shared.sendRequest(
                apiBuilder: ContributionAPIRequester.create(savingsplanID: savingsplanID, body: body),
                responseModel: ContributionResponseWithAmount.self
            )
            if let contribution = response.contribution, let newAmount = response.newAmount {
                self.contributions.append(contribution)
                sortContributionsByDate()
                SavingsPlanRepository.shared.setNewAmount(savingsPlanID: savingsplanID, newAmount: newAmount)
                return contribution
            }
            
            return nil
        } catch {
            NetworkService.handleError(error: error)
            return nil
        }
    }
    
    @MainActor
    func updateContribution(savingsplanID: Int, contributionID: Int, body: ContributionModel) async {
        do {
            let response = try await NetworkService.shared.sendRequest(
                apiBuilder: ContributionAPIRequester.update(savingsplanID: savingsplanID, contributionID: contributionID, body: body),
                responseModel: ContributionResponseWithAmount.self
            )
            if let contribution = response.contribution, let newAmount = response.newAmount {
                if let index = self.contributions.map(\.id).firstIndex(of: contributionID) {
                    self.contributions[index] = contribution
                    sortContributionsByDate()
                    SavingsPlanRepository.shared.setNewAmount(savingsPlanID: savingsplanID, newAmount: newAmount)
                }
            }
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func deleteContribution(savingsplanID: Int, contributionID: Int) async {
        do {
            try await NetworkService.shared.sendRequest(
                apiBuilder: ContributionAPIRequester.delete(savingsplanID: savingsplanID, contributionID: contributionID)
            )
            self.contributions.removeAll(where: { $0.id == contributionID })
        } catch { NetworkService.handleError(error: error) }
    }
    
}

extension ContributionRepository {
    
    private func sortContributionsByDate() {
        self.contributions.sort { $0.date > $1.date }
    }
    
}
