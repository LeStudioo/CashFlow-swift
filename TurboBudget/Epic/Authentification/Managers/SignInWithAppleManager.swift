////
////  SignInWithAppleManager.swift
////  Split
////
////  Created by KaayZenn on 29/05/2024.
////
//
//import Foundation
//import AuthenticationServices
//import NetworkKit
//import StatsKit
//import CoreModule
//
//class SignInWithAppleManager: NSObject {
//    
//    func performSignIn() {
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.email]
//        
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
//    }
//}
//
//extension SignInWithAppleManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//            
//            guard let appleIDToken = appleIDCredential.identityToken else { return }
//            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else { return }
//                        
//            Task {
//                let user = try await NetworkService.sendRequest(
//                    apiBuilder: AuthAPIRequester.apple(body: .init(identityToken: idTokenString)),
//                    responseModel: UserModel.self
//                )
//                
//                if let token = user.token, let refreshToken = user.refreshToken {
//                    TokenManager.shared.setTokenAndRefreshToken(token: token, refreshToken: refreshToken)
//                    UserStore.shared.currentUser = user
//                    AppManager.shared.appState = .success
//                    
//                    EventService.sendEvent(key: EventKeys.userRegisterApple)
//                }
//            }
//        }
//    }
//    
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        print("Sign in with Apple errored: \(error.localizedDescription)")
//    }
//    
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first ?? UIWindow()
//    }
//}
