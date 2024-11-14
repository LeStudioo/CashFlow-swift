//
//  SignInWithGoogleManager.swift
//  Split
//
//  Created by KaayZenn on 29/05/2024.
//

// https://paulallies.medium.com/google-sign-in-swiftui-2909e01ea4ed
import SwiftUI
import GoogleSignIn

class SignInWithGoogleManager: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""
    
    // init
    init() {
        check()
    }
    
}

extension SignInWithGoogleManager {
    
    func getUserInfo() async {
        if (GIDSignIn.sharedInstance.currentUser != nil) {
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else { return }
            
            self.isLoggedIn = true
        } else {
            self.isLoggedIn = false
        }
    }
    
    func check() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error {
                self.errorMessage = "error: \(error.localizedDescription)"
            }
            
            Task {
                await self.getUserInfo()
            }
        }
    }
    
    @MainActor
    func signIn(router: NavigationManager) {
        
       guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { user, error in
            if let error {
                self.errorMessage = "error: \(error.localizedDescription)"
                return
            }
            
            guard let user else { return }
            guard let googleToken = user.user.idToken else { return }
            
            Task {
                await self.getUserInfo()
                
                let user = try await NetworkService.shared.sendRequest(
                    apiBuilder: AuthAPIRequester.google(body: .init(identityToken: googleToken.tokenString)),
                    responseModel: UserModel.self
                )
                
                if let token = user.token, let refreshToken = user.refreshToken {
                    TokenManager.shared.setTokenAndRefreshToken(token: token, refreshToken: refreshToken)
                    AppManager.shared.viewState = .success
                    UserRepository.shared.currentUser = user
                }
            }
        }
    } // End SignIn
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        Task {
            await self.getUserInfo() // Pourquoi faire ?
        }
    }
    
}
