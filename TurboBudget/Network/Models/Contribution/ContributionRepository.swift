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
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func createContribution(savingsplanID: Int, body: ContributionModel) async {
        do {
            let contribution = try await NetworkService.shared.sendRequest(
                apiBuilder: ContributionAPIRequester.create(savingsplanID: savingsplanID, body: body),
                responseModel: ContributionModel.self
            )
            self.contributions.append(contribution)
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func updateContribution(savingsplanID: Int, contributionID: Int, body: ContributionModel) async {
        do {
            let contribution = try await NetworkService.shared.sendRequest(
                apiBuilder: ContributionAPIRequester.update(savingsplanID: savingsplanID, contributionID: contributionID, body: body),
                responseModel: ContributionModel.self
            )
            if let index = self.contributions.map(\.id).firstIndex(of: contributionID) {
                self.contributions[index] = contribution
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
