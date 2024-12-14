////
////  SocketManager.swift
////  Split
////
////  Created by Theo Sementa on 31/05/2024.
////
//
//import Foundation
//import SocketIO
//
//enum SocketContext: String {
//    case friend
//    case friendRequest
//    case group
//    case groupDelete
//    case expense
//}
//
//class SocketManagerSplit {
//    static let shared = SocketManagerSplit()
//    
//    private var manager: SocketManager
//    private var socket: SocketIOClient
//    
//    init() {
//        self.manager = SocketManager(
//            socketURL: URL(string: NetworkPath.baseURL)!,
//            config: [
//                .log(true),
//                .compress,
//                .reconnects(true),
//                .reconnectWait(10),
//                .reconnectAttempts(4),
//                .connectParams(["token": TokenManager.shared.token])
//            ]
//        )
//        
//        self.socket = self.manager.defaultSocket
//        
//        // Configure les événements
//        setupSocketEvents()
//    }
//    
//    
//    func connect() {
//        socket.connect()
//    }
//    
//    func disconnect() {
//        socket.disconnect()
//    }
//    
//    func isConnected() -> Bool {
//        return socket.status == .connected
//    }
//    
//    private func setupSocketEvents() {
//        socket.on(clientEvent: .connect) { data, ack in
//            print("🛰️ Socket connected")
//        }
//        
//        socket.on(clientEvent: .disconnect) { data, ack in
//            print("🛰️ Socket disconnected")
//        }
//        
//        socket.on(clientEvent: .reconnect) { data, ack in
//            print("🛰️ Socket reconnecting")
//        }
//        
//        socket.on(clientEvent: .reconnectAttempt) { data, ack in
//            print("🛰️ Socket reconnect attempt")
//        }
//        
//        socket.on(clientEvent: .error) { data, ack in
//            print("🛰️ Socket error: \(data)")
//        }
//        
//        observeSocket()
//    }
//}
//
//extension SocketManagerSplit {
//    
//    // Écouter les événements "update" du socket
//    func observeSocket() {
//        socket.on("update") { data, ack in
//            print("🛰️ AN UPDATE IS NEEDED")
//            if let eventData = data.first as? [String: Any] {
//                print("🛰️ CONTEXT : \(eventData)")
//                Task {
////                    await self.handleUpdateEvent(eventData)
//                }
//            }
//        }
//    }
//    
////    private func handleUpdateEvent(_ eventData: [String: Any]) async {
////        if let context = eventData["context"] as? String, let socketContext = SocketContext(rawValue: context) {
////            switch socketContext {
////            case .friend:           
////                await FriendsRepository.shared.fetchFriends()
////            case .friendRequest:    
////                await FriendsRepository.shared.fetchRequests()
////            case .group:
////                guard let groupID = eventData["id"] as? Int else { return }
////                await GroupRepository.shared.getGroupFromSocket(groupID: groupID)
////            case .groupDelete:
////                guard let groupID = eventData["id"] as? Int else { return }
////                await GroupRepository.shared.deleteFromSocket(groupID: groupID)
////            case .expense:
////                guard let groupID = eventData["mainId"] as? Int else { return }
////                await ExpenseRepository.shared.fetchExpenses(groupID: groupID)
////            }
////        }
////    }
//    
//} // End extension
