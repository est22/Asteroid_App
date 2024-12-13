//
//  AppleAuthViewModel.swift
//  Asteroid_front
//
//  Created by Lia An on 12/5/24.
//

import Foundation
import AuthenticationServices
import Alamofire

class AppleAuthViewModel: NSObject, ObservableObject {
    @Published var appleSignInError: String?
    private var authViewModel: AuthViewModel
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        super.init()
    }
    
    func handleSignInWithApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    private func signInWithApple(userId: String, email: String?) {
        let parameters: [String: Any] = [
            "apple_id": userId,
            "email": email as Any
        ]
        
        AF.request("\(APIConstants.baseURL)/auth/apple-login",
                  method: .post,
                  parameters: parameters,
                  encoding: JSONEncoding.default)
        .responseDecodable(of: LoginResponse.self) { [weak self] response in
            switch response.result {
            case .success(let loginResponse):
                UserDefaults.standard.set(loginResponse.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(loginResponse.refreshToken, forKey: "refreshToken")
                UserDefaults.standard.set(loginResponse.isProfileSet, forKey: "hasCompletedInitialProfile")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.synchronize()
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.authViewModel.updateLoginState(
                        isLoggedIn: true,
                        isProfileSet: loginResponse.isProfileSet
                    )
                    print("State updated - isLoggedIn: \(self.authViewModel.isLoggedIn), isProfileSet: \(self.authViewModel.isInitialProfileSet)")
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.appleSignInError = "Apple 로그인에 실패했습니다."
                }
            }
        }
    }
}

extension AppleAuthViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userId = appleIDCredential.user
            let email = appleIDCredential.email
            
            print("Apple User ID: \(userId)")
            print("Apple User Email: \(email ?? "No email")")
            
            signInWithApple(userId: userId, email: email)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign In Error: \(error.localizedDescription)")
        self.appleSignInError = "Apple 로그인에 실패했습니다."
    }
}