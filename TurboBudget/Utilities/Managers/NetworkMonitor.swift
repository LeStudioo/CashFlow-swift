//
//  NetworkMonitor.swift
//  CashFlow
//
//  Created by Theo Sementa on 19/04/2025.
//

import Foundation
import Network

final class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    @Published var isConnected = false

    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        networkMonitor.start(queue: workerQueue)
    }
}
