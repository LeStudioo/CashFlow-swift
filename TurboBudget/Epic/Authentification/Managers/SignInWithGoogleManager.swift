//
//  SignInWithGoogleManager.swift
//  Split
//
//  Created by KaayZenn on 29/05/2024.
//

// https://paulallies.medium.com/google-sign-in-swiftui-2909e01ea4ed
// https://github.com/google/GoogleSignIn-iOS/issues/378
import SwiftUI
import GoogleSignIn
import NetworkKit
import StatsKit
import CoreModule

class SignInWithGoogleManager: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""
    
}

extension SignInWithGoogleManager {
    
    func getUserInfo() async {
        if GIDSignIn.sharedInstance.currentUser != nil {
            let user = GIDSignIn.sharedInstance.currentUser
            guard user != nil else { return }
            
            self.isLoggedIn = true
        } else {
            self.isLoggedIn = false
        }
    }
    
    @MainActor
    func signIn() {
       guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController
        else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { user, error in
            if let error {
                self.errorMessage = "Google Error: \(error.localizedDescription)"
                return
            }
            
            guard let user else { return }
            guard let googleToken = user.user.idToken else { return }
            
            Task {
                await self.getUserInfo()
                
                let user = try await NetworkService.sendRequest(
                    apiBuilder: AuthAPIRequester.google(body: .init(identityToken: googleToken.tokenString)),
                    responseModel: UserModel.self
                )
                
                if let token = user.token, let refreshToken = user.refreshToken {
                    TokenManager.shared.setTokenAndRefreshToken(token: token, refreshToken: refreshToken)
                    UserStore.shared.currentUser = user
                    AppManager.shared.appState = .success
                    
                    EventService.sendEvent(key: EventKeys.userRegisterGoogle)
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
