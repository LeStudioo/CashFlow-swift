//
//  UserStore.swift
//  Split
//
//  Created by Theo Sementa on 28/05/2024.
//

import Foundation

final class UserStore: ObservableObject {
    static let shared = UserStore()
        
    @Published var currentUser: UserModel?
    
    var isUserLogged: Bool {
        return currentUser != nil
    }
}

extension UserStore {
    
    @MainActor
    func register(body: UserModel) async {
        do {
            let user = try await NetworkService.shared.sendRequest(
                apiBuilder: UserAPIRequester.register(body: body),
                responseModel: UserModel.self
            )
                        
            if let token = user.token, let refreshToken = user.refreshToken {
                TokenManager.shared.setTokenAndRefreshToken(token: token, refreshToken: refreshToken)
            }
            
            self.currentUser = user
        } catch {
            self.currentUser = nil
            if let networkError = error as? NetworkError {
                if networkError == .fieldIsIncorrectlyFilled {
                    BannerManager.shared.banner = Banner.emailInvalid
                } else {
                    BannerManager.shared.banner = networkError.banner
                }
            }
        }
    }
    
    @MainActor
    func loginWithToken() async throws {
        try await TokenManager.shared.refreshToken()
    }
    
    @MainActor
    func signOut() async {
        TokenManager.shared.setTokenAndRefreshToken(token: "", refreshToken: "")
        self.currentUser = nil
        AppManager.shared.viewState = .failed
    }
    
    @MainActor
    func deleteAccount() async {
        do {
            try await NetworkService.shared.sendRequest(
                apiBuilder: UserAPIRequester.delete
            )
            TokenManager.shared.setTokenAndRefreshToken(token: "", refreshToken: "")
            self.currentUser = nil
            AppManager.shared.viewState = .failed
        } catch { NetworkService.handleError(error: error) }
    }
}
