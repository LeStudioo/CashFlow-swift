//
//  NetworkMonitor.swift
//  CoreModule
//
//  Created by Theo Sementa on 20/07/2025.
//

import Foundation
import Network

@MainActor
public final class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    @Published public var isConnected = false

    public init() {
        networkMonitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
