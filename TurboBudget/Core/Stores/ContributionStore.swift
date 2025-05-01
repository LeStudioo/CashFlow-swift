//
//  ContributionStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation
import NetworkKit
import StatsKit

final class ContributionStore: ObservableObject {
    static let shared = ContributionStore()
    
    @Published var contributions: [ContributionModel] = []
}

extension ContributionStore {
    
    @MainActor
    func fetchContributions(savingsplanID: Int) async {
        do {
            let contributions = try await NetworkService.sendRequest(
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
            let response = try await NetworkService.sendRequest(
                apiBuilder: ContributionAPIRequester.create(savingsplanID: savingsplanID, body: body),
                responseModel: ContributionResponseWithAmount.self
            )
            if let contribution = response.contribution, let newAmount = response.newAmount {
                self.contributions.append(contribution)
                sortContributionsByDate()
                SavingsPlanStore.shared.setNewAmount(savingsPlanID: savingsplanID, newAmount: newAmount)
                EventService.sendEvent(key: .contributionCreated)
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
            let response = try await NetworkService.sendRequest(
                apiBuilder: ContributionAPIRequester.update(savingsplanID: savingsplanID, contributionID: contributionID, body: body),
                responseModel: ContributionResponseWithAmount.self
            )
            if let contribution = response.contribution, let newAmount = response.newAmount {
                if let index = self.contributions.map(\.id).firstIndex(of: contributionID) {
                    self.contributions[index] = contribution
                    sortContributionsByDate()
                    SavingsPlanStore.shared.setNewAmount(savingsPlanID: savingsplanID, newAmount: newAmount)
                    EventService.sendEvent(key: .contributionUpdated)
                }
            }
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func deleteContribution(savingsplanID: Int, contributionID: Int) async {
        do {
            let response = try await NetworkService.sendRequest(
                apiBuilder: ContributionAPIRequester.delete(savingsplanID: savingsplanID, contributionID: contributionID),
                responseModel: ContributionResponseWithAmount.self
            )
            if let newAmount = response.newAmount {
                SavingsPlanStore.shared.setNewAmount(savingsPlanID: savingsplanID, newAmount: newAmount)
            }
            self.contributions.removeAll(where: { $0.id == contributionID })
            EventService.sendEvent(key: .contributionDeleted)
        } catch { NetworkService.handleError(error: error) }
    }
    
}

extension ContributionStore {
    
    private func sortContributionsByDate() {
        self.contributions.sort { $0.date > $1.date }
    }
    
    func getContributionsAmountByMonth(for year: Int) -> [Double] {
        var contributionsByMonth = Array(repeating: 0.0, count: 12)
        
        let contributionsFiltered: [ContributionModel] = contributions
            .filter { $0.date.year == year }
        
        let grouped = Dictionary(grouping: contributionsFiltered) { Calendar.current.component(.month, from: $0.date) }
        
        for (month, contributions) in grouped {
            let additions = contributions.filter { $0.type == .addition }.compactMap(\.amount).reduce(0, +)
            let withdrawals = contributions.filter { $0.type == .withdrawal }.compactMap(\.amount).reduce(0, +)
            let totalAmount = additions - withdrawals
            contributionsByMonth[month - 1] = totalAmount
        }
        
        return contributionsByMonth
    }
    
    func getContributions(in month: Date? = nil, type: ContributionType? = nil) -> [ContributionModel] {
        return contributions
            .filter { $0.type == type }
            .filter {
                if let month {
                    return Calendar.current.isDate($0.date, equalTo: month, toGranularity: .month)
                } else { return true }
            }
    }
    
    func getAmountOfContributions(in month: Date? = nil) -> Double {
        let additions = getContributions(in: month, type: .addition).compactMap(\.amount).reduce(0, +)
        let withdrawals = getContributions(in: month, type: .withdrawal).compactMap(\.amount).reduce(0, +)
        return additions - withdrawals
    }
}
