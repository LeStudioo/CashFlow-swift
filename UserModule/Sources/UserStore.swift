//
//  UserStore.swift
//  Split
//
//  Created by Theo Sementa on 28/05/2024.
//

import Foundation
import NetworkKit
import CoreModule

public final class UserStore: ObservableObject {
    public static let shared = UserStore()
        
    @Published public var currentUser: UserModel?
    
    public var isUserLogged: Bool {
        return currentUser != nil
    }
}

public extension UserStore {
    
    @MainActor
    func register(body: UserModel) async {
        do {
            let user = try await NetworkService.sendRequest(
                apiBuilder: UserAPIRequester.register(body: body),
                responseModel: UserModel.self
            )
                        
            if let token = user.token, let refreshToken = user.refreshToken {
                TokenManager.shared.setTokenAndRefreshToken(token: token, refreshToken: refreshToken)
            }
            
            self.currentUser = user
        } catch {
            self.currentUser = nil
            // TODO: NETWORK ERROR
//            if let networkError = error as? NetworkError {
//                if networkError == .fieldIsIncorrectlyFilled {
//                    BannerManager.shared.banner = Banner.emailInvalid
//                } else {
//                    BannerManager.shared.banner = networkError.banner
//                }
//            }
        }
    }
    
    @MainActor
    func signOut() async {
        TokenManager.shared.setTokenAndRefreshToken(token: "", refreshToken: "")
        self.currentUser = nil
        AppManager.shared.appState = .needLogin
    }
    
    @MainActor
    func update(body: UserModel) async {
        do {
            let updatedUser = try await UserService.update(body: body)
            self.currentUser = updatedUser
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func deleteAccount() async {
        do {
            try await NetworkService.sendRequest(
                apiBuilder: UserAPIRequester.delete
            )
            TokenManager.shared.setTokenAndRefreshToken(token: "", refreshToken: "")
            self.currentUser = nil
            AppManager.shared.appState = .needLogin
        } catch { NetworkService.handleError(error: error) }
    }
}
